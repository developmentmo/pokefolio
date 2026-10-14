package app.pokefolio.catalog;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import app.pokefolio.common.BaseEntity;
import java.time.Instant;
import java.util.UUID;

/** A catalog card (one printing), shared by all users. Physical copies are {@code CardHolding}s. */
@Entity
@Table(name = "pokemon_cards")
public class PokemonCard extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "set_id")
    private CardSet set;

    @Column(nullable = false)
    private String provider;

    @Column(name = "external_id", nullable = false)
    private String externalId;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false)
    private String number;

    private String rarity;

    private String supertype;

    @Column(name = "pokemon_type")
    private String pokemonType;

    @Column(name = "image_url")
    private String imageUrl;

    @Column(name = "image_url_large")
    private String imageUrlLarge;

    @Column(name = "created_at", nullable = false)
    private Instant createdAt;

    @Column(name = "updated_at", nullable = false)
    private Instant updatedAt;

    protected PokemonCard() {
    }

    public PokemonCard(CardSet set, String provider, String externalId, Instant now) {
        this.set = set;
        this.provider = provider;
        this.externalId = externalId;
        this.createdAt = now;
        this.updatedAt = now;
    }

    public void update(String name, String number, String rarity, String supertype, String pokemonType,
            String imageUrl, String imageUrlLarge, Instant now) {
        this.name = name;
        this.number = number;
        this.rarity = rarity;
        this.supertype = supertype;
        this.pokemonType = pokemonType;
        this.imageUrl = imageUrl;
        this.imageUrlLarge = imageUrlLarge;
        this.updatedAt = now;
    }

    public CardSet getSet() {
        return set;
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

    public String getNumber() {
        return number;
    }

    public String getRarity() {
        return rarity;
    }

    public String getSupertype() {
        return supertype;
    }

    public String getPokemonType() {
        return pokemonType;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public String getImageUrlLarge() {
        return imageUrlLarge;
    }
}
