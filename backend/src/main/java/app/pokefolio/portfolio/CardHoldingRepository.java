package app.pokefolio.portfolio;

import jakarta.persistence.LockModeType;
import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Lock;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

/** Every query is scoped by userId: this is where per-user isolation is enforced. */
public interface CardHoldingRepository extends JpaRepository<CardHolding, UUID> {

    @EntityGraph(attributePaths = {"card", "card.set"})
    Optional<CardHolding> findByIdAndUserId(UUID id, UUID userId);

    @EntityGraph(attributePaths = {"card", "card.set"})
    List<CardHolding> findAllByUserIdAndStatus(UUID userId, HoldingStatus status);

    @EntityGraph(attributePaths = {"card", "card.set"})
    List<CardHolding> findAllByUserId(UUID userId);

    @EntityGraph(attributePaths = {"card", "card.set"})
    @Query("""
            select h from CardHolding h
            where h.userId = :userId
              and (:status is null or h.status = :status)
              and (:cardId is null or h.card.id = :cardId)
            """)
    Page<CardHolding> search(@Param("userId") UUID userId, @Param("status") HoldingStatus status,
            @Param("cardId") UUID cardId, Pageable pageable);

    /** Locks the selected copies so two concurrent requests cannot dispose of the same copy. */
    @Lock(LockModeType.PESSIMISTIC_WRITE)
    @Query("select h from CardHolding h join fetch h.card c join fetch c.set where h.userId = :userId and h.id in :ids")
    List<CardHolding> lockAllByUserIdAndIdIn(@Param("userId") UUID userId, @Param("ids") Collection<UUID> ids);
}
