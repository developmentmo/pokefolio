package app.pokefolio.account;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;

@Configuration
class NotifierConfig {

    private static final Logger log = LoggerFactory.getLogger(NotifierConfig.class);

    /** Development only: writes the reset token to the log so the flow can be tested without e-mail. */
    @Bean
    @Profile("dev")
    @ConditionalOnMissingBean
    PasswordResetNotifier loggingPasswordResetNotifier() {
        return (user, rawToken) -> log.info("[DEV ONLY] Password reset token for {}: {}", user.getEmail(), rawToken);
    }

    /** Any other profile without a real notifier: never log the token, only warn. */
    @Bean
    @Profile("!dev")
    @ConditionalOnMissingBean
    PasswordResetNotifier disabledPasswordResetNotifier() {
        return (user, rawToken) -> log.warn("Password reset requested but no e-mail delivery is configured");
    }
}
