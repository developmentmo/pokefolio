package app.pokefolio.account;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.patch;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import app.pokefolio.support.IntegrationTest;
import com.jayway.jsonpath.JsonPath;
import java.util.UUID;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;

class AuthIntegrationTest extends IntegrationTest {

    @Autowired
    UserRepository users;

    private String email() {
        return "Trainer-" + UUID.randomUUID() + "@Example.com";
    }

    private org.springframework.test.web.servlet.ResultActions postJson(String url, String body) throws Exception {
        return mvc.perform(post(url).contentType(MediaType.APPLICATION_JSON).content(body));
    }

    @Test
    void registerStoresOnlyAStrongHashAndNormalisesEmail() throws Exception {
        String email = email();
        register(email);

        User user = users.findByEmail(email.toLowerCase()).orElseThrow();
        assertThat(user.getPasswordHash()).startsWith("{bcrypt}").doesNotContain("correct-horse-battery");
    }

    @Test
    void duplicateEmailIsRejected() throws Exception {
        String email = email();
        register(email);
        postJson("/api/v1/auth/register", """
                {"email":"%s","password":"another-long-password","displayName":"Misty"}
                """.formatted(email.toUpperCase()))
                .andExpect(status().isConflict())
                .andExpect(jsonPath("$.code").value("conflict"));
    }

    @Test
    void weakPasswordAndInvalidEmailAreRejectedWithFieldErrors() throws Exception {
        postJson("/api/v1/auth/register", """
                {"email":"not-an-email","password":"short","displayName":"Brock"}
                """)
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.code").value("validation_failed"))
                .andExpect(jsonPath("$.errors.email").exists())
                .andExpect(jsonPath("$.errors.password").exists());
    }

    @Test
    void loginWithWrongPasswordFails() throws Exception {
        String email = email();
        register(email);
        postJson("/api/v1/auth/login", """
                {"email":"%s","password":"wrong-password-123"}
                """.formatted(email)).andExpect(status().isUnauthorized());
        postJson("/api/v1/auth/login", """
                {"email":"%s","password":"correct-horse-battery"}
                """.formatted(email)).andExpect(status().isOk()).andExpect(jsonPath("$.accessToken").isNotEmpty());
    }

    @Test
    void protectedEndpointsRequireAValidToken() throws Exception {
        mvc.perform(get("/api/v1/portfolio/summary")).andExpect(status().isUnauthorized());
        mvc.perform(get("/api/v1/portfolio/summary").header("Authorization", "Bearer not-a-jwt"))
                .andExpect(status().isUnauthorized());
        mvc.perform(get("/actuator/health")).andExpect(status().isOk());
    }

    @Test
    void refreshTokensRotateAndReuseRevokesTheFamily() throws Exception {
        Session session = register(email());

        String refreshed = json(postJson("/api/v1/auth/refresh", """
                {"refreshToken":"%s"}""".formatted(session.refreshToken())).andExpect(status().isOk()));
        String newRefresh = JsonPath.read(refreshed, "$.refreshToken");
        assertThat(newRefresh).isNotEqualTo(session.refreshToken());

        // reusing the old token is detected and revokes all tokens of the user
        postJson("/api/v1/auth/refresh", """
                {"refreshToken":"%s"}""".formatted(session.refreshToken())).andExpect(status().isUnauthorized());
        postJson("/api/v1/auth/refresh", """
                {"refreshToken":"%s"}""".formatted(newRefresh)).andExpect(status().isUnauthorized());
    }

    @Test
    void logoutRevokesTheRefreshToken() throws Exception {
        Session session = register(email());
        postJson("/api/v1/auth/logout", """
                {"refreshToken":"%s"}""".formatted(session.refreshToken())).andExpect(status().isNoContent());
        postJson("/api/v1/auth/refresh", """
                {"refreshToken":"%s"}""".formatted(session.refreshToken())).andExpect(status().isUnauthorized());
    }

    @Test
    void passwordResetFlowWorksOnceAndDoesNotRevealAccounts() throws Exception {
        String email = email();
        register(email);
        int before = resetNotifier.tokens.size();

        postJson("/api/v1/auth/password/forgot", """
                {"email":"nobody-%s@example.com"}""".formatted(UUID.randomUUID())).andExpect(status().isAccepted());
        assertThat(resetNotifier.tokens).hasSize(before);

        postJson("/api/v1/auth/password/forgot", """
                {"email":"%s"}""".formatted(email)).andExpect(status().isAccepted());
        String token = resetNotifier.tokens.getLast();

        postJson("/api/v1/auth/password/reset", """
                {"token":"%s","newPassword":"brand-new-password-1"}""".formatted(token))
                .andExpect(status().isNoContent());
        postJson("/api/v1/auth/password/reset", """
                {"token":"%s","newPassword":"brand-new-password-2"}""".formatted(token))
                .andExpect(status().isUnauthorized());
        postJson("/api/v1/auth/login", """
                {"email":"%s","password":"brand-new-password-1"}""".formatted(email)).andExpect(status().isOk());
    }

    @Test
    void accountCanBeUpdatedPasswordChangedAndDeleted() throws Exception {
        String email = email();
        String token = register(email).accessToken();

        as(token, patch("/api/v1/account").content("""
                {"displayName":"Professor Oak"}""")).andExpect(status().isOk())
                .andExpect(jsonPath("$.displayName").value("Professor Oak"))
                .andExpect(jsonPath("$.email").value(email.toLowerCase()));

        as(token, post("/api/v1/account/password").content("""
                {"currentPassword":"wrong-one-123","newPassword":"another-password-1"}"""))
                .andExpect(status().isUnauthorized());
        as(token, post("/api/v1/account/password").content("""
                {"currentPassword":"correct-horse-battery","newPassword":"another-password-1"}"""))
                .andExpect(status().isNoContent());

        as(token, delete("/api/v1/account").content("""
                {"password":"another-password-1"}""")).andExpect(status().isNoContent());
        assertThat(users.findByEmail(email.toLowerCase())).isEmpty();
    }
}
