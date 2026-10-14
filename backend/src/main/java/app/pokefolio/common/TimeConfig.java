package app.pokefolio.common;

import java.time.Clock;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class TimeConfig {

    /** Injected everywhere "now" is needed, so tests can control time. */
    @Bean
    Clock clock() {
        return Clock.systemUTC();
    }
}
