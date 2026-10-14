package app.pokefolio.pricing;

import app.pokefolio.catalog.PokemonCard;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import app.pokefolio.common.BaseEntity;
import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

/** A dated market price for one card from one source. Immutable once stored. */
@Entity
@Table(name = "price_observations")
public class PriceObservation extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "card_id")
    private PokemonCard card;

    @Column(name = "card_id", insertable = false, updatable = false)
    private UUID cardId;

    @Column(nullable = false)
    private String source;

    @Column(nullable = false, length = 3)
    private String currency;

    @Column(name = "market_price", nullable = false)
    private BigDecimal marketPrice;

    @Column(name = "low_price")
    private BigDecimal lowPrice;

    @Column(name = "high_price")
    private BigDecimal highPrice;

    @Column(name = "sample_data", nullable = false)
    private boolean sampleData;

    @Column(name = "observed_at", nullable = false)
    private Instant observedAt;

    @Column(name = "created_at", nullable = false)
    private Instant createdAt;

    protected PriceObservation() {
    }

    public PriceObservation(PokemonCard card, String source, String currency, BigDecimal marketPrice,
            BigDecimal lowPrice, BigDecimal highPrice, boolean sampleData, Instant observedAt, Instant now) {
        this.card = card;
        this.cardId = card.getId();
        this.source = source;
        this.currency = currency;
        this.marketPrice = marketPrice;
        this.lowPrice = lowPrice;
        this.highPrice = highPrice;
        this.sampleData = sampleData;
        this.observedAt = observedAt;
        this.createdAt = now;
    }

    public UUID getCardId() {
        return cardId;
    }

    public String getSource() {
        return source;
    }

    public String getCurrency() {
        return currency;
    }

    public BigDecimal getMarketPrice() {
        return marketPrice;
    }

    public BigDecimal getLowPrice() {
        return lowPrice;
    }

    public BigDecimal getHighPrice() {
        return highPrice;
    }

    public boolean isSampleData() {
        return sampleData;
    }

    public Instant getObservedAt() {
        return observedAt;
    }
}
