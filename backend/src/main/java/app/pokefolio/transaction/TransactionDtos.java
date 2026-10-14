package app.pokefolio.transaction;

import app.pokefolio.portfolio.CardCondition;
import app.pokefolio.portfolio.CardLanguage;
import app.pokefolio.portfolio.CardVariant;
import jakarta.validation.Valid;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Digits;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.PastOrPresent;
import jakarta.validation.constraints.Size;
import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

public final class TransactionDtos {

    private TransactionDtos() {
    }

    public record SaleRequest(
            @NotEmpty @Size(max = 500) List<@NotNull UUID> holdingIds,
            @NotNull @PastOrPresent LocalDate date,
            @NotNull @DecimalMin("0.00") @Digits(integer = 10, fraction = 2) BigDecimal proceeds,
            @DecimalMin("0.00") @Digits(integer = 10, fraction = 2) BigDecimal fees,
            @Size(max = 2000) String notes) {
    }

    public record GiftRequest(
            @NotEmpty @Size(max = 500) List<@NotNull UUID> holdingIds,
            @NotNull @PastOrPresent LocalDate date,
            @Size(max = 2000) String notes) {
    }

    public record CorrectionRequest(
            @NotEmpty @Size(max = 500) List<@NotNull UUID> holdingIds,
            @NotNull @PastOrPresent LocalDate date,
            @Size(max = 2000) String notes) {
    }

    /**
     * @param value optional per-copy value of the received card; becomes its cost basis
     */
    public record ReceivedCard(
            @NotNull UUID cardId,
            @Min(1) @Max(100) int quantity,
            @NotNull CardCondition condition,
            @NotNull CardLanguage language,
            @NotNull CardVariant variant,
            @DecimalMin("0.00") @Digits(integer = 10, fraction = 2) BigDecimal value,
            @Size(max = 2000) String notes) {
    }

    public record TradeRequest(
            @NotEmpty @Size(max = 500) List<@NotNull UUID> givenHoldingIds,
            @NotEmpty @Size(max = 100) List<@Valid @NotNull ReceivedCard> received,
            @NotNull @PastOrPresent LocalDate date,
            @DecimalMin("0.00") @Digits(integer = 10, fraction = 2) BigDecimal cashReceived,
            @DecimalMin("0.00") @Digits(integer = 10, fraction = 2) BigDecimal cashPaid,
            @Size(max = 2000) String notes) {
    }

    public record CardRefDto(UUID id, String name, String number, String setName, String rarity) {
    }

    public record LineDto(UUID holdingId, LineDirection direction, BigDecimal allocatedAmount, CardRefDto card,
            CardCondition condition, CardLanguage language, CardVariant variant, BigDecimal purchasePrice) {
    }

    /** @param realizedGain for sales: net proceeds minus cost basis over copies with a known cost */
    public record TransactionDto(UUID id, TransactionType type, LocalDate occurredOn, String currency,
            BigDecimal cashIn, BigDecimal cashOut, BigDecimal fees, String notes, Instant createdAt,
            List<LineDto> lines, BigDecimal realizedGain) {
    }
}
