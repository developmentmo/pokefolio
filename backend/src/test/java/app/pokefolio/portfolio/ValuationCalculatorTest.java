package app.pokefolio.portfolio;

import static org.assertj.core.api.Assertions.assertThat;

import app.pokefolio.portfolio.ValuationCalculator.DatedPrice;
import app.pokefolio.portfolio.ValuationCalculator.HoldingPeriod;
import app.pokefolio.portfolio.ValuationCalculator.ValuedCopy;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import org.junit.jupiter.api.Test;

class ValuationCalculatorTest {

    private static final UUID CHARIZARD = UUID.randomUUID();
    private static final UUID PIKACHU = UUID.randomUUID();

    private static BigDecimal eur(String v) {
        return new BigDecimal(v);
    }

    @Test
    void sumsMarketValueAndCostOverMultipleCopiesOfTheSameCard() {
        var totals = ValuationCalculator.totals(List.of(
                new ValuedCopy(CHARIZARD, eur("100.00"), eur("150.00")),
                new ValuedCopy(CHARIZARD, eur("120.00"), eur("150.00")),
                new ValuedCopy(PIKACHU, eur("5.00"), eur("4.50"))));

        assertThat(totals.marketValue()).isEqualByComparingTo("304.50");
        assertThat(totals.costBasis()).isEqualByComparingTo("225.00");
        assertThat(totals.unrealizedGain()).isEqualByComparingTo("79.50");
        assertThat(totals.unrealizedGainPercent()).isEqualByComparingTo("35.33");
        assertThat(totals.copies()).isEqualTo(3);
        assertThat(totals.distinctCards()).isEqualTo(2);
        assertThat(totals.unpricedCopies()).isZero();
    }

    @Test
    void unknownPricesAreNotValuedAsZeroAndAreExcludedFromGain() {
        var totals = ValuationCalculator.totals(List.of(
                new ValuedCopy(CHARIZARD, eur("100.00"), eur("150.00")),
                new ValuedCopy(PIKACHU, eur("40.00"), null)));

        assertThat(totals.marketValue()).isEqualByComparingTo("150.00");
        assertThat(totals.costBasis()).isEqualByComparingTo("140.00");
        // only the Charizard has both values, so the unknown Pikachu does not count as a 40 EUR loss
        assertThat(totals.unrealizedGain()).isEqualByComparingTo("50.00");
        assertThat(totals.pricedCopies()).isEqualTo(1);
        assertThat(totals.unpricedCopies()).isEqualTo(1);
    }

    @Test
    void missingPurchasePricesAreCountedSeparately() {
        var totals = ValuationCalculator.totals(List.of(new ValuedCopy(CHARIZARD, null, eur("10.00"))));

        assertThat(totals.costBasis()).isEqualByComparingTo("0.00");
        assertThat(totals.copiesWithoutCost()).isEqualTo(1);
        assertThat(totals.unrealizedGain()).isNull();
        assertThat(totals.unrealizedGainPercent()).isNull();
    }

    @Test
    void emptyPortfolioHasZeroValueAndNoGain() {
        var totals = ValuationCalculator.totals(List.of());

        assertThat(totals.marketValue()).isEqualByComparingTo("0");
        assertThat(totals.unrealizedGain()).isNull();
    }

    @Test
    void historyRespectsAcquisitionAndDisposalDatesAndUsesLastKnownPrice() {
        LocalDate d1 = LocalDate.of(2025, 3, 1);
        var holdings = List.of(
                new HoldingPeriod(CHARIZARD, d1, d1.plusDays(2), eur("80.00")), // sold on day 3
                new HoldingPeriod(PIKACHU, d1.plusDays(1), null, eur("5.00")));  // bought on day 2
        var prices = Map.of(
                CHARIZARD, List.of(new DatedPrice(d1.minusDays(10), eur("100.00")), new DatedPrice(d1.plusDays(1),
                        eur("110.00"))),
                PIKACHU, List.of(new DatedPrice(d1.plusDays(2), eur("6.00"))));

        var points = ValuationCalculator.history(holdings, prices, d1, d1.plusDays(3));

        assertThat(points).hasSize(4);
        // day 1: Charizard at the price observed before the range
        assertThat(points.get(0).marketValue()).isEqualByComparingTo("100.00");
        assertThat(points.get(0).copies()).isEqualTo(1);
        // day 2: Charizard repriced, Pikachu held but no price yet -> unpriced, not zero-valued
        assertThat(points.get(1).marketValue()).isEqualByComparingTo("110.00");
        assertThat(points.get(1).unpricedCopies()).isEqualTo(1);
        assertThat(points.get(1).costBasis()).isEqualByComparingTo("85.00");
        // day 3: Charizard sold that day -> no longer counted
        assertThat(points.get(2).marketValue()).isEqualByComparingTo("6.00");
        assertThat(points.get(2).copies()).isEqualTo(1);
        assertThat(points.get(3).marketValue()).isEqualByComparingTo("6.00");
    }

    @Test
    void allocatesAmountsWithoutLosingCents() {
        assertThat(ValuationCalculator.allocate(eur("100.00"), 3))
                .containsExactly(eur("33.34"), eur("33.33"), eur("33.33"));
        assertThat(ValuationCalculator.allocate(eur("100.00"), 3).stream().reduce(BigDecimal.ZERO, BigDecimal::add))
                .isEqualByComparingTo("100.00");
    }
}
