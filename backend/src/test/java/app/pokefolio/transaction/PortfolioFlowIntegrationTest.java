package app.pokefolio.transaction;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import app.pokefolio.support.IntegrationTest;
import com.jayway.jsonpath.JsonPath;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

class PortfolioFlowIntegrationTest extends IntegrationTest {

    private String token;
    private String charizard;
    private String pikachu;
    private String umbreonUnpriced;
    private String today;

    @BeforeEach
    void setUp() throws Exception {
        token = registerUser();
        charizard = cardId(token, "Charizard", "base1-4");
        pikachu = cardId(token, "Pikachu", "base1-58");
        umbreonUnpriced = cardId(token, "Umbreon", "neo2-13");
        today = LocalDate.now().toString();
    }

    private BigDecimal price(String cardId) throws Exception {
        String body = json(as(token, get("/api/v1/cards/" + cardId)).andExpect(status().isOk()));
        return new BigDecimal(JsonPath.read(body, "$.price.market").toString());
    }

    private String summary() throws Exception {
        return json(as(token, get("/api/v1/portfolio/summary")).andExpect(status().isOk()));
    }

    private static BigDecimal decimal(String json, String path) {
        Object value = JsonPath.read(json, path);
        return value == null ? null : new BigDecimal(value.toString());
    }

