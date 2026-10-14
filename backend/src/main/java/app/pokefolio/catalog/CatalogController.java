package app.pokefolio.catalog;

import app.pokefolio.catalog.CatalogDtos.CardDto;
import app.pokefolio.catalog.CatalogDtos.CardSetDto;
import app.pokefolio.catalog.CatalogDtos.CatalogFiltersDto;
import app.pokefolio.catalog.CatalogService.CardSort;
import app.pokefolio.common.PageResponse;
import app.pokefolio.pricing.PriceHistoryDto;
import app.pokefolio.pricing.PriceService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import org.springframework.data.domain.Page;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1")
@Validated
@Tag(name = "Catalog")
public class CatalogController {

    private final CatalogService catalog;
    private final PriceService prices;

    public CatalogController(CatalogService catalog, PriceService prices) {
        this.catalog = catalog;
        this.prices = prices;
    }

    @GetMapping("/cards")
    @Operation(summary = "Search catalog cards by name, set name or card number")
    public PageResponse<CardDto> searchCards(
            @RequestParam(required = false) String q,
            @RequestParam(required = false) UUID setId,
            @RequestParam(required = false) String number,
            @RequestParam(required = false) String rarity,
            @RequestParam(defaultValue = "NAME") CardSort sort,
            @RequestParam(defaultValue = "0") @Min(0) int page,
            @RequestParam(defaultValue = "20") @Min(1) @Max(100) int size) {
        Page<PokemonCard> result = catalog.search(q, setId, number, rarity, sort, page, size);
        Map<UUID, app.pokefolio.pricing.PriceInfo> priceInfo =
                prices.currentPriceInfo(result.getContent().stream().map(PokemonCard::getId).toList());
        return PageResponse.of(result, card -> CardDto.from(card, priceInfo.get(card.getId())));
    }

    @GetMapping("/cards/{id}")
    public CardDto getCard(@PathVariable UUID id) {
        PokemonCard card = catalog.getCard(id);
        return CardDto.from(card, prices.currentPriceInfo(List.of(id)).get(id));
    }

    @GetMapping("/cards/{id}/prices")
    @Operation(summary = "Dated price observations for a card")
    public PriceHistoryDto priceHistory(@PathVariable UUID id,
            @RequestParam(defaultValue = "90") @Min(1) @Max(1825) int days) {
        catalog.getCard(id);
        return prices.history(id, days);
    }

    @GetMapping("/sets")
    public List<CardSetDto> listSets() {
        return catalog.listSets();
    }

    @GetMapping("/sets/{id}")
    public CardSetDto getSet(@PathVariable UUID id) {
        return catalog.getSet(id);
    }

    @GetMapping("/catalog/filters")
    @Operation(summary = "Available sets and rarities for search filters")
    public CatalogFiltersDto filters() {
        return catalog.filters();
    }
}
