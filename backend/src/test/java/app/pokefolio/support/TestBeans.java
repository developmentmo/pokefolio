package app.pokefolio.support;

import app.pokefolio.account.PasswordResetNotifier;
import app.pokefolio.account.User;
import java.util.ArrayList;
import java.util.List;
import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Primary;

@TestConfiguration
public class TestBeans {

    @Bean
    @Primary
    CapturingResetNotifier capturingResetNotifier() {
        return new CapturingResetNotifier();
    }

    /** Captures reset tokens so tests can complete the password reset flow. */
    public static class CapturingResetNotifier implements PasswordResetNotifier {

        public final List<String> tokens = new ArrayList<>();

        @Override
        public void sendResetToken(User user, String rawToken) {
            tokens.add(rawToken);
        }
    }
}
