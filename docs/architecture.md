# Architectuur

```
┌──────────────────────────┐      HTTPS / JSON (/api/v1)      ┌───────────────────────────┐      ┌────────────┐
│ Flutter-app              │ ───────────────────────────────▶ │ Spring Boot-backend        │ ───▶ │ PostgreSQL │
│ web · Android · iOS      │   Bearer access token (JWT)      │ modulaire monoliet         │      └────────────┘
│ Riverpod · GoRouter · Dio│ ◀─────────────────────────────── │ catalog · pricing ·        │
└──────────────────────────┘   ProblemDetail-fouten           │ portfolio · transaction ·  │ ───▶ kaart-/prijsprovider
                                                              │ account · security         │      (mock, later pokemon-api.com)
                                                              └───────────────────────────┘
```

## Backend

Eén deploybare Spring Boot-applicatie (`app.pokefolio`), opgedeeld in modules per domein. Elke module bevat zijn
eigen entiteiten, repositories, service, controller en DTO's.

| Package | Verantwoordelijkheid |
|---------|----------------------|
| `account` | Registratie, login, refresh, logout, wachtwoordherstel, accountbeheer |
| `security` | JWT-uitgifte en -validatie, CORS, `CurrentUser` (eigenaar uit het token) |
| `catalog` | Gedeelde kaartcatalogus (sets, kaarten), zoeken met filters en paginering, synchronisatie vanuit de provider |
| `pricing` | Gedateerde prijsobservaties, verversen en backfill, prijshistorie, verouderingsdetectie |
| `portfolio` | Exemplaren (holdings), collectie-overzicht, waardering, dashboard, portfoliohistorie |
| `transaction` | Aankoop, verkoop, weggeven, ruil en correctie; atomair en met volledige historie |
| `mock` | Mock-catalogus en deterministische mock-prijzen (voorbeeldgegevens) |
| `provider.pokemonapi` | Configuratie en guard voor de nog te verifiëren pokemon-api.com-integratie |
| `common` | Basisentiteit, foutafhandeling (ProblemDetail), paginering, klok, OpenAPI |

### Belangrijke keuzes

- **Eén rij per fysiek exemplaar.** Twee identieke Charizards zijn twee `card_holdings`. Daardoor kan elk exemplaar
  een eigen aankoopprijs, conditie en lot hebben, en is verkoop van "1 van de 3" eenduidig. Afgestoten exemplaren
  blijven bestaan met een status (`SOLD`, `GIVEN_AWAY`, `TRADED_AWAY`, `REMOVED`) en `disposed_on`, zodat historie
  en gerealiseerde winst reconstrueerbaar blijven.
- **Transacties zijn de bron van waarheid voor mutaties.** Toevoegen maakt een `PURCHASE`, verkopen een `SALE`, enz.
  Een transactie heeft regels per exemplaar met richting `IN`/`OUT`. Een ruil met meerdere kaarten aan beide kanten
  is één databasetransactie: alles slaagt of niets.
- **Concurrency.** Bij afstoten worden de betrokken exemplaren met een pessimistische lock geladen en is er een
  `@Version`-kolom. Dubbel verkopen van hetzelfde exemplaar geeft `409 Conflict`.
- **Geld als `BigDecimal`/`NUMERIC(12,2)`.** Opbrengst min kosten wordt gelijk over de verkochte exemplaren
  verdeeld; de restcent gaat naar het eerste exemplaar, zodat de som exact klopt.
- **Onbekend is niet nul.** Een ontbrekende prijs is de afwezigheid van een rij in `price_observations`. Exemplaren
  zonder prijs tellen niet mee in de marktwaarde en worden apart gemeld (`UNPRICED_COPIES`). Ongerealiseerde winst
  telt alleen exemplaren met zowel een prijs als een aankoopprijs.
- **Verouderde prijzen.** Een prijs ouder dan `pokefolio.pricing.stale-after` (standaard 48 uur) wordt nog gebruikt
  maar gemarkeerd (`STALE_PRICES`, met datum van de oudste prijs).
- **Portfoliohistorie** wordt berekend, niet opgeslagen: op dag D telt een exemplaar mee als `acquired_on ≤ D` en
  het niet vóór of op D is afgestoten, gewaardeerd tegen de laatste prijsobservatie op of vóór D.
- **Providers achter interfaces.** `CardCatalogProvider` en `PriceProvider` abstraheren de bron. Welke actief is,
  bepaalt `pokefolio.provider` (`mock`). De echte provider wordt pas actief na verificatie van het API-contract.

### Beveiliging

- Access tokens: HS256-JWT, 15 minuten geldig, subject = user-id. Secret uit `POKEFOLIO_JWT_SECRET` (≥ 32 bytes),
  anders start de applicatie niet.
- Refresh tokens: willekeurig, opaak, alleen als SHA-256-hash opgeslagen, 30 dagen, roteren bij elk gebruik.
  Hergebruik van een al geroteerd token trekt alle refresh tokens van die gebruiker in (diefstaldetectie).
- Wachtwoordherstel: token van 32 willekeurige bytes, alleen als hash opgeslagen, 30 minuten geldig, eenmalig.
  Het endpoint antwoordt altijd `202`, zodat niet te achterhalen is of een e-mailadres bestaat. Na een reset worden
  alle sessies ingetrokken.
- Gebruikersisolatie: elke query in `portfolio` en `transaction` filtert op de user-id uit het token. Een id van een
  ander geeft `404` (geen `403`, om bestaan niet te lekken). Integratietests bewijzen dit.
- Alles onder `/api/v1/**` behalve `/api/v1/auth/**` vereist authenticatie; onbekende paden zijn `denyAll`.
  Actuator `metrics`/`prometheus` zijn daardoor niet publiek bereikbaar.

## Flutter-app

```
lib/
  core/       configuratie, thema, formatters (nl_NL), netwerk (Dio + token refresh), opslag, gedeelde widgets
  domain/     Freezed-modellen, enums, invoer-DTO's, portfoliorekenregels
  data/       repository-interfaces, API-implementaties, mock-implementaties, Riverpod-providers en queries
  features/   auth, dashboard, collection, catalog, holdings, transactions, analysis, profile
```

- **Repository-abstractie**: `AuthenticationRepository`, `CardCatalogRepository`, `PortfolioRepository`,
  `TransactionRepository` en `PriceRepository`. `AppConfig` kiest op basis van `--dart-define`:
  zonder `POKEFOLIO_API_URL` de in-memory mock (met dezelfde bedrijfsregels als de backend), anders de API.
- **Tokens**: het access token blijft in geheugen; het refresh token staat in `flutter_secure_storage`. Een
  Dio-interceptor ververst bij `401` precies één keer en herhaalt het verzoek.
- **Staat**: Riverpod `FutureProvider`s per scherm; na een mutatie ververst `invalidatePortfolio()` alle afhankelijke
  views. Lijsten die compleet moeten zijn (collectie, actieve exemplaren) halen alle pagina's op met de maximale
  paginagrootte van de API.
- **Responsief**: `NavigationBar` onder 700 px, `NavigationRail` daarboven (uitgeklapt vanaf 1100 px). Widgettests
  renderen alle schermen op telefoon-, tablet- en desktopformaat.
- Elk scherm heeft een laad-, fout- (met opnieuw proberen) en lege toestand.
