package app.pokefolio.catalog;

import jakarta.persistence.criteria.JoinType;
import java.util.Locale;
import java.util.UUID;
import org.springframework.data.jpa.domain.Specification;

final class CardSpecifications {

    private CardSpecifications() {
    }

    static Specification<PokemonCard> search(String query, UUID setId, String number, String rarity) {
        return (root, cq, cb) -> {
            if (cq != null && Long.class != cq.getResultType() && long.class != cq.getResultType()) {
                root.fetch("set", JoinType.INNER);
            }
            var predicates = new java.util.ArrayList<jakarta.persistence.criteria.Predicate>();
            if (query != null && !query.isBlank()) {
                String like = "%" + escape(query.trim().toLowerCase(Locale.ROOT)) + "%";
                var set = root.join("set", JoinType.INNER);
                predicates.add(cb.or(
                        cb.like(cb.lower(root.get("name")), like, '\\'),
                        cb.like(cb.lower(set.get("name")), like, '\\'),
                        cb.equal(cb.lower(root.get("number")), query.trim().toLowerCase(Locale.ROOT))));
            }
            if (setId != null) {
                predicates.add(cb.equal(root.get("set").get("id"), setId));
            }
            if (number != null && !number.isBlank()) {
                predicates.add(cb.equal(cb.lower(root.get("number")), number.trim().toLowerCase(Locale.ROOT)));
            }
            if (rarity != null && !rarity.isBlank()) {
                predicates.add(cb.equal(root.get("rarity"), rarity));
            }
            return cb.and(predicates.toArray(jakarta.persistence.criteria.Predicate[]::new));
        };
    }

    private static String escape(String value) {
        return value.replace("\\", "\\\\").replace("%", "\\%").replace("_", "\\_");
    }
}