    @Test
    void searchSupportsNameSetAndNumberWithSamplePricesMarked() throws Exception {
        as(token, get("/api/v1/cards").param("q", "evolving"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.content[0].set.name").value("Evolving Skies"));
        as(token, get("/api/v1/cards").param("number", "215"))
                .andExpect(jsonPath("$.content[0].name").value("Umbreon VMAX"))
                .andExpect(jsonPath("$.content[0].price.sampleData").value(true))
                .andExpect(jsonPath("$.content[0].price.source").value("PokeFolio sample data"));
        as(token, get("/api/v1/cards").param("q", "Umbreon").param("sort", "NAME"))
                .andExpect(jsonPath("$.content[?(@.externalId == 'neo2-13')].price.status").value("UNKNOWN"));
        as(token, get("/api/v1/cards").param("q", "Charizard ex").param("size", "50"))
                .andExpect(jsonPath("$.content[?(@.externalId == 'sv4pt5-234')].price.stale").value(true));
        as(token, get("/api/v1/cards").param("size", "2")).andExpect(jsonPath("$.content.length()").value(2))
                .andExpect(jsonPath("$.totalPages").isNumber());
        as(token, get("/api/v1/catalog/filters")).andExpect(jsonPath("$.sets.length()").value(10));
        as(token, get("/api/v1/cards/" + charizard + "/prices").param("days", "30"))
                .andExpect(jsonPath("$.points.length()").value(org.hamcrest.Matchers.greaterThanOrEqualTo(29)));
    }

    @Test
    void portfolioTotalsCoverMultipleCopiesUnknownPricesAndMissingCosts() throws Exception {
        addCopies(token, charizard, 3, "100.00");
        addCopies(token, pikachu, 1, null);
        addCopies(token, umbreonUnpriced, 1, "50.00");
        BigDecimal charizardPrice = price(charizard);
        BigDecimal pikachuPrice = price(pikachu);

        String summary = summary();
        assertThat(decimal(summary, "$.marketValue"))
                .isEqualByComparingTo(charizardPrice.multiply(BigDecimal.valueOf(3)).add(pikachuPrice));
        assertThat(decimal(summary, "$.costBasis")).isEqualByComparingTo("350.00");
        assertThat(decimal(summary, "$.unrealizedGain"))
                .isEqualByComparingTo(charizardPrice.subtract(new BigDecimal("100.00")).multiply(BigDecimal.valueOf(3)));
        assertThat((Integer) JsonPath.read(summary, "$.copies")).isEqualTo(5);
        assertThat((Integer) JsonPath.read(summary, "$.distinctCards")).isEqualTo(3);
        assertThat((Integer) JsonPath.read(summary, "$.unpricedCopies")).isEqualTo(1);
        assertThat((Integer) JsonPath.read(summary, "$.copiesWithoutCost")).isEqualTo(1);
        assertThat((Boolean) JsonPath.read(summary, "$.sampleData")).isTrue();
        assertThat((List<String>) JsonPath.read(summary, "$.warnings"))
                .contains("SAMPLE_PRICES", "UNPRICED_COPIES", "MISSING_PURCHASE_PRICES");

        as(token, get("/api/v1/collection").param("sort", "VALUE"))
                .andExpect(jsonPath("$.content[0].card.externalId").value("base1-4"))
                .andExpect(jsonPath("$.content[0].copies").value(3))
                .andExpect(jsonPath("$.content[?(@.card.externalId == 'neo2-13')].marketValue").value(
                        org.hamcrest.Matchers.contains((Object) null)));
        as(token, get("/api/v1/portfolio/dashboard"))
                .andExpect(jsonPath("$.recentlyAdded.length()").value(5))
                .andExpect(jsonPath("$.mostValuable[0].card.externalId").value("base1-4"))
                .andExpect(jsonPath("$.recentTransactions[0].type").value("PURCHASE"));
    }

    @Test
    void sellingPartOfTheCopiesRecordsRealizedGainAndRemovesThemFromTheCollection() throws Exception {
        List<String> copies = addCopies(token, charizard, 3, "100.00");

        String sale = json(as(token, post("/api/v1/transactions/sales").content("""
                {"holdingIds":["%s","%s"],"date":"%s","proceeds":"500.00","fees":"20.00","notes":"Cardmarket"}
                """.formatted(copies.get(0), copies.get(1), today))).andExpect(status().isCreated()));
        assertThat(decimal(sale, "$.realizedGain")).isEqualByComparingTo("280.00");
        assertThat((List<?>) JsonPath.read(sale, "$.lines")).hasSize(2);

        String summary = summary();
        assertThat((Integer) JsonPath.read(summary, "$.copies")).isEqualTo(1);
        assertThat(decimal(summary, "$.costBasis")).isEqualByComparingTo("100.00");
        assertThat(decimal(summary, "$.realizedGain")).isEqualByComparingTo("280.00");
        as(token, get("/api/v1/holdings/" + copies.get(0))).andExpect(jsonPath("$.status").value("SOLD"))
                .andExpect(jsonPath("$.disposedOn").value(today));

        // the same copy cannot be sold twice
        as(token, post("/api/v1/transactions/sales").content("""
                {"holdingIds":["%s"],"date":"%s","proceeds":"1.00"}""".formatted(copies.get(0), today)))
                .andExpect(status().isConflict());
        // sold copies cannot be edited
        as(token, put("/api/v1/holdings/" + copies.get(0)).content("""
                {"condition":"POOR","language":"EN","variant":"NORMAL"}""")).andExpect(status().isConflict());
    }

    @Test
    void givingAwayRemovesCopiesWithoutMoney() throws Exception {
        List<String> copies = addCopies(token, pikachu, 2, "10.00");
        as(token, post("/api/v1/transactions/gifts").content("""
                {"holdingIds":["%s"],"date":"%s","notes":"For my nephew"}""".formatted(copies.get(0), today)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.type").value("GIFT"))
                .andExpect(jsonPath("$.cashIn").doesNotExist());
        assertThat((Integer) JsonPath.read(summary(), "$.copies")).isEqualTo(1);
        as(token, get("/api/v1/holdings").param("status", "GIVEN_AWAY")).andExpect(jsonPath("$.totalElements").value(1));
    }

    @Test
    void tradeWithMultipleCardsOnBothSidesIsRecordedAtomically() throws Exception {
        List<String> zards = addCopies(token, charizard, 2, "100.00");
        String pika = addCopies(token, pikachu, 1, "10.00").getFirst();
        String umbreonVmax = cardId(token, "Umbreon VMAX", "swsh7-215");
        String mew = cardId(token, "Mew", "swsh8-269");

        String trade = json(as(token, post("/api/v1/transactions/trades").content("""
                {"givenHoldingIds":["%s","%s","%s"],"date":"%s","cashPaid":"50.00","notes":"Meetup",
                 "received":[
                   {"cardId":"%s","quantity":1,"condition":"MINT","language":"JA","variant":"NORMAL","value":"700.00"},
                   {"cardId":"%s","quantity":2,"condition":"NEAR_MINT","language":"EN","variant":"NORMAL"}]}
                """.formatted(zards.get(0), zards.get(1), pika, today, umbreonVmax, mew)))
                .andExpect(status().isCreated()));
        assertThat((List<?>) JsonPath.read(trade, "$.lines[?(@.direction == 'OUT')]")).hasSize(3);
        assertThat((List<?>) JsonPath.read(trade, "$.lines[?(@.direction == 'IN')]")).hasSize(3);
        assertThat(decimal(trade, "$.cashOut")).isEqualByComparingTo("50.00");

        String summary = summary();
        assertThat((Integer) JsonPath.read(summary, "$.copies")).isEqualTo(3);
        assertThat(decimal(summary, "$.costBasis")).isEqualByComparingTo("700.00");
        as(token, get("/api/v1/holdings/" + pika)).andExpect(jsonPath("$.status").value("TRADED_AWAY"));
        as(token, get("/api/v1/collection").param("q", "mew"))
                .andExpect(jsonPath("$.content[0].copies").value(2))
                .andExpect(jsonPath("$.content[0].holdings[0].language").value("EN"));
    }

    @Test
    void failedTradeLeavesTheCollectionUntouched() throws Exception {
        List<String> zards = addCopies(token, charizard, 2, "100.00");
        String txBefore = json(as(token, get("/api/v1/transactions")));

        // second received card does not exist -> whole trade rejected
        as(token, post("/api/v1/transactions/trades").content("""
                {"givenHoldingIds":["%s","%s"],"date":"%s",
                 "received":[
                   {"cardId":"%s","quantity":1,"condition":"MINT","language":"EN","variant":"NORMAL"},
                   {"cardId":"%s","quantity":1,"condition":"MINT","language":"EN","variant":"NORMAL"}]}
                """.formatted(zards.get(0), zards.get(1), today, pikachu, UUID.randomUUID())))
                .andExpect(status().isNotFound());

        // one given copy already sold -> whole trade rejected
        as(token, post("/api/v1/transactions/sales").content("""
                {"holdingIds":["%s"],"date":"%s","proceeds":"10.00"}""".formatted(zards.get(1), today)))
                .andExpect(status().isCreated());
        as(token, post("/api/v1/transactions/trades").content("""
                {"givenHoldingIds":["%s","%s"],"date":"%s",
                 "received":[{"cardId":"%s","quantity":3,"condition":"MINT","language":"EN","variant":"NORMAL"}]}
                """.formatted(zards.get(0), zards.get(1), today, pikachu))).andExpect(status().isConflict());

        as(token, get("/api/v1/holdings/" + zards.get(0))).andExpect(jsonPath("$.status").value("ACTIVE"));
        as(token, get("/api/v1/holdings").param("cardId", pikachu)).andExpect(jsonPath("$.totalElements").value(0));
        int before = JsonPath.read(txBefore, "$.totalElements");
        as(token, get("/api/v1/transactions")).andExpect(jsonPath("$.totalElements").value(before + 1));
        as(token, get("/api/v1/transactions").param("type", "TRADE")).andExpect(jsonPath("$.totalElements").value(0));
    }

    @Test
    void invalidTransactionsAreRejected() throws Exception {
        String copy = addCopies(token, charizard, 1, "100.00").getFirst();
        as(token, post("/api/v1/transactions/sales").content("""
                {"holdingIds":["%s","%s"],"date":"%s","proceeds":"10.00"}""".formatted(copy, copy, today)))
                .andExpect(status().isBadRequest());
        as(token, post("/api/v1/transactions/sales").content("""
                {"holdingIds":["%s"],"date":"2099-01-01","proceeds":"10.00"}""".formatted(copy)))
                .andExpect(status().isBadRequest());
        as(token, post("/api/v1/transactions/sales").content("""
                {"holdingIds":["%s"],"date":"2020-01-01","proceeds":"10.00"}""".formatted(copy)))
                .andExpect(status().isBadRequest());
        as(token, post("/api/v1/transactions/sales").content("""
                {"holdingIds":[],"date":"%s","proceeds":"10.00"}""".formatted(today)))
                .andExpect(status().isBadRequest());
        as(token, post("/api/v1/transactions/sales").content("""
                {"holdingIds":["%s"],"date":"%s","proceeds":"-5"}""".formatted(copy, today)))
                .andExpect(status().isBadRequest());
    }

    @Test
    void correctionRemovesMistakenCopiesButKeepsHistory() throws Exception {
        String copy = addCopies(token, charizard, 1, "100.00").getFirst();
        as(token, post("/api/v1/transactions/corrections").content("""
                {"holdingIds":["%s"],"date":"%s","notes":"Entered twice"}""".formatted(copy, today)))
                .andExpect(status().isCreated());
        as(token, get("/api/v1/holdings/" + copy)).andExpect(jsonPath("$.status").value("REMOVED"));
        as(token, get("/api/v1/transactions")).andExpect(jsonPath("$.totalElements").value(2));
    }

    @Test
    void editingACopyUpdatesPurchaseData() throws Exception {
        String copy = addCopies(token, charizard, 1, "100.00").getFirst();
        as(token, put("/api/v1/holdings/" + copy).content("""
                {"condition":"EXCELLENT","language":"DE","variant":"SHADOWLESS","purchasePrice":"120.00",
                 "purchaseDate":"2024-02-01","notes":"PSA candidate"}"""))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.condition").value("EXCELLENT"))
                .andExpect(jsonPath("$.language").value("DE"))
                .andExpect(jsonPath("$.purchasePrice").value(120.00));
    }

    @Test
    void historyTracksValueOverTimeAndExcludesSoldCopies() throws Exception {
        List<String> copies = addCopies(token, charizard, 2, "100.00");
        as(token, post("/api/v1/transactions/sales").content("""
                {"holdingIds":["%s"],"date":"%s","proceeds":"300.00"}""".formatted(copies.get(0), today)))
                .andExpect(status().isCreated());

        String history = json(as(token, get("/api/v1/portfolio/history").param("days", "30"))
                .andExpect(status().isOk()));
        List<Integer> copiesPerDay = JsonPath.read(history, "$.points[*].copies");
        assertThat(copiesPerDay).hasSize(30);
        // purchased on 2024-01-15: two copies until today, one copy at the end of today
        assertThat(copiesPerDay.get(0)).isEqualTo(2);
        assertThat(copiesPerDay.getLast()).isEqualTo(1);
        assertThat((Boolean) JsonPath.read(history, "$.sampleData")).isTrue();
        assertThat(decimal(history, "$.points[0].marketValue")).isPositive();
    }
}
