package app.pokefolio.catalog;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CardSetRepository extends JpaRepository<CardSet, UUID> {

    Optional<CardSet> findByProviderAndExternalId(String provider, String externalId);

    List<CardSet> findAllByOrderByReleaseDateDescNameAsc();
}
