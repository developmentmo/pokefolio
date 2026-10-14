# PokeFolio

PokeFolio is een portfolio-app voor Pokémon TCG-verzamelaars. Je registreert elk fysiek exemplaar (conditie, taal,
variant, aankoopdatum en -prijs), volgt de actuele marktwaarde van je collectie en legt verkopen, weggeven en ruilen
vast in een volledige transactiehistorie. Grafieken tonen de prijsontwikkeling per kaart en de waarde van je portfolio
door de tijd.

| Onderdeel | Technologie |
|-----------|-------------|
| App (`app/`) | Flutter (web, Android, iOS), Riverpod, GoRouter, Dio, Freezed, fl_chart |
| Backend (`backend/`) | Spring Boot 4.1 (Java 21), Spring Security (JWT), Spring Data JPA, Flyway, PostgreSQL 17 |
| Deployment | Docker, Docker Compose, GitHub Actions |

> **Voorbeeldgegevens.** Zolang de echte kaart- en prijsprovider niet geverifieerd is, draait PokeFolio op een
> ingebouwde mock-catalogus (28 kaarten, 10 sets) met gesimuleerde prijzen. De app toont dit overal expliciet
> ("Voorbeeld", "Prijzen zijn voorbeeldgegevens"). Zie [docs/pokemon-api-integration.md](docs/pokemon-api-integration.md).

## Snel starten

### Alleen de app (zonder backend)

Zonder `POKEFOLIO_API_URL` draait de app volledig in-memory met een demo-account.

```bash
cd app
flutter pub get
flutter run -d chrome
```

Voor Android of iOS: `flutter devices` toont de beschikbare apparaten, start daarna met `flutter run -d <device-id>`.
Zet geen commentaar (`# ...`) achter het commando: in PowerShell en cmd wordt `#` dan als bestandsnaam meegegeven.

Inloggen kan met `demo@pokefolio.app` / `pokefolio-demo`, of registreer een nieuw account. Gegevens verdwijnen bij
herstart.

### Volledige stack met Docker Compose

```bash
# Maakt .env aan met een willekeurig databasewachtwoord en JWT-secret
./scripts/init-env.sh
# PostgreSQL + backend op http://localhost:8080
docker compose up -d --build
# + webapp op http://localhost:8081
docker compose --profile web up -d --build
```

Controleer de backend met `curl http://localhost:8080/actuator/health/readiness`. In het `dev`-profiel (standaard
in Compose) maakt de backend bij de eerste start het demo-account `demo@pokefolio.app` / `pokefolio-demo` aan, met
een kleine voorbeeldcollectie. In `prod` bestaat dat account niet. In het `dev`-profiel staat de
API-documentatie op http://localhost:8080/swagger-ui.html.

### Lokaal ontwikkelen

```bash
docker compose up -d db
cd backend
POKEFOLIO_DB_PASSWORD=... POKEFOLIO_JWT_SECRET=... mvn spring-boot:run

cd ../app
flutter run -d chrome --dart-define=POKEFOLIO_API_URL=http://localhost:8080
```

## Tests en kwaliteitscontroles

```bash
# unit- en integratietests (Testcontainers, Docker vereist)
cd backend && mvn verify

cd app
dart format --line-length 120 --set-exit-if-changed lib test
flutter analyze
flutter test
flutter build web --release --no-web-resources-cdn
```

Na wijzigingen aan Freezed/JSON-modellen: `dart run build_runner build --delete-conflicting-outputs`, gevolgd door
`dart format --line-length 120 lib`.

## Documentatie

- [Architectuur en ontwerpkeuzes](docs/architecture.md)
- [Datamodel](docs/data-model.md)
- [API](docs/api.md)
- [Deployment, back-up en herstel](docs/deployment.md)
- [Integratie met pokemon-api.com](docs/pokemon-api-integration.md)

## Beveiliging in het kort

- Wachtwoorden worden alleen als bcrypt-hash opgeslagen; refresh- en hersteltokens alleen als SHA-256-hash.
- De eigenaar van elke collectie, transactie en portfolio wordt server-side afgeleid uit het access token. De API
  accepteert nergens een `userId` van de client; andermans resources geven `404`.
- Geheimen (databasewachtwoord, JWT-secret, provider-API-key) komen uitsluitend uit omgevingsvariabelen. Er staan geen
  credentials in de Flutter-code, publieke configuratie of Git. `.env` staat in `.gitignore`.

Pokémon en alle bijbehorende namen zijn handelsmerken van hun respectieve eigenaren. PokeFolio is een onafhankelijk
project en gebruikt geen officiële logo's of afbeeldingen.
