package app.pokefolio.transaction;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.OneToMany;
import jakarta.persistence.OrderBy;
import jakarta.persistence.Table;
import app.pokefolio.common.BaseEntity;
import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/** An immutable record of how copies entered or left a collection. */
@Entity
@Table(name = "transactions")
public class Transaction extends BaseEntity {

    @Column(name = "user_id", nullable = false, updatable = false)
    private UUID userId;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private TransactionType type;

    @Column(name = "occurred_on", nullable = false)
    private LocalDate occurredOn;

    @Column(nullable = false, length = 3)
    private String currency;

    @Column(name = "cash_in")
    private BigDecimal cashIn;

    @Column(name = "cash_out")
    private BigDecimal cashOut;

    private BigDecimal fees;

    private String notes;

    @Column(name = "created_at", nullable = false)
    private Instant createdAt;

    @OneToMany(mappedBy = "transaction", cascade = CascadeType.ALL, orphanRemoval = true)
    @OrderBy("direction desc")
    private List<TransactionLine> lines = new ArrayList<>();

    protected Transaction() {
    }

    public Transaction(UUID userId, TransactionType type, LocalDate occurredOn, String currency, BigDecimal cashIn,
            BigDecimal cashOut, BigDecimal fees, String notes, Instant now) {
        this.userId = userId;
        this.type = type;
        this.occurredOn = occurredOn;
        this.currency = currency;
        this.cashIn = cashIn;
        this.cashOut = cashOut;
        this.fees = fees;
        this.notes = notes;
        this.createdAt = now;
    }

    public void addLine(TransactionLine line) {
        lines.add(line);
    }

    public UUID getUserId() {
        return userId;
    }

    public TransactionType getType() {
        return type;
    }

    public LocalDate getOccurredOn() {
        return occurredOn;
    }

    public String getCurrency() {
        return currency;
    }

    public BigDecimal getCashIn() {
        return cashIn;
    }

    public BigDecimal getCashOut() {
        return cashOut;
    }

    public BigDecimal getFees() {
        return fees;
    }

    public String getNotes() {
        return notes;
    }

    public Instant getCreatedAt() {
        return createdAt;
    }

    public List<TransactionLine> getLines() {
        return lines;
    }
}
