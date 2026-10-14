# Datamodel

Het schema wordt beheerd met Flyway (`backend/src/main/resources/db/migration`). Hibernate valideert het schema bij
het opstarten (`ddl-auto: validate`) maar wijzigt het nooit. Alle primaire sleutels zijn UUID's die de applicatie
toekent. Bedragen zijn `NUMERIC(12,2)`, valuta ISO-4217-codes (`VARCHAR(3)`).

```
users ─┬─< refresh_tokens
       ├─< password_reset_tokens
       ├─< card_holdings >── pokemon_cards >── card_sets
       └─< transactions ─< transaction_lines >── card_holdings
                                    pokemon_cards ─< price_observations
```

## Account

| Tabel | Belangrijkste kolommen | Opmerkingen |
|-------|------------------------|-------------|
| `users` | `email` (uniek, lowercase-check), `password_hash` (bcrypt), `display_name`, `preferred_currency`, `version` | |
| `refresh_tokens` | `user_id`, `token_hash` (SHA-256, uniek), `expires_at`, `revoked_at` | Ruwe tokens worden nooit opgeslagen |
| `password_reset_tokens` | `user_id`, `token_hash` (uniek), `expires_at`, `used_at` | Eenmalig, 30 minuten |

## Catalogus en prijzen (gedeeld door alle gebruikers)

| Tabel | Belangrijkste kolommen | Opmerkingen |
|-------|------------------------|-------------|
| `card_sets` | `provider`, `external_id` (samen uniek), `name`, `series`, `release_date`, `total_cards` | |
| `pokemon_cards` | `set_id`, `provider`, `external_id` (samen uniek), `name`, `number`, `rarity`, `supertype`, `pokemon_type`, afbeeldings-URL's | Indexen op `lower(name)` en `number` |
| `price_observations` | `card_id`, `source`, `currency`, `market_price` (verplicht), `low_price`, `high_price`, `sample_data`, `observed_at` | Uniek per kaart/bron/valuta/tijdstip. Geen prijs = geen rij |

## Collectie en transacties (per gebruiker)

**`card_holdings`**: één rij per fysiek exemplaar.

| Kolom | Betekenis |
|-------|-----------|
| `user_id` | Eigenaar, altijd afgeleid uit het token |
| `card_id` | Kaart uit de catalogus |
| `card_condition`, `language`, `variant` | Bijv. `NEAR_MINT`, `EN`, `REVERSE_HOLO` |
| `purchase_price`, `purchase_currency`, `purchase_date` | Prijs mag leeg zijn (onbekend, bijv. bij een cadeau) |
| `acquired_on` | Datum van verwerving (aankoop of ontvangst bij ruil) |
| `status`, `disposed_on` | `ACTIVE` heeft geen `disposed_on`; alle andere statussen wel (afgedwongen met een check) |
| `version` | Optimistische locking |

**`transactions`**: `type` (`PURCHASE`, `SALE`, `GIFT`, `TRADE`, `CORRECTION`), `occurred_on`, `currency`,
`cash_in` (ontvangen), `cash_out` (betaald, bijv. bijbetaling bij ruil), `fees`, `notes`.

**`transaction_lines`**: één regel per exemplaar per transactie. `direction` `IN` of `OUT`, `allocated_amount` is het
deel van de opbrengst (verkoop) of kostprijs (aankoop/ruil) dat aan dit exemplaar is toegerekend.

## Afgeleide waarden

| Waarde | Definitie |
|--------|-----------|
| Marktwaarde | Som van de laatste marktprijs van elk actief exemplaar met een bekende prijs |
| Aankoopwaarde (cost basis) | Som van `purchase_price` van actieve exemplaren met een bekende aankoopprijs |
| Ongerealiseerde winst | Marktwaarde − aankoopwaarde, alleen over exemplaren met beide bekend |
| Gerealiseerde winst | Per verkocht exemplaar: toegerekende netto-opbrengst − aankoopprijs |
| Prijsdekking | Aantal actieve exemplaren met een prijs / totaal |
