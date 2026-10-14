package app.pokefolio.transaction;

import java.util.List;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface TransactionLineRepository extends JpaRepository<TransactionLine, UUID> {

    @Query("""
            select l from TransactionLine l join fetch l.transaction t join fetch l.holding h
            where t.userId = :userId and t.type = app.pokefolio.transaction.TransactionType.SALE
            """)
    List<TransactionLine> findSaleLines(@Param("userId") UUID userId);

    @Query("""
            select l from TransactionLine l join fetch l.transaction t
            where l.holding.id = :holdingId and t.userId = :userId order by t.occurredOn, t.createdAt
            """)
    List<TransactionLine> findByHolding(@Param("userId") UUID userId, @Param("holdingId") UUID holdingId);
}
