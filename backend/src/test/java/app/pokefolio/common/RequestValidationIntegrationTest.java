package app.pokefolio.common;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import app.pokefolio.support.IntegrationTest;
import org.junit.jupiter.api.Test;

/** Invalid query parameters are client errors with a ProblemDetail body, never a 500. */
class RequestValidationIntegrationTest extends IntegrationTest {

    @Test
    void outOfRangePageSizeIsBadRequest() throws Exception {
        String user = registerUser();
        for (String path : new String[] {"/api/v1/collection?size=500", "/api/v1/holdings?size=500",
                "/api/v1/transactions?size=0", "/api/v1/cards?size=101", "/api/v1/portfolio/history?days=1"}) {
            as(user, get(path))
                    .andExpect(status().isBadRequest())
                    .andExpect(jsonPath("$.code").value("validation_failed"));
        }
    }
}
