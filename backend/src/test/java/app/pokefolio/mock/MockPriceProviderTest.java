package app.pokefolio.mock;

import static org.assertj.core.api.Assertions.assertThat;

import app.pokefolio.pricing.PriceProvider.CardRef;
import java.time.Clock;
import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneOffset;
import org.junit.jupiter.api.Test;

class MockPriceProviderTest {

    private final Clock clock = Clock.fixed(Instant.parse("2026-05-01T08:00:00Z"), ZoneOffset.UTC);
    private final MockPriceProvider provider = new MockPriceProvider(clock);

    private static CardRef ref(String externalId) {
        return new CardRef("mock", externalId, "x", "set", "1");
    }

    @Test
    void quotesAreDeterministicSampleDataInEuro() {
        var first = provider.currentPrice(ref("base1-4")).orElseThrow();
        var second = provider.currentPrice(ref("base1-4")).orElseThrow();

        assertThat(first).isEqualTo(second);
        assertThat(first.currency()).isEqualTo("EUR");
        assertThat(first.market().scale()).isEqualTo(2);
        assertThat(provider.sampleData()).isTrue();
    }

    @Test
    void cardsWithoutSamplePriceReturnNothingInsteadOfZero() {
        assertThat(provider.currentPrice(ref("neo2-13"))).isEmpty();
        assertThat(provider.currentPrice(ref("unknown-1"))).isEmpty();
    }

    @Test
    void staleCardsStopProducingQuotes() {
        assertThat(provider.currentPrice(ref("sv4pt5-234"))).isEmpty();
        LocalDate today = LocalDate.now(clock);
        var history = provider.history(ref("sv4pt5-234"), today.minusDays(30), today);
        assertThat(history).isNotEmpty();
        assertThat(history.getLast().observedAt())
                .isBefore(today.minusDays(MockCatalogData.STALE_DAYS - 1).atStartOfDay().toInstant(ZoneOffset.UTC));
    }

    @Test
    void historyHasOneQuotePerDay() {
        LocalDate today = LocalDate.now(clock);
        assertThat(provider.history(ref("swsh7-215"), today.minusDays(9), today)).hasSize(10);
    }
}
