package app.pokefolio.transaction;

import java.time.LocalDate;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface TransactionRepository extends JpaRepository<Transaction, UUID> {

    Optional<Transaction> findByIdAndUserId(UUID id, UUID userId);

    @Query("""
            select t from Transaction t
            where t.userId = :userId
              and (:type is null or t.type = :type)
              and (cast(:from as date) is null or t.occurredOn >= :from)
              and (cast(:to as date) is null or t.occurredOn <= :to)
            """)
    Page<Transaction> search(@Param("userId") UUID userId, @Param("type") TransactionType type,
            @Param("from") LocalDate from, @Param("to") LocalDate to, Pageable pageable);
}
