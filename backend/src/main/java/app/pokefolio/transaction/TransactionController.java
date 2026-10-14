package app.pokefolio.transaction;

import app.pokefolio.common.PageResponse;
import app.pokefolio.security.CurrentUser;
import app.pokefolio.transaction.TransactionDtos.CorrectionRequest;
import app.pokefolio.transaction.TransactionDtos.GiftRequest;
import app.pokefolio.transaction.TransactionDtos.SaleRequest;
import app.pokefolio.transaction.TransactionDtos.TradeRequest;
import app.pokefolio.transaction.TransactionDtos.TransactionDto;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import java.time.LocalDate;
import java.util.UUID;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/transactions")
@Validated
@Tag(name = "Transactions")
public class TransactionController {

    private final TransactionService service;
    private final CurrentUser currentUser;

    public TransactionController(TransactionService service, CurrentUser currentUser) {
        this.service = service;
        this.currentUser = currentUser;
    }

    @GetMapping
    @Operation(summary = "Transaction history, newest first")
    public PageResponse<TransactionDto> list(
            @RequestParam(required = false) TransactionType type,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate from,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate to,
            @RequestParam(defaultValue = "0") @Min(0) int page,
            @RequestParam(defaultValue = "20") @Min(1) @Max(100) int size) {
        return PageResponse.of(service.list(currentUser.id(), type, from, to, page, size), t -> t);
    }

    @GetMapping("/{id}")
    public TransactionDto get(@PathVariable UUID id) {
        return service.get(currentUser.id(), id);
    }

    @PostMapping("/sales")
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Register a sale of one or more copies")
    public TransactionDto sell(@Valid @RequestBody SaleRequest request) {
        return service.recordSale(currentUser.id(), request);
    }

    @PostMapping("/gifts")
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Register copies given away")
    public TransactionDto gift(@Valid @RequestBody GiftRequest request) {
        return service.recordGift(currentUser.id(), request);
    }

    @PostMapping("/trades")
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Register a trade: copies given and cards received, atomically")
    public TransactionDto trade(@Valid @RequestBody TradeRequest request) {
        return service.recordTrade(currentUser.id(), request);
    }

    @PostMapping("/corrections")
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Remove copies that were registered by mistake")
    public TransactionDto correct(@Valid @RequestBody CorrectionRequest request) {
        return service.recordCorrection(currentUser.id(), request);
    }
}
