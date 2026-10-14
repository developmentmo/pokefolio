package app.pokefolio.pricing;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import app.pokefolio.catalog.CardSet;
import app.pokefolio.catalog.PokemonCard;
import app.pokefolio.catalog.PokemonCardRepository;
import io.micrometer.core.instrument.simple.SimpleMeterRegistry;
import java.math.BigDecimal;
import java.time.Clock;
import java.time.Duration;
import java.time.Instant;
import java.time.ZoneOffset;
import java.util.List;
import java.util.Optional;
import org.junit.jupiter.api.Test;

class PriceServiceTest {

    private final Clock clock = Clock.fixed(Instant.parse("2026-05-01T08:00:00Z"), ZoneOffset.UTC);
    private final PriceObservationRepository observations = mock(PriceObservationRepository.class);
    private final PriceProvider provider = mock(PriceProvider.class);
    private final SimpleMeterRegistry meters = new SimpleMeterRegistry();
    private final PriceService service = new PriceService(observations, provider, mock(PokemonCardRepository.class),
            new PricingProperties("EUR", Duration.ofHours(48), 30), meters, clock);

    private final PokemonCard card = new PokemonCard(new CardSet("mock", "base1", clock.instant()), "mock", "base1-4",
            clock.instant());

    @Test
    void providerFailureKeepsLastKnownPrice() {
        when(provider.currentPrice(any())).thenThrow(new IllegalStateException("provider down"));

        var result = service.refresh(List.of(card));

        assertThat(result.failed()).isEqualTo(1);
        verify(observations, never()).save(any());
        assertThat(meters.counter("pokefolio.prices.refresh", "outcome", "failed").count()).isEqualTo(1.0);
    }

    @Test
    void missingPriceStoresNothing() {
        when(provider.currentPrice(any())).thenReturn(Optional.empty());

        var result = service.refresh(List.of(card));

        assertThat(result.missing()).isEqualTo(1);
        verify(observations, never()).save(any());
    }

    @Test
    void quotesInAnotherCurrencyAreIgnored() {
        when(provider.currentPrice(any())).thenReturn(Optional.of(
                new PriceProvider.Quote(new BigDecimal("10.00"), null, null, "USD", clock.instant())));

        service.refresh(List.of(card));

        verify(observations, never()).save(any());
    }

    @Test
    void oldObservationsAreFlaggedStaleAndUnknownIsNotZero() {
        var fresh = new PriceObservation(card, "src", "EUR", new BigDecimal("5.00"), null, null, true,
                clock.instant().minus(Duration.ofHours(2)), clock.instant());
        var old = new PriceObservation(card, "src", "EUR", new BigDecimal("5.00"), null, null, true,
                clock.instant().minus(Duration.ofDays(5)), clock.instant());

        assertThat(service.toInfo(fresh).stale()).isFalse();
        assertThat(service.toInfo(old).stale()).isTrue();
        PriceInfo unknown = service.toInfo(null);
        assertThat(unknown.status()).isEqualTo(PriceInfo.Status.UNKNOWN);
        assertThat(unknown.market()).isNull();
    }
}
