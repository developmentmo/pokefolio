package app.pokefolio.portfolio;

import app.pokefolio.common.PageResponse;
import app.pokefolio.portfolio.HoldingDtos.AddHoldingRequest;
import app.pokefolio.portfolio.HoldingDtos.CollectionEntryDto;
import app.pokefolio.portfolio.HoldingDtos.HoldingDto;
import app.pokefolio.portfolio.HoldingDtos.UpdateHoldingRequest;
import app.pokefolio.portfolio.HoldingService.CollectionSort;
import app.pokefolio.portfolio.PortfolioDtos.DashboardDto;
import app.pokefolio.portfolio.PortfolioDtos.PortfolioHistoryDto;
import app.pokefolio.portfolio.PortfolioDtos.PortfolioSummaryDto;
import app.pokefolio.security.CurrentUser;
import app.pokefolio.transaction.TransactionService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import java.util.List;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1")
@Validated
@Tag(name = "Portfolio")
public class PortfolioController {

    private final HoldingService holdings;
    private final PortfolioService portfolio;
    private final TransactionService transactions;
    private final CurrentUser currentUser;

    public PortfolioController(HoldingService holdings, PortfolioService portfolio, TransactionService transactions,
            CurrentUser currentUser) {
        this.holdings = holdings;
        this.portfolio = portfolio;
        this.transactions = transactions;
        this.currentUser = currentUser;
    }

    @GetMapping("/holdings")
    @Operation(summary = "List the user's copies (default: current collection)")
    public PageResponse<HoldingDto> listHoldings(
            @RequestParam(defaultValue = "ACTIVE") HoldingStatus status,
            @RequestParam(required = false) UUID cardId,
            @RequestParam(defaultValue = "0") @Min(0) int page,
            @RequestParam(defaultValue = "50") @Min(1) @Max(200) int size) {
        return holdings.list(currentUser.id(), status, cardId, page, size);
    }

    @GetMapping("/holdings/{id}")
    public HoldingDto getHolding(@PathVariable UUID id) {
        return holdings.get(currentUser.id(), id);
    }

    @PostMapping("/holdings")
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Add one or more copies of a card (recorded as a purchase)")
    public List<HoldingDto> addHoldings(@Valid @RequestBody AddHoldingRequest request) {
        UUID userId = currentUser.id();
        return transactions.recordPurchase(userId, request).stream()
                .map(h -> holdings.get(userId, h.getId())).toList();
    }

    @PutMapping("/holdings/{id}")
    @Operation(summary = "Edit condition, language, variant, purchase data or notes of a copy")
    public HoldingDto updateHolding(@PathVariable UUID id, @Valid @RequestBody UpdateHoldingRequest request) {
        return holdings.update(currentUser.id(), id, request);
    }

    @GetMapping("/collection")
    @Operation(summary = "Current collection grouped per card")
    public PageResponse<CollectionEntryDto> collection(
            @RequestParam(required = false) String q,
            @RequestParam(defaultValue = "VALUE") CollectionSort sort,
            @RequestParam(defaultValue = "0") @Min(0) int page,
            @RequestParam(defaultValue = "20") @Min(1) @Max(100) int size) {
        return holdings.collection(currentUser.id(), q, sort, page, size);
    }

    @GetMapping("/portfolio/summary")
    public PortfolioSummaryDto summary() {
        return portfolio.summary(currentUser.id());
    }

    @GetMapping("/portfolio/dashboard")
    @Operation(summary = "Summary, recently added, most valuable copies and recent transactions")
    public DashboardDto dashboard() {
        return portfolio.dashboard(currentUser.id());
    }

    @GetMapping("/portfolio/history")
    @Operation(summary = "Daily portfolio value and cost basis")
    public PortfolioHistoryDto history(@RequestParam(defaultValue = "90") @Min(7) @Max(1825) int days) {
        return portfolio.history(currentUser.id(), days);
    }
}
