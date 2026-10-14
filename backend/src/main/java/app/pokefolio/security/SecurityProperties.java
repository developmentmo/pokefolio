package app.pokefolio.security;

import java.time.Duration;
import java.util.List;
import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * @param jwtSecret      HMAC secret for access tokens, at least 32 bytes. Must come from the environment.
 * @param accessTokenTtl lifetime of access tokens
 * @param refreshTokenTtl lifetime of refresh tokens
 * @param passwordResetTtl lifetime of password reset tokens
 * @param allowedOrigins CORS origins allowed to call the API (the Flutter web app)
 */
@ConfigurationProperties(prefix = "pokefolio.security")
public record SecurityProperties(
        String jwtSecret,
        Duration accessTokenTtl,
        Duration refreshTokenTtl,
        Duration passwordResetTtl,
        List<String> allowedOrigins) {

    public SecurityProperties {
        if (jwtSecret == null || jwtSecret.getBytes(java.nio.charset.StandardCharsets.UTF_8).length < 32) {
            throw new IllegalStateException(
                    "pokefolio.security.jwt-secret (env POKEFOLIO_JWT_SECRET) must be set to at least 32 bytes");
        }
        accessTokenTtl = accessTokenTtl == null ? Duration.ofMinutes(15) : accessTokenTtl;
        refreshTokenTtl = refreshTokenTtl == null ? Duration.ofDays(30) : refreshTokenTtl;
        passwordResetTtl = passwordResetTtl == null ? Duration.ofMinutes(30) : passwordResetTtl;
        allowedOrigins = allowedOrigins == null ? List.of() : allowedOrigins;
    }
}
