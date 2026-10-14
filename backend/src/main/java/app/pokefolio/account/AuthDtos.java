package app.pokefolio.account;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import java.time.Instant;
import java.util.UUID;

public final class AuthDtos {

    private AuthDtos() {
    }

    public record RegisterRequest(
            @NotBlank @Email @Size(max = 320) String email,
            @NotBlank @Size(min = 10, max = 128, message = "must be between 10 and 128 characters") String password,
            @NotBlank @Size(max = 80) String displayName) {
    }

    public record LoginRequest(@NotBlank @Email String email, @NotBlank String password) {
    }

    public record RefreshRequest(@NotBlank String refreshToken) {
    }

    public record ForgotPasswordRequest(@NotBlank @Email String email) {
    }

    public record ResetPasswordRequest(
            @NotBlank String token,
            @NotBlank @Size(min = 10, max = 128, message = "must be between 10 and 128 characters") String newPassword) {
    }

    public record ChangePasswordRequest(
            @NotBlank String currentPassword,
            @NotBlank @Size(min = 10, max = 128, message = "must be between 10 and 128 characters") String newPassword) {
    }

    public record UpdateAccountRequest(
            @Size(min = 1, max = 80) String displayName,
            @Pattern(regexp = "[A-Z]{3}", message = "must be an ISO-4217 currency code") String preferredCurrency) {
    }

    public record DeleteAccountRequest(@NotBlank String password) {
    }

    public record AccountDto(UUID id, String email, String displayName, String preferredCurrency, Instant createdAt) {

        static AccountDto from(User user) {
            return new AccountDto(user.getId(), user.getEmail(), user.getDisplayName(), user.getPreferredCurrency(),
                    user.getCreatedAt());
        }
    }

    public record AuthResponse(String accessToken, String refreshToken, long expiresInSeconds, AccountDto account) {
    }
}
