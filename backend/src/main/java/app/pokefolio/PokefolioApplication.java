package app.pokefolio;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.ConfigurationPropertiesScan;
import org.springframework.scheduling.annotation.EnableScheduling;

/**
 * PokeFolio backend: a modular monolith with separate modules for accounts, the card catalog,
 * market prices, the portfolio (holdings and valuation) and transactions.
 */
@SpringBootApplication
@ConfigurationPropertiesScan
@EnableScheduling
public class PokefolioApplication {

    public static void main(String[] args) {
        SpringApplication.run(PokefolioApplication.class, args);
    }
}
