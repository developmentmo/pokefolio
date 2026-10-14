package app.pokefolio.provider.pokemonapi;

import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Configuration;

/**
 * The pokemon-api.com adapters ({@code PokemonApiClient}, {@code PokemonCardCatalogProvider},
 * {@code PokemonPriceProvider}) are deliberately not implemented yet: endpoints, authentication and price fields
 * must first be verified against the official documentation. Selecting the provider fails fast instead of
 * silently serving invented data. See docs/pokemon-api-integration.md.
 */
@Configuration
@ConditionalOnProperty(name = "pokefolio.provider", havingValue = "pokemon-api")
class PokemonApiProviderGuard {

    PokemonApiProviderGuard() {
        throw new IllegalStateException("pokefolio.provider=pokemon-api is not available yet: the pokemon-api.com "
                + "contract has not been verified. Use pokefolio.provider=mock. See docs/pokemon-api-integration.md");
    }
}
