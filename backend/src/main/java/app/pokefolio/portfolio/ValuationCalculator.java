package app.pokefolio.portfolio;

import app.pokefolio.common.Money;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

/**
 * Pure portfolio formulas, independent of persistence and price providers.
 *
 * <p>Rules:
 * <ul>
 *   <li>Market value = sum of the latest known market price of every copy currently in the collection.
 *       Copies without a known price are counted as "unpriced" and excluded (never valued at zero).</li>
 *   <li>Cost basis = sum of known purchase prices of current copies.</li>
 *   <li>Unrealised gain = sum of (market price - purchase price) over copies where both are known, so unknown
 *       values never distort the result. Coverage counts are returned alongside.</li>
 *   <li>Historical value on day D counts a copy when {@code acquiredOn <= D} and it was not disposed on or
 *       before D, priced at the latest observation on or before D (no look-ahead).</li>
 * </ul>
 */
public final class ValuationCalculator {

    private ValuationCalculator() {
    }

    public record ValuedCopy(UUID cardId, BigDecimal purchasePrice, BigDecimal marketPrice) {
    }

    public record Totals(BigDecimal marketValue, BigDecimal costBasis, BigDecimal unrealizedGain,
            BigDecimal unrealizedGainPercent, int copies, int distinctCards, int pricedCopies, int unpricedCopies,
            int copiesWithoutCost) {
    }

    public static Totals totals(List<ValuedCopy> copies) {
        BigDecimal market = Money.zero();
        BigDecimal cost = Money.zero();
        BigDecimal gain = Money.zero();
        BigDecimal gainCost = Money.zero();
        int priced = 0;
        int withoutCost = 0;
        int gainCopies = 0;
        Set<UUID> cards = new HashSet<>();
        for (ValuedCopy copy : copies) {
            cards.add(copy.cardId());
            if (copy.marketPrice() != null) {
                market = market.add(copy.marketPrice());
                priced++;
            }
            if (copy.purchasePrice() != null) {
                cost = cost.add(copy.purchasePrice());
            } else {
                withoutCost++;
            }
            if (copy.marketPrice() != null && copy.purchasePrice() != null) {
                gain = gain.add(copy.marketPrice().subtract(copy.purchasePrice()));
                gainCost = gainCost.add(copy.purchasePrice());
                gainCopies++;
            }
        }
        BigDecimal gainValue = gainCopies == 0 ? null : Money.normalize(gain);
        BigDecimal percent = gainCopies == 0 || gainCost.signum() == 0 ? null
                : gain.multiply(BigDecimal.valueOf(100)).divide(gainCost, 2, RoundingMode.HALF_EVEN);
        return new Totals(Money.normalize(market), Money.normalize(cost), gainValue, percent, copies.size(),
                cards.size(), priced, copies.size() - priced, withoutCost);
    }

    public record HoldingPeriod(UUID cardId, LocalDate acquiredOn, LocalDate disposedOn, BigDecimal purchasePrice) {

        boolean heldOn(LocalDate day) {
            return !acquiredOn.isAfter(day) && (disposedOn == null || disposedOn.isAfter(day));
        }
    }

    public record DatedPrice(LocalDate date, BigDecimal price) {
    }

    public record HistoryPoint(LocalDate date, BigDecimal marketValue, BigDecimal costBasis, int copies,
            int unpricedCopies) {
    }

    /**
     * @param pricesByCard per card, observations sorted by date ascending; may include observations before
     *                     {@code from} (used as the starting price)
     */
    public static List<HistoryPoint> history(List<HoldingPeriod> holdings, Map<UUID, List<DatedPrice>> pricesByCard,
            LocalDate from, LocalDate to) {
        List<HistoryPoint> points = new ArrayList<>();
        Map<UUID, Integer> cursor = new java.util.HashMap<>();
        Map<UUID, BigDecimal> current = new java.util.HashMap<>();
        for (LocalDate day = from; !day.isAfter(to); day = day.plusDays(1)) {
            for (var entry : pricesByCard.entrySet()) {
                List<DatedPrice> prices = entry.getValue();
                int i = cursor.getOrDefault(entry.getKey(), 0);
                while (i < prices.size() && !prices.get(i).date().isAfter(day)) {
                    current.put(entry.getKey(), prices.get(i).price());
                    i++;
                }
                cursor.put(entry.getKey(), i);
            }
            BigDecimal value = Money.zero();
            BigDecimal cost = Money.zero();
            int copies = 0;
            int unpriced = 0;
            for (HoldingPeriod h : holdings) {
                if (!h.heldOn(day)) {
                    continue;
                }
                copies++;
                BigDecimal price = current.get(h.cardId());
                if (price == null) {
                    unpriced++;
                } else {
                    value = value.add(price);
                }
                if (h.purchasePrice() != null) {
                    cost = cost.add(h.purchasePrice());
                }
            }
            points.add(new HistoryPoint(day, Money.normalize(value), Money.normalize(cost), copies, unpriced));
        }
        return points;
    }

    /** Splits {@code amount} over {@code parts} lines; the remainder cents go to the first line. */
    public static List<BigDecimal> allocate(BigDecimal amount, int parts) {
        if (parts <= 0) {
            throw new IllegalArgumentException("parts must be positive");
        }
        BigDecimal total = Money.normalize(amount);
        BigDecimal share = total.divide(BigDecimal.valueOf(parts), Money.SCALE, RoundingMode.DOWN);
        BigDecimal remainder = total.subtract(share.multiply(BigDecimal.valueOf(parts)));
        List<BigDecimal> result = new ArrayList<>(parts);
        for (int i = 0; i < parts; i++) {
            result.add(i == 0 ? share.add(remainder) : share);
        }
        return result;
    }
}
