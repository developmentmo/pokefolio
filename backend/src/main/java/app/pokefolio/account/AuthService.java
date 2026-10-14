package app.pokefolio.account;

import app.pokefolio.account.AuthDtos.AccountDto;
import app.pokefolio.account.AuthDtos.AuthResponse;
import app.pokefolio.common.ConflictException;
import app.pokefolio.common.NotFoundException;
import app.pokefolio.common.UnauthorizedException;
import app.pokefolio.security.SecurityProperties;
import app.pokefolio.security.TokenService;
import java.time.Clock;
import java.time.Instant;
import java.util.Locale;
import java.util.UUID;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class AuthService {

    private final UserRepository users;
    private final RefreshTokenRepository refreshTokens;
    private final PasswordResetTokenRepository resetTokens;
    private final PasswordEncoder passwordEncoder;
    private final TokenService tokenService;
    private final SecurityProperties properties;
    private final PasswordResetNotifier notifier;
    private final Clock clock;
    /** Used to keep login timing similar whether or not the e-mail exists. */
    private final String dummyHash;

    public AuthService(UserRepository users, RefreshTokenRepository refreshTokens,
            PasswordResetTokenRepository resetTokens, PasswordEncoder passwordEncoder, TokenService tokenService,
            SecurityProperties properties, PasswordResetNotifier notifier, Clock clock) {
        this.users = users;
        this.refreshTokens = refreshTokens;
        this.resetTokens = resetTokens;
        this.passwordEncoder = passwordEncoder;
        this.tokenService = tokenService;
        this.properties = properties;
        this.notifier = notifier;
        this.clock = clock;
        this.dummyHash = passwordEncoder.encode(TokenService.newOpaqueToken());
    }

    @Transactional
    public AuthResponse register(String email, String password, String displayName) {
        String normalized = normalizeEmail(email);
        if (users.existsByEmail(normalized)) {
            throw new ConflictException("An account with this e-mail address already exists");
        }
        User user = users.save(new User(normalized, passwordEncoder.encode(password), displayName.trim(), "EUR",
                clock.instant()));
        return issueTokens(user);
    }

    @Transactional
    public AuthResponse login(String email, String password) {
        User user = users.findByEmail(normalizeEmail(email)).orElse(null);
        if (user == null) {
            passwordEncoder.matches(password, dummyHash);
            throw new UnauthorizedException("Invalid e-mail address or password");
        }
        if (!passwordEncoder.matches(password, user.getPasswordHash())) {
            throw new UnauthorizedException("Invalid e-mail address or password");
        }
        if (passwordEncoder.upgradeEncoding(user.getPasswordHash())) {
            user.changePassword(passwordEncoder.encode(password), clock.instant());
        }
        return issueTokens(user);
    }

    /** Rotates the refresh token. Presenting a revoked token revokes the whole token family (reuse detection). */
    @Transactional(noRollbackFor = UnauthorizedException.class)
    public AuthResponse refresh(String rawRefreshToken) {
        Instant now = clock.instant();
        RefreshToken token = refreshTokens.findByTokenHash(TokenService.sha256(rawRefreshToken))
                .orElseThrow(() -> new UnauthorizedException("Invalid refresh token"));
        if (token.isRevoked()) {
            refreshTokens.revokeAllForUser(token.getUser().getId(), now);
            throw new UnauthorizedException("Refresh token was already used");
        }
        if (token.isExpired(now)) {
            throw new UnauthorizedException("Refresh token expired");
        }
        token.revoke(now);
        return issueTokens(token.getUser());
    }

    @Transactional
    public void logout(String rawRefreshToken) {
        refreshTokens.findByTokenHash(TokenService.sha256(rawRefreshToken))
                .ifPresent(token -> token.revoke(clock.instant()));
    }

    /** Always succeeds from the caller's perspective so the endpoint cannot be used to enumerate accounts. */
    @Transactional
    public void requestPasswordReset(String email) {
        users.findByEmail(normalizeEmail(email)).ifPresent(user -> {
            Instant now = clock.instant();
            String raw = TokenService.newOpaqueToken();
            resetTokens.save(new PasswordResetToken(user, TokenService.sha256(raw),
                    now.plus(properties.passwordResetTtl()), now));
            notifier.sendResetToken(user, raw);
        });
    }

    @Transactional
    public void resetPassword(String rawToken, String newPassword) {
        Instant now = clock.instant();
        PasswordResetToken token = resetTokens.findByTokenHash(TokenService.sha256(rawToken))
                .filter(t -> t.isUsable(now))
                .orElseThrow(() -> new UnauthorizedException("Invalid or expired reset token"));
        token.markUsed(now);
        User user = token.getUser();
        user.changePassword(passwordEncoder.encode(newPassword), now);
        refreshTokens.revokeAllForUser(user.getId(), now);
    }

    @Transactional(readOnly = true)
    public AccountDto account(UUID userId) {
        return AccountDto.from(load(userId));
    }

    @Transactional
    public AccountDto updateAccount(UUID userId, String displayName, String preferredCurrency) {
        User user = load(userId);
        user.updateProfile(displayName == null ? null : displayName.trim(), preferredCurrency, clock.instant());
        return AccountDto.from(user);
    }

    @Transactional
    public void changePassword(UUID userId, String currentPassword, String newPassword) {
        User user = load(userId);
        if (!passwordEncoder.matches(currentPassword, user.getPasswordHash())) {
            throw new UnauthorizedException("Current password is incorrect");
        }
        Instant now = clock.instant();
        user.changePassword(passwordEncoder.encode(newPassword), now);
        refreshTokens.revokeAllForUser(userId, now);
    }

    /** Deletes the account and, via ON DELETE CASCADE, all of the user's holdings and transactions. */
    @Transactional
    public void deleteAccount(UUID userId, String password) {
        User user = load(userId);
        if (!passwordEncoder.matches(password, user.getPasswordHash())) {
            throw new UnauthorizedException("Password is incorrect");
        }
        users.delete(user);
    }

    private User load(UUID userId) {
        return users.findById(userId).orElseThrow(() -> new NotFoundException("Account not found"));
    }

    private AuthResponse issueTokens(User user) {
        Instant now = clock.instant();
        String raw = TokenService.newOpaqueToken();
        refreshTokens.save(new RefreshToken(user, TokenService.sha256(raw), now.plus(properties.refreshTokenTtl()),
                now));
        return new AuthResponse(tokenService.createAccessToken(user.getId()), raw,
                tokenService.accessTokenTtlSeconds(), AccountDto.from(user));
    }

    private static String normalizeEmail(String email) {
        return email.trim().toLowerCase(Locale.ROOT);
    }
}
