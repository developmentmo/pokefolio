package app.pokefolio.support;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.jayway.jsonpath.JsonPath;
import java.util.List;
import java.util.UUID;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.testcontainers.service.connection.ServiceConnection;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.context.annotation.Import;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.ResultActions;
import org.springframework.test.web.servlet.request.MockHttpServletRequestBuilder;
import org.testcontainers.postgresql.PostgreSQLContainer;

/**
 * Full-stack tests against a real PostgreSQL (Testcontainers) with the mock catalog and price provider.
 * The container is shared by all test classes.
 */
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Import(TestBeans.class)
public abstract class IntegrationTest {

    @ServiceConnection
    static final PostgreSQLContainer POSTGRES = new PostgreSQLContainer("postgres:17-alpine");

    static {
        POSTGRES.start();
    }

    @Autowired
    protected MockMvc mvc;

    @Autowired
    protected TestBeans.CapturingResetNotifier resetNotifier;

    /** Registers a fresh user and returns its access token. */
    protected String registerUser() throws Exception {
        return register("user-" + UUID.randomUUID() + "@example.com").accessToken();
    }

    protected Session register(String email) throws Exception {
        String body = mvc.perform(post("/api/v1/auth/register").contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"email":"%s","password":"correct-horse-battery","displayName":"Ash"}
                                """.formatted(email)))
                .andExpect(status().isCreated())
                .andReturn().getResponse().getContentAsString();
        return new Session(JsonPath.read(body, "$.accessToken"), JsonPath.read(body, "$.refreshToken"));
    }

    protected ResultActions as(String token, MockHttpServletRequestBuilder request) throws Exception {
        return mvc.perform(request.header("Authorization", "Bearer " + token).contentType(MediaType.APPLICATION_JSON));
    }

    protected String json(ResultActions actions) throws Exception {
        return actions.andReturn().getResponse().getContentAsString();
    }

    /** Catalog card id by provider external id, e.g. {@code base1-4}. */
    protected String cardId(String token, String query, String externalId) throws Exception {
        String body = json(as(token, get("/api/v1/cards").param("q", query).param("size", "100"))
                .andExpect(status().isOk()));
        List<String> ids = JsonPath.read(body, "$.content[?(@.externalId == '" + externalId + "')].id");
        if (ids.isEmpty()) {
            throw new IllegalStateException("Card not in catalog: " + externalId);
        }
        return ids.getFirst();
    }

    /** Adds copies and returns their holding ids. */
    protected List<String> addCopies(String token, String cardId, int quantity, String purchasePrice)
            throws Exception {
        String price = purchasePrice == null ? "null" : purchasePrice;
        String body = json(as(token, post("/api/v1/holdings").content("""
                {"cardId":"%s","quantity":%d,"condition":"NEAR_MINT","language":"EN","variant":"HOLO",
                 "purchasePrice":%s,"purchaseDate":"2024-01-15","notes":"test"}
                """.formatted(cardId, quantity, price))).andExpect(status().isCreated()));
        return JsonPath.read(body, "$[*].id");
    }

    public record Session(String accessToken, String refreshToken) {
    }
}
