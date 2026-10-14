package app.pokefolio.catalog;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;

public interface PokemonCardRepository extends JpaRepository<PokemonCard, UUID>,
        JpaSpecificationExecutor<PokemonCard> {

    Optional<PokemonCard> findByProviderAndExternalId(String provider, String externalId);

    @EntityGraph(attributePaths = "set")
    @Query("select c from PokemonCard c where c.id = :id")
    Optional<PokemonCard> findWithSetById(UUID id);

    @EntityGraph(attributePaths = "set")
    List<PokemonCard> findAllByIdIn(java.util.Collection<UUID> ids);

    @Query("select c from PokemonCard c join fetch c.set")
    List<PokemonCard> findAllWithSet();

    @Query("select distinct c.rarity from PokemonCard c where c.rarity is not null order by c.rarity")
    List<String> findDistinctRarities();
}
