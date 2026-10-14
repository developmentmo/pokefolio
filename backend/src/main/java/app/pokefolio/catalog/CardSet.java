package app.pokefolio.catalog;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import app.pokefolio.common.BaseEntity;
import java.time.Instant;
import java.time.LocalDate;
import java.util.UUID;

@Entity
@Table(name = "card_sets")
public class CardSet extends BaseEntity {

    @Column(nullable = false)
    private String provider;

    @Column(name = "external_id", nullable = false)
    private String externalId;

    @Column(nullable = false)
    private String name;

    private String series;

    @Column(name = "release_date")
    private LocalDate releaseDate;

    @Column(name = "total_cards")
    private Integer totalCards;

    @Column(name = "created_at", nullable = false)
    private Instant createdAt;

    @Column(name = "updated_at", nullable = false)
    private Instant updatedAt;

    protected CardSet() {
    }

    public CardSet(String provider, String externalId, Instant now) {
        this.provider = provider;
        this.externalId = externalId;
        this.createdAt = now;
        this.updatedAt = now;
    }

    public void update(String name, String series, LocalDate releaseDate, Integer totalCards, Instant now) {
        this.name = name;
        this.series = series;
        this.releaseDate = releaseDate;
        this.totalCards = totalCards;
        this.updatedAt = now;
    }

    public String getProvider() {
        return provider;
    }

    public String getExternalId() {
        return externalId;
    }

    public String getName() {
        return name;
    }

    public String getSeries() {
        return series;
    }

    public LocalDate getReleaseDate() {
        return releaseDate;
    }

    public Integer getTotalCards() {
        return totalCards;
    }
}
