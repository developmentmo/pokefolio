package app.pokefolio.catalog;

import app.pokefolio.catalog.CatalogDtos.CardSetDto;
import app.pokefolio.catalog.CatalogDtos.CatalogFiltersDto;
import app.pokefolio.common.NotFoundException;
import java.util.List;
import java.util.UUID;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional(readOnly = true)
public class CatalogService {

    public enum CardSort { NAME, NUMBER, NEWEST }

    private final PokemonCardRepository cards;
    private final CardSetRepository sets;

    public CatalogService(PokemonCardRepository cards, CardSetRepository sets) {
        this.cards = cards;
        this.sets = sets;
    }

    public Page<PokemonCard> search(String query, UUID setId, String number, String rarity, CardSort sort,
            int page, int size) {
        Sort order = switch (sort == null ? CardSort.NAME : sort) {
            case NAME -> Sort.by("name", "number");
            case NUMBER -> Sort.by("number", "name");
            case NEWEST -> Sort.by(Sort.Order.desc("set.releaseDate"), Sort.Order.asc("name"));
        };
        return cards.findAll(CardSpecifications.search(query, setId, number, rarity), PageRequest.of(page, size, order));
    }

    public PokemonCard getCard(UUID id) {
        return cards.findWithSetById(id).orElseThrow(() -> new NotFoundException("Card not found"));
    }

    public List<CardSetDto> listSets() {
        return sets.findAllByOrderByReleaseDateDescNameAsc().stream().map(CardSetDto::from).toList();
    }

    public CardSetDto getSet(UUID id) {
        return sets.findById(id).map(CardSetDto::from).orElseThrow(() -> new NotFoundException("Set not found"));
    }

    public CatalogFiltersDto filters() {
        return new CatalogFiltersDto(listSets(), cards.findDistinctRarities());
    }
}
