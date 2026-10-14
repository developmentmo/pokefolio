package app.pokefolio.pricing;

import java.time.Instant;
import java.util.Collection;
import java.util.List;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface PriceObservationRepository extends JpaRepository<PriceObservation, UUID> {

    /** Latest observation per card in the given currency (PostgreSQL DISTINCT ON). */
    @Query(value = """
            SELECT DISTINCT ON (card_id) * FROM price_observations
            WHERE card_id IN (:cardIds) AND currency = :currency
            ORDER BY card_id, observed_at DESC
            """, nativeQuery = true)
    List<PriceObservation> findLatestForCards(@Param("cardIds") Collection<UUID> cardIds,
            @Param("currency") String currency);

    @Query("""
            select o from PriceObservation o
            where o.cardId in :cardIds and o.currency = :currency and o.observedAt >= :from and o.observedAt <= :to
            order by o.observedAt asc
            """)
    List<PriceObservation> findInRange(@Param("cardIds") Collection<UUID> cardIds, @Param("currency") String currency,
            @Param("from") Instant from, @Param("to") Instant to);

    /** For each card, the latest observation strictly before {@code before}: the starting price of a range. */
    @Query(value = """
            SELECT DISTINCT ON (card_id) * FROM price_observations
            WHERE card_id IN (:cardIds) AND currency = :currency AND observed_at < :before
            ORDER BY card_id, observed_at DESC
            """, nativeQuery = true)
    List<PriceObservation> findLatestBefore(@Param("cardIds") Collection<UUID> cardIds,
            @Param("currency") String currency, @Param("before") Instant before);

    boolean existsByCardIdAndSourceAndCurrencyAndObservedAt(UUID cardId, String source, String currency,
            Instant observedAt);

    boolean existsByCardId(UUID cardId);
}
