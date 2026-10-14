package app.pokefolio.transaction;

import app.pokefolio.catalog.PokemonCard;
import app.pokefolio.catalog.PokemonCardRepository;
import app.pokefolio.common.BadRequestException;
import app.pokefolio.common.Money;
import app.pokefolio.common.NotFoundException;
import app.pokefolio.portfolio.CardHolding;
import app.pokefolio.portfolio.CardHolding.CardAttributes;
import app.pokefolio.portfolio.CardHoldingRepository;
import app.pokefolio.portfolio.HoldingDtos.AddHoldingRequest;
import app.pokefolio.portfolio.HoldingStatus;
import app.pokefolio.portfolio.ValuationCalculator;
import app.pokefolio.pricing.PricingProperties;
import app.pokefolio.transaction.TransactionDtos.CardRefDto;
import app.pokefolio.transaction.TransactionDtos.CorrectionRequest;
import app.pokefolio.transaction.TransactionDtos.GiftRequest;
import app.pokefolio.transaction.TransactionDtos.LineDto;
import app.pokefolio.transaction.TransactionDtos.ReceivedCard;
import app.pokefolio.transaction.TransactionDtos.SaleRequest;
import app.pokefolio.transaction.TransactionDtos.TradeRequest;
import app.pokefolio.transaction.TransactionDtos.TransactionDto;
import java.math.BigDecimal;
import java.time.Clock;
import java.time.Instant;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.function.Function;
import java.util.stream.Collectors;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * The only place where copies enter or leave a collection. Every operation runs in one database transaction,
 * so a failing step (unknown card, copy already sold, ...) leaves the collection untouched.
 */
@Service
public class TransactionService {

    private final TransactionRepository transactions;
    private final CardHoldingRepository holdings;
    private final PokemonCardRepository cards;
    private final PricingProperties pricing;
    private final Clock clock;

    public TransactionService(TransactionRepository transactions, CardHoldingRepository holdings,
            PokemonCardRepository cards, PricingProperties pricing, Clock clock) {
        this.transactions = transactions;
        this.holdings = holdings;
        this.cards = cards;
        this.pricing = pricing;
        this.clock = clock;
    }

    @Transactional
    public List<CardHolding> recordPurchase(UUID userId, AddHoldingRequest request) {
        Instant now = clock.instant();
        LocalDate date = request.purchaseDate() != null ? request.purchaseDate() : LocalDate.now(clock);
        PokemonCard card = loadCard(request.cardId());
        BigDecimal unitPrice = Money.normalize(request.purchasePrice());
        BigDecimal total = unitPrice == null ? null : unitPrice.multiply(BigDecimal.valueOf(request.quantity()));
        Transaction tx = new Transaction(userId, TransactionType.PURCHASE, date, pricing.currency(), null, total, null,
                request.notes(), now);
        List<CardHolding> created = new ArrayList<>();
        for (int i = 0; i < request.quantity(); i++) {
            CardHolding holding = holdings.save(new CardHolding(userId, card,
                    new CardAttributes(request.condition(), request.language(), request.variant(), unitPrice,
                            request.purchaseDate(), request.notes()),
                    pricing.currency(), date, now));
            tx.addLine(new TransactionLine(tx, holding, LineDirection.IN, unitPrice));
            created.add(holding);
        }
        transactions.save(tx);
        return created;
    }

    @Transactional
    public TransactionDto recordSale(UUID userId, SaleRequest request) {
        BigDecimal fees = Money.normalize(request.fees());
        BigDecimal proceeds = Money.normalize(request.proceeds());
        List<CardHolding> copies = lockActive(userId, request.holdingIds(), request.date());
        Transaction tx = new Transaction(userId, TransactionType.SALE, request.date(), pricing.currency(), proceeds,
                null, fees, request.notes(), clock.instant());
        List<BigDecimal> shares = ValuationCalculator.allocate(proceeds.subtract(Money.orZero(fees)), copies.size());
        for (int i = 0; i < copies.size(); i++) {
            CardHolding copy = copies.get(i);
            copy.dispose(HoldingStatus.SOLD, request.date(), clock.instant());
            tx.addLine(new TransactionLine(tx, copy, LineDirection.OUT, shares.get(i)));
        }
        return toDto(transactions.save(tx));
    }

    @Transactional
    public TransactionDto recordGift(UUID userId, GiftRequest request) {
        return disposeWithoutMoney(userId, request.holdingIds(), request.date(), request.notes(),
                TransactionType.GIFT, HoldingStatus.GIVEN_AWAY);
    }

    @Transactional
    public TransactionDto recordCorrection(UUID userId, CorrectionRequest request) {
        return disposeWithoutMoney(userId, request.holdingIds(), request.date(), request.notes(),
                TransactionType.CORRECTION, HoldingStatus.REMOVED);
    }

