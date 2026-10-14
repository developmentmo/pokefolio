package app.pokefolio.pricing;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;
import java.util.UUID;

public record PriceHistoryDto(UUID cardId, String currency, List<Point> points) {

    public record Point(Instant observedAt, BigDecimal market, BigDecimal low, BigDecimal high, String source,
            boolean sampleData) {
    }
}
