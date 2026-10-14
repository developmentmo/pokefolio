# API

Basis-URL: `/api/v1`. JSON in en uit. De volledige, actuele specificatie genereert springdoc: `/v3/api-docs`
(OpenAPI 3) en `/swagger-ui.html`. In het `prod`-profiel staan die uit, tenzij `POKEFOLIO_SWAGGER_ENABLED=true`.

## Conventies

- **Authenticatie**: `Authorization: Bearer <accessToken>` op alles behalve `/auth/**`.
- **Eigenaar**: wordt altijd uit het token gehaald. Geen enkel endpoint accepteert een `userId`. Een id van een
  andere gebruiker geeft `404`.
- **Geld**: decimale strings of getallen met maximaal 2 decimalen (`"300.00"`). Responses gebruiken `BigDecimal`.
  Een onbekende prijs is `null`, nooit `0`.
- **Datums**: `YYYY-MM-DD` voor kalenderdatums, ISO-8601 met tijdzone voor tijdstippen.
- **Paginering**: `?page=0&size=20` (size 1–100; `/holdings` tot 200). Response:
  `{"content":[...],"page":0,"size":20,"totalElements":42,"totalPages":3}`.
- **Fouten**: RFC 9457 ProblemDetail met een stabiele `code`, bij validatiefouten aangevuld met `errors` per veld:

```json
{
  "type": "https://pokefolio.app/problems/validation_failed",
  "title": "Bad Request",
  "status": 400,
  "detail": "Request validation failed",
  "code": "validation_failed",
  "errors": { "email": "must be a well-formed email address" }
}
```

| Status | `code` | Wanneer |
|--------|--------|---------|
| 400 | `validation_failed`, `malformed_request`, `bad_request` | Ongeldige invoer |
| 401 | `unauthorized` | Geen/ongeldig token, verkeerde inloggegevens |
| 404 | `not_found` | Bestaat niet, of is van een andere gebruiker |
| 403 | `forbidden` | Geen toegang |
| 409 | `conflict`, `concurrent_modification` | E-mail al in gebruik, exemplaar niet meer actief, gelijktijdige wijziging |

## Authenticatie en account

| Methode | Pad | Body | Response |
|---------|-----|------|----------|
| POST | `/auth/register` | `{email, password, displayName}` | `201` AuthSession |
| POST | `/auth/login` | `{email, password}` | `200` AuthSession |
| POST | `/auth/refresh` | `{refreshToken}` | `200` AuthSession (nieuw refresh token) |
| POST | `/auth/logout` | `{refreshToken}` | `204` |
| POST | `/auth/password/forgot` | `{email}` | altijd `202` |
| POST | `/auth/password/reset` | `{token, newPassword}` | `204`, trekt alle sessies in |
| GET | `/account` | | Account |
| PATCH | `/account` | `{displayName?, preferredCurrency?}` | Account |
| POST | `/account/password` | `{currentPassword, newPassword}` | `204` |
| DELETE | `/account` | `{password}` | `204`, verwijdert account en alle data |

AuthSession: `{accessToken, refreshToken, expiresInSeconds, account: {id, email, displayName, preferredCurrency, createdAt}}`.
Wachtwoorden: 10 tot 128 tekens.

## Catalogus

| Methode | Pad | Parameters |
|---------|-----|------------|
| GET | `/cards` | `q` (naam/nummer/set), `setId`, `number`, `rarity`, `sort` = `NAME`\|`NUMBER`\|`NEWEST`, paginering |
| GET | `/cards/{id}` | Kaart met `price` (PriceInfo) |
| GET | `/cards/{id}/prices` | `days` (1–1825): prijshistorie |
| GET | `/sets`, `/sets/{id}` | |
| GET | `/catalog/filters` | Beschikbare sets en zeldzaamheden |

PriceInfo: `{market, low, high, currency, source, observedAt, sampleData, stale}`, of `null` als er geen prijs is.

## Collectie

| Methode | Pad | Body / parameters |
|---------|-----|-------------------|
| GET | `/holdings` | `status` (`ACTIVE`, `SOLD`, …), `cardId`, paginering |
| GET | `/holdings/{id}` | |
| POST | `/holdings` | AddHolding: maakt `quantity` exemplaren plus één `PURCHASE`-transactie |
| PUT | `/holdings/{id}` | UpdateHolding (alleen actieve exemplaren) |
| GET | `/collection` | `q`, `sort` = `VALUE`\|`NAME`\|`RECENT`\|`GAIN`\|`COPIES`, paginering. Actieve exemplaren gegroepeerd per kaart |

```json
POST /api/v1/holdings
{
  "cardId": "f8179607-…",
  "quantity": 2,
  "condition": "NEAR_MINT",
  "language": "EN",
  "variant": "NORMAL",
  "purchasePrice": "300.00",
  "purchaseDate": "2026-10-14",
  "notes": null
}
```

Enums: `condition` = `MINT, NEAR_MINT, EXCELLENT, GOOD, LIGHT_PLAYED, PLAYED, POOR`;
`language` = `EN, NL, DE, FR, IT, ES, PT, JA, KO, ZH`;
`variant` = `NORMAL, HOLO, REVERSE_HOLO, FIRST_EDITION, SHADOWLESS, UNLIMITED, PROMO, STAMPED`.

## Portfolio

| Methode | Pad | Inhoud |
|---------|-----|--------|
| GET | `/portfolio/summary` | Marktwaarde, aankoopwaarde, (on)gerealiseerde winst, prijsdekking, bronnen, `warnings` |
| GET | `/portfolio/dashboard` | Summary + waardevolste kaarten, recent toegevoegd, recente transacties |
| GET | `/portfolio/history` | `days` (7–1825): dagelijkse marktwaarde en aankoopwaarde, plus `methodology` |

`warnings` kan bevatten: `SAMPLE_PRICES`, `UNPRICED_COPIES`, `STALE_PRICES`, `MISSING_PURCHASE_PRICES`.

## Transacties

| Methode | Pad | Body |
|---------|-----|------|
| GET | `/transactions` | `type`, `from`, `to`, paginering |
| GET | `/transactions/{id}` | |
| POST | `/transactions/sales` | `{holdingIds[], date, proceeds, fees?, notes?}` |
| POST | `/transactions/gifts` | `{holdingIds[], date, notes?}` |
| POST | `/transactions/trades` | `{givenHoldingIds[], received[], date, cashReceived?, cashPaid?, notes?}` |
| POST | `/transactions/corrections` | `{holdingIds[], date, notes?}`: verwijdert exemplaren die per abuis zijn toegevoegd |

`received[]` bij een ruil: `{cardId, quantity, condition, language, variant, value?, notes?}`. `value` is de
waarde per ontvangen exemplaar en wordt de aankoopprijs ervan.

Alle mutaties zijn atomair. Als één van de opgegeven exemplaren niet (meer) actief is of niet van jou is, wordt
niets gewijzigd (`409` of `404`).

## Gezondheid

`GET /actuator/health`, `/actuator/health/liveness`, `/actuator/health/readiness` en `/actuator/info` zijn publiek.
In `prod` toont health geen details.