    /** Given copies leave and received copies are created, atomically. */
    @Transactional
    public TransactionDto recordTrade(UUID userId, TradeRequest request) {
        BigDecimal cashIn = Money.normalize(request.cashReceived());
        BigDecimal cashOut = Money.normalize(request.cashPaid());
        if (cashIn != null && cashOut != null && cashIn.signum() > 0 && cashOut.signum() > 0) {
            throw new BadRequestException("A trade can have cash received or cash paid, not both");
        }
        Instant now = clock.instant();
        List<CardHolding> given = lockActive(userId, request.givenHoldingIds(), request.date());
        Map<UUID, PokemonCard> receivedCards = loadCards(request.received().stream().map(ReceivedCard::cardId).toList());

        Transaction tx = new Transaction(userId, TransactionType.TRADE, request.date(), pricing.currency(), cashIn,
                cashOut, null, request.notes(), now);
        for (CardHolding copy : given) {
            copy.dispose(HoldingStatus.TRADED_AWAY, request.date(), now);
            tx.addLine(new TransactionLine(tx, copy, LineDirection.OUT, null));
        }
        for (ReceivedCard received : request.received()) {
            PokemonCard card = receivedCards.get(received.cardId());
            BigDecimal value = Money.normalize(received.value());
            for (int i = 0; i < received.quantity(); i++) {
                CardHolding copy = holdings.save(new CardHolding(userId, card,
                        new CardAttributes(received.condition(), received.language(), received.variant(), value,
                                request.date(), received.notes()),
                        pricing.currency(), request.date(), now));
                tx.addLine(new TransactionLine(tx, copy, LineDirection.IN, value));
            }
        }
        return toDto(transactions.save(tx));
    }

    @Transactional(readOnly = true)
    public Page<TransactionDto> list(UUID userId, TransactionType type, LocalDate from, LocalDate to, int page,
            int size) {
        return transactions.search(userId, type, from, to, PageRequest.of(page, size,
                        Sort.by(Sort.Order.desc("occurredOn"), Sort.Order.desc("createdAt"))))
                .map(this::toDto);
    }

    @Transactional(readOnly = true)
    public TransactionDto get(UUID userId, UUID id) {
        return transactions.findByIdAndUserId(id, userId).map(this::toDto)
                .orElseThrow(() -> new NotFoundException("Transaction not found"));
    }

    private TransactionDto disposeWithoutMoney(UUID userId, List<UUID> ids, LocalDate date, String notes,
            TransactionType type, HoldingStatus status) {
        List<CardHolding> copies = lockActive(userId, ids, date);
        Transaction tx = new Transaction(userId, type, date, pricing.currency(), null, null, null, notes,
                clock.instant());
        for (CardHolding copy : copies) {
            copy.dispose(status, date, clock.instant());
            tx.addLine(new TransactionLine(tx, copy, LineDirection.OUT, null));
        }
        return toDto(transactions.save(tx));
    }

    /**
     * Loads and locks the user's copies. Copies of other users are reported as not found, exactly like
     * non-existent ids, so ids of other users' copies cannot be probed.
     */
    private List<CardHolding> lockActive(UUID userId, List<UUID> ids, LocalDate date) {
        if (new HashSet<>(ids).size() != ids.size()) {
            throw new BadRequestException("The same copy was selected more than once");
        }
        if (date.isAfter(LocalDate.now(clock))) {
            throw new BadRequestException("Date cannot be in the future");
        }
        Map<UUID, CardHolding> found = holdings.lockAllByUserIdAndIdIn(userId, ids).stream()
                .collect(Collectors.toMap(CardHolding::getId, Function.identity()));
        List<CardHolding> ordered = new ArrayList<>();
        for (UUID id : ids) {
            CardHolding copy = found.get(id);
            if (copy == null) {
                throw new NotFoundException("Copy " + id + " not found");
            }
            if (!copy.isActive()) {
                throw new app.pokefolio.common.ConflictException("Copy " + id + " is no longer in the collection");
            }
            if (date.isBefore(copy.getAcquiredOn())) {
                throw new BadRequestException("Date is before copy " + id + " was acquired");
            }
            ordered.add(copy);
        }
        return ordered;
    }

    private PokemonCard loadCard(UUID cardId) {
        return cards.findWithSetById(cardId).orElseThrow(() -> new NotFoundException("Card " + cardId + " not found"));
    }

    private Map<UUID, PokemonCard> loadCards(List<UUID> ids) {
        Map<UUID, PokemonCard> found = cards.findAllByIdIn(new HashSet<>(ids)).stream()
                .collect(Collectors.toMap(PokemonCard::getId, Function.identity()));
        for (UUID id : ids) {
            if (!found.containsKey(id)) {
                throw new NotFoundException("Card " + id + " not found");
            }
        }
        return found;
    }

    TransactionDto toDto(Transaction tx) {
        List<LineDto> lines = tx.getLines().stream().map(line -> {
            CardHolding h = line.getHolding();
            PokemonCard c = line.getCard();
            return new LineDto(h.getId(), line.getDirection(), line.getAllocatedAmount(),
                    new CardRefDto(c.getId(), c.getName(), c.getNumber(), c.getSet().getName(), c.getRarity()),
                    h.getCondition(), h.getLanguage(), h.getVariant(), h.getPurchasePrice());
        }).toList();
        BigDecimal realized = null;
        if (tx.getType() == TransactionType.SALE) {
            BigDecimal gain = Money.zero();
            boolean any = false;
            for (TransactionLine line : tx.getLines()) {
                BigDecimal cost = line.getHolding().getPurchasePrice();
                if (cost != null && line.getAllocatedAmount() != null) {
                    gain = gain.add(line.getAllocatedAmount().subtract(cost));
                    any = true;
                }
            }
            realized = any ? gain : null;
        }
        return new TransactionDto(tx.getId(), tx.getType(), tx.getOccurredOn(), tx.getCurrency(), tx.getCashIn(),
                tx.getCashOut(), tx.getFees(), tx.getNotes(), tx.getCreatedAt(), lines, realized);
    }
}
