package app.pokefolio.account;

/**
 * Delivers password reset tokens to users. Production deployments must provide an e-mail backed
 * implementation; see docs/deployment.md.
 */
public interface PasswordResetNotifier {

    void sendResetToken(User user, String rawToken);
}
