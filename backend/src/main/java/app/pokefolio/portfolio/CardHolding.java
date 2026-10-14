package app.pokefolio.portfolio;

import app.pokefolio.catalog.PokemonCard;
import app.pokefolio.common.ConflictException;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import app.pokefolio.common.BaseEntity;
import jakarta.persistence.Version;
import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.UUID;

/**
 * One physical copy of a catalog card owned by a user. Copies are never deleted when they leave the collection;
 * their status and disposal date are kept so history and past valuations stay correct.
 */
@Entity
@Table(name = "card_holdings")
public class CardHolding extends BaseEntity {

    @Column(name = "user_id", nullable = false, updatable = false)
    private UUID userId;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "card_id")
    private PokemonCard card;

    @Enumerated(EnumType.STRING)
    @Column(name = "card_condition", nullable = false)
    private CardCondition condition;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private CardLanguage language;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private CardVariant variant;

    @Column(name = "purchase_price")
    private BigDecimal purchasePrice;

    @Column(name = "purchase_currency", nullable = false, length = 3)
    private String purchaseCurrency;

    @Column(name = "purchase_date")
    private LocalDate purchaseDate;

    @Column(name = "acquired_on", nullable = false)
    private LocalDate acquiredOn;

    private String notes;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private HoldingStatus status;

    @Column(name = "disposed_on")
    private LocalDate disposedOn;

    @Column(name = "created_at", nullable = false)
    private Instant createdAt;

    @Column(name = "updated_at", nullable = false)
    private Instant updatedAt;

    @Version
    private long version;

    protected CardHolding() {
    }

    public CardHolding(UUID userId, PokemonCard card, CardAttributes attributes, String currency,
            LocalDate acquiredOn, Instant now) {
        this.userId = userId;
        this.card = card;
        this.purchaseCurrency = currency;
        this.acquiredOn = acquiredOn;
        this.status = HoldingStatus.ACTIVE;
        this.createdAt = now;
        apply(attributes, now);
    }

    public void apply(CardAttributes attributes, Instant now) {
        this.condition = attributes.condition();
        this.language = attributes.language();
        this.variant = attributes.variant();
        this.purchasePrice = attributes.purchasePrice();
        this.purchaseDate = attributes.purchaseDate();
        this.notes = attributes.notes();
        this.updatedAt = now;
    }

    /** Moves the copy out of the collection. */
    public void dispose(HoldingStatus newStatus, LocalDate on, Instant now) {
        if (status != HoldingStatus.ACTIVE) {
            throw new ConflictException("Copy " + getId() + " is no longer in the collection");
        }
        if (newStatus == HoldingStatus.ACTIVE) {
            throw new IllegalArgumentException("Disposal status must not be ACTIVE");
        }
        this.status = newStatus;
        this.disposedOn = on;
        this.updatedAt = now;
    }

    public boolean isActive() {
        return status == HoldingStatus.ACTIVE;
    }

    public UUID getUserId() {
        return userId;
    }

    public PokemonCard getCard() {
        return card;
    }

    public CardCondition getCondition() {
        return condition;
    }

    public CardLanguage getLanguage() {
        return language;
    }

    public CardVariant getVariant() {
        return variant;
    }

    public BigDecimal getPurchasePrice() {
        return purchasePrice;
    }

    public String getPurchaseCurrency() {
        return purchaseCurrency;
    }

    public LocalDate getPurchaseDate() {
        return purchaseDate;
    }

    public LocalDate getAcquiredOn() {
        return acquiredOn;
    }

    public void setAcquiredOn(LocalDate acquiredOn) {
        this.acquiredOn = acquiredOn;
    }

    public String getNotes() {
        return notes;
    }

    public HoldingStatus getStatus() {
        return status;
    }

    public LocalDate getDisposedOn() {
        return disposedOn;
    }

    public Instant getCreatedAt() {
        return createdAt;
    }

    /** Descriptive attributes of a physical copy that the user may edit. */
    public record CardAttributes(CardCondition condition, CardLanguage language, CardVariant variant,
            BigDecimal purchasePrice, LocalDate purchaseDate, String notes) {
    }
}
