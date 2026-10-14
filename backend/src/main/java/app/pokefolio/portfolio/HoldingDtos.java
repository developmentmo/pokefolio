package app.pokefolio.portfolio;

import app.pokefolio.catalog.CatalogDtos.CardDto;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Digits;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.PastOrPresent;
import jakarta.validation.constraints.Size;
import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

public final class HoldingDtos {

    private HoldingDtos() {
    }

    /** Adds {@code quantity} identical copies, recorded as one PURCHASE transaction. */
    public record AddHoldingRequest(
            @NotNull UUID cardId,
            @Min(1) @Max(100) int quantity,
            @NotNull CardCondition condition,
            @NotNull CardLanguage language,
            @NotNull CardVariant variant,
            @DecimalMin("0.00") @Digits(integer = 10, fraction = 2) BigDecimal purchasePrice,
            @PastOrPresent LocalDate purchaseDate,
            @Size(max = 2000) String notes) {
    }

    public record UpdateHoldingRequest(
            @NotNull CardCondition condition,
            @NotNull CardLanguage language,
            @NotNull CardVariant variant,
            @DecimalMin("0.00") @Digits(integer = 10, fraction = 2) BigDecimal purchasePrice,
            @PastOrPresent LocalDate purchaseDate,
            @Size(max = 2000) String notes) {
    }

    /**
     * @param marketValue    latest market price of this copy, null when unknown
     * @param unrealizedGain marketValue - purchasePrice, null when either is unknown
     */
    public record HoldingDto(UUID id, CardDto card, CardCondition condition, CardLanguage language,
            CardVariant variant, BigDecimal purchasePrice, String purchaseCurrency, LocalDate purchaseDate,
            LocalDate acquiredOn, String notes, HoldingStatus status, LocalDate disposedOn,
            BigDecimal marketValue, BigDecimal unrealizedGain, Instant createdAt) {
    }

    /** All current copies of one catalog card. */
    public record CollectionEntryDto(CardDto card, int copies, BigDecimal marketValue, BigDecimal costBasis,
            int copiesWithoutCost, BigDecimal unrealizedGain, Instant lastAddedAt, List<HoldingDto> holdings) {
    }
}
