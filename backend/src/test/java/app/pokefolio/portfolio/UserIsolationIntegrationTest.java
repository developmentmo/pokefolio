package app.pokefolio.portfolio;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import app.pokefolio.support.IntegrationTest;
import com.jayway.jsonpath.JsonPath;
import java.util.List;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

/** Proves that one user can never read or change another user's data. */
class UserIsolationIntegrationTest extends IntegrationTest {

    private String alice;
    private String bob;
    private String aliceHolding;
    private String aliceTransaction;

    @BeforeEach
    void setUp() throws Exception {
        alice = registerUser();
        bob = registerUser();
        String card = cardId(alice, "Charizard", "base1-4");
        aliceHolding = addCopies(alice, card, 1, "300.00").getFirst();
        String tx = json(as(alice, get("/api/v1/transactions")).andExpect(status().isOk()));
        aliceTransaction = JsonPath.read(tx, "$.content[0].id");
    }

    @Test
    void otherUsersCannotReadHoldingsOrTransactions() throws Exception {
        as(bob, get("/api/v1/holdings/" + aliceHolding)).andExpect(status().isNotFound());
        as(bob, get("/api/v1/transactions/" + aliceTransaction)).andExpect(status().isNotFound());
        as(bob, get("/api/v1/holdings")).andExpect(jsonPath("$.totalElements").value(0));
        as(bob, get("/api/v1/collection")).andExpect(jsonPath("$.totalElements").value(0));
        as(bob, get("/api/v1/transactions")).andExpect(jsonPath("$.totalElements").value(0));
        as(bob, get("/api/v1/portfolio/summary")).andExpect(jsonPath("$.copies").value(0));
    }

    @Test
    void otherUsersCannotModifyOrDisposeOfHoldings() throws Exception {
        as(bob, put("/api/v1/holdings/" + aliceHolding).content("""
                {"condition":"POOR","language":"EN","variant":"NORMAL","purchasePrice":"1.00"}"""))
                .andExpect(status().isNotFound());
        as(bob, post("/api/v1/transactions/sales").content("""
                {"holdingIds":["%s"],"date":"2025-01-01","proceeds":"1.00"}""".formatted(aliceHolding)))
                .andExpect(status().isNotFound());
        as(bob, post("/api/v1/transactions/gifts").content("""
                {"holdingIds":["%s"],"date":"2025-01-01"}""".formatted(aliceHolding)))
                .andExpect(status().isNotFound());
        String card = cardId(bob, "Pikachu", "base1-58");
        as(bob, post("/api/v1/transactions/trades").content("""
                {"givenHoldingIds":["%s"],"date":"2025-01-01",
                 "received":[{"cardId":"%s","quantity":1,"condition":"MINT","language":"EN","variant":"NORMAL"}]}
                """.formatted(aliceHolding, card))).andExpect(status().isNotFound());

        // Alice's copy is untouched and Bob received nothing
        as(alice, get("/api/v1/holdings/" + aliceHolding))
                .andExpect(jsonPath("$.status").value("ACTIVE"))
                .andExpect(jsonPath("$.condition").value("NEAR_MINT"));
        as(bob, get("/api/v1/holdings")).andExpect(jsonPath("$.totalElements").value(0));
    }

    @Test
    void clientSuppliedUserIdIsIgnored() throws Exception {
        String card = cardId(bob, "Pikachu", "base1-58");
        String aliceId = JsonPath.read(json(as(alice, get("/api/v1/account"))), "$.id");
        as(bob, post("/api/v1/holdings").content("""
                {"userId":"%s","cardId":"%s","quantity":1,"condition":"MINT","language":"EN","variant":"NORMAL"}
                """.formatted(aliceId, card))).andExpect(status().isCreated());

        as(alice, get("/api/v1/holdings")).andExpect(jsonPath("$.totalElements").value(1));
        as(bob, get("/api/v1/holdings")).andExpect(jsonPath("$.totalElements").value(1));
        List<String> bobCards = JsonPath.read(json(as(bob, get("/api/v1/holdings"))), "$.content[*].card.externalId");
        org.assertj.core.api.Assertions.assertThat(bobCards).containsExactly("base1-58");
    }
}
