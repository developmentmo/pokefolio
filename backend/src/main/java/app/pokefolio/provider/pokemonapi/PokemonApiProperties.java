package app.pokefolio.provider.pokemonapi;

import java.time.Duration;
import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * Settings for the pokemon-api.com integration. The API key is read from the environment
 * ({@code POKEMON_API_KEY}) on the backend only and is never sent to clients.
 */
@ConfigurationProperties(prefix = "pokefolio.pokemon-api")
public record PokemonApiProperties(String baseUrl, String apiKey, Duration connectTimeout, Duration readTimeout) {
}
