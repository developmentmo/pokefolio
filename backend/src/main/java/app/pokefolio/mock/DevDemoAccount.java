package app.pokefolio.mock;

import app.pokefolio.account.User;
import app.pokefolio.account.UserRepository;
import app.pokefolio.catalog.PokemonCard;
import app.pokefolio.catalog.PokemonCardRepository;
import app.pokefolio.portfolio.CardCondition;
import app.pokefolio.portfolio.CardHolding;
import app.pokefolio.portfolio.CardLanguage;
import app.pokefolio.portfolio.CardVariant;
import app.pokefolio.portfolio.HoldingDtos.AddHoldingRequest;
import app.pokefolio.transaction.TransactionDtos.SaleRequest;
import app.pokefolio.transaction.TransactionService;
import java.math.BigDecimal;
import java.time.Clock;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.annotation.Profile;
import org.springframework.context.event.EventListener;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

/**
 * Development only: creates the same demo account the offline Flutter app offers, with a small sample collection,
 * so the README credentials also work against a local backend. Never active outside the {@code dev} profile.
 */
@Component
@Profile("dev")
class DevDemoAccount {

    static final String EMAIL = "demo@pokefolio.app";
    static final String PASSWORD = "pokefolio-demo";

    private static final Logger log = LoggerFactory.getLogger(DevDemoAccount.class);

    private final UserRepository users;
    private final PokemonCardRepository cards;
    private final TransactionService transactions;
    private final PasswordEncoder passwordEncoder;
    private final Clock clock;

    DevDemoAccount(UserRepository users, PokemonCardRepository cards, TransactionService transactions,
            PasswordEncoder passwordEncoder, Clock clock) {
        this.users = users;
        this.cards = cards;
        this.transactions = transactions;
        this.passwordEncoder = passwordEncoder;
        this.clock = clock;
    }

    /** Runs after the catalog bootstrap so the sample cards exist. */
    @EventListener(ApplicationReadyEvent.class)
    @Order(Ordered.LOWEST_PRECEDENCE)
    void seed() {
        if (users.existsByEmail(EMAIL)) {
            return;
        }
        User user = users.save(new User(EMAIL, passwordEncoder.encode(PASSWORD), "Demo Trainer", "EUR",
                clock.instant()));
        UUID id = user.getId();
        LocalDate today = LocalDate.now(clock);
        add(id, "base1-4", 1, CardCondition.EXCELLENT, CardVariant.UNLIMITED, CardLanguage.EN, "350.00", today, 300);
        add(id, "swsh7-215", 1, CardCondition.NEAR_MINT, CardVariant.HOLO, CardLanguage.EN, "980.00", today, 210);
        add(id, "sv3pt5-199", 2, CardCondition.MINT, CardVariant.HOLO, CardLanguage.EN, "110.00", today, 120);
        List<CardHolding> pikachus =
                add(id, "sv3pt5-025", 4, CardCondition.NEAR_MINT, CardVariant.NORMAL, CardLanguage.EN, "0.50", today, 90);
        add(id, "neo2-13", 1, CardCondition.GOOD, CardVariant.HOLO, CardLanguage.EN, "60.00", today, 80);
        add(id, "sv8pt5-161", 1, CardCondition.MINT, CardVariant.HOLO, CardLanguage.JA, null, today, 40);
        add(id, "swsh8-271", 1, CardCondition.NEAR_MINT, CardVariant.HOLO, CardLanguage.EN, "300.00", today, 60);
        transactions.recordSale(id, new SaleRequest(List.of(pikachus.getFirst().getId()), today.minusDays(20),
                new BigDecimal("1.50"), new BigDecimal("0.20"), "Cardmarket"));
        log.info("[DEV ONLY] Demo account {} created with a sample collection", EMAIL);
    }

    private List<CardHolding> add(UUID userId, String externalId, int quantity, CardCondition condition,
            CardVariant variant, CardLanguage language, String price, LocalDate today, int daysAgo) {
        PokemonCard card = cards.findByProviderAndExternalId(MockCardCatalogProvider.PROVIDER_ID, externalId)
                .orElseThrow(() -> new IllegalStateException("Mock card missing: " + externalId));
        return transactions.recordPurchase(userId, new AddHoldingRequest(card.getId(), quantity, condition, language,
                variant, price == null ? null : new BigDecimal(price), today.minusDays(daysAgo), null));
    }
}
