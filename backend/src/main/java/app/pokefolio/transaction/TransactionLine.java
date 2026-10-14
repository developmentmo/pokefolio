package app.pokefolio.transaction;

import app.pokefolio.catalog.PokemonCard;
import app.pokefolio.portfolio.CardHolding;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import app.pokefolio.common.BaseEntity;
import java.math.BigDecimal;
import java.util.UUID;

/**
 * One copy moving in or out. {@code allocatedAmount} is the copy's share of the money involved: purchase price
 * for purchases and received trade cards, net proceeds for sales.
 */
@Entity
@Table(name = "transaction_lines")
public class TransactionLine extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "transaction_id")
    private Transaction transaction;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "holding_id")
    private CardHolding holding;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "card_id")
    private PokemonCard card;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private LineDirection direction;

    @Column(name = "allocated_amount")
    private BigDecimal allocatedAmount;

    protected TransactionLine() {
    }

    public TransactionLine(Transaction transaction, CardHolding holding, LineDirection direction,
            BigDecimal allocatedAmount) {
        this.transaction = transaction;
        this.holding = holding;
        this.card = holding.getCard();
        this.direction = direction;
        this.allocatedAmount = allocatedAmount;
    }

    public Transaction getTransaction() {
        return transaction;
    }

    public CardHolding getHolding() {
        return holding;
    }

    public PokemonCard getCard() {
        return card;
    }

    public LineDirection getDirection() {
        return direction;
    }

    public BigDecimal getAllocatedAmount() {
        return allocatedAmount;
    }
}
