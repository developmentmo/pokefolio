# Deployment, back-up en herstel

## Onderdelen

| Container | Image | Poort | Healthcheck |
|-----------|-------|-------|-------------|
| `db` | `postgres:17-alpine` | 5432 (alleen localhost in dev, niet gepubliceerd in prod) | `pg_isready` |
| `backend` | `backend/Dockerfile` (Temurin 21 JRE, non-root) | 8080 | `/actuator/health/readiness` |
| `web` | `app/Dockerfile` (Flutter web build, geserveerd door nginx) | 8081 → 80 | |

## Configuratie

Alle configuratie komt uit omgevingsvariabelen; geheimen staan nooit in Git of in de Flutter-build.

| Variabele | Verplicht | Omschrijving |
|-----------|-----------|--------------|
| `POKEFOLIO_DB_URL` | ja (buiten Compose) | JDBC-URL, bijv. `jdbc:postgresql://db:5432/pokefolio` |
| `POKEFOLIO_DB_USER` / `POKEFOLIO_DB_PASSWORD` | ja | Databasegebruiker en -wachtwoord |
| `POKEFOLIO_JWT_SECRET` | ja | ≥ 32 bytes willekeurig (`openssl rand -base64 48`). Wijzigen maakt alle access tokens ongeldig |
| `POKEFOLIO_ALLOWED_ORIGINS` | ja in prod | Origin(s) van de webapp, bijv. `https://app.example.com` |
| `SPRING_PROFILES_ACTIVE` | | `dev` (standaard) of `prod` |
| `POKEFOLIO_PROVIDER` | | `mock` (standaard). `pokemon-api` is geblokkeerd tot het contract geverifieerd is |
| `POKEMON_API_KEY` | | Alleen backend. Nooit in de app |
| `POKEFOLIO_SWAGGER_ENABLED` | | `true` om Swagger UI in prod aan te zetten |
| `POKEFOLIO_PUBLIC_API_URL` | | API-URL die in de Flutter-webbuild wordt gecompileerd (geen geheim) |

Verschil tussen profielen:

- `dev`: health toont details, CORS staat `http://localhost:*` toe, wachtwoordhersteltokens worden gelogd
  (er is nog geen e-mailverzending), Swagger UI aan.
- `prod`: health zonder details, Swagger uit, hersteltokens worden **niet** gelogd. Er wordt alleen een waarschuwing
  gelogd dat er geen e-mailverzending is geconfigureerd (zie "Openstaand").

## Productie met Docker Compose

```bash
# vul de geheimen in, zet POKEFOLIO_ALLOWED_ORIGINS op je publieke web-origin
cp .env.example .env
                         # en POKEFOLIO_PUBLIC_API_URL op de publieke API-URL
docker compose -f docker-compose.yml -f docker-compose.prod.yml --profile web up -d --build
# backend moet "healthy" worden
docker compose ps
```

Zet een reverse proxy met TLS (Caddy, Traefik of nginx) voor `backend` (8080) en `web` (8081). Backend en web
luisteren in Compose alleen op `127.0.0.1`. Flyway voert databasemigraties automatisch uit bij het opstarten; een
mislukte migratie stopt de start.

### Zonder Docker

```bash
cd backend && mvn -B package
SPRING_PROFILES_ACTIVE=prod POKEFOLIO_DB_URL=... POKEFOLIO_DB_USER=... POKEFOLIO_DB_PASSWORD=... \
POKEFOLIO_JWT_SECRET=... POKEFOLIO_ALLOWED_ORIGINS=https://app.example.com \
java -jar target/pokefolio-backend-0.1.0-SNAPSHOT.jar

cd app && flutter build web --release --no-web-resources-cdn \
  --dart-define=POKEFOLIO_API_URL=https://api.example.com
# serveer app/build/web als statische site met SPA-fallback naar index.html (zie app/nginx.conf)
```

### Mobiele apps

```bash
cd app
flutter build apk --release --dart-define=POKEFOLIO_API_URL=https://api.example.com
# iOS: alleen op macOS met Xcode
flutter build ipa --release --dart-define=POKEFOLIO_API_URL=https://api.example.com
```

Ondertekening (Android keystore, Apple-certificaten) is niet in deze repository opgenomen en hoort in de
CI-geheimen of op de buildmachine.

## Monitoring

- Liveness `/actuator/health/liveness`, readiness `/actuator/health/readiness` (inclusief database).
- Metrics (`/actuator/metrics`, `/actuator/prometheus`) zijn gebouwd maar via HTTP standaard afgeschermd. Om ze te
  scrapen: zet `management.server.port` op een interne poort en sta die alleen voor je monitoringnetwerk open.
- Logs gaan naar stdout (`docker compose logs -f backend`).

## Back-up

De enige stateful component is PostgreSQL. De catalogus en mock-prijzen worden bij het opstarten opnieuw
gesynchroniseerd; gebruikersdata (accounts, exemplaren, transacties) bestaat alleen in de database.

Dagelijkse logische back-up (bijv. via cron op de host):

```bash
#!/usr/bin/env sh
set -eu
STAMP=$(date +%Y%m%d-%H%M%S)
mkdir -p /var/backups/pokefolio
docker compose -f /srv/pokefolio/docker-compose.yml exec -T db \
  pg_dump -U pokefolio -d pokefolio --format=custom --no-owner \
  > /var/backups/pokefolio/pokefolio-$STAMP.dump
# bewaar 14 dagen
find /var/backups/pokefolio -name 'pokefolio-*.dump' -mtime +14 -delete
```

Aanbevelingen:

- Kopieer de dumps versleuteld naar opslag buiten de server (bijv. `restic` of `rclone` naar object storage).
- Bewaar `.env` (met name `POKEFOLIO_DB_PASSWORD` en `POKEFOLIO_JWT_SECRET`) apart in een wachtwoordkluis, niet bij
  de dumps.
- Test het herstel periodiek met de procedure hieronder op een aparte omgeving.

## Herstel

```bash
# 1. Stop de backend zodat er niet geschreven wordt
docker compose stop backend

# 2. Maak de database leeg en herstel de dump
docker compose exec -T db psql -U pokefolio -d postgres \
  -c "DROP DATABASE IF EXISTS pokefolio WITH (FORCE);" -c "CREATE DATABASE pokefolio OWNER pokefolio;"
docker compose exec -T db pg_restore -U pokefolio -d pokefolio --no-owner --exit-on-error \
  < /var/backups/pokefolio/pokefolio-YYYYMMDD-HHMMSS.dump

# 3. Start de backend; Flyway past eventuele nieuwere migraties toe
docker compose start backend
curl -fsS http://localhost:8080/actuator/health/readiness
```

Een dump van een oudere versie herstellen in een nieuwere backend werkt, omdat Flyway de ontbrekende migraties
daarna uitvoert. Andersom (nieuwe dump in oude backend) wordt geweigerd door Flyway-validatie.

## CI

`.github/workflows/ci.yml` draait bij elke push naar `main` en elke pull request:

1. **backend**: `mvn verify` (unit- en integratietests tegen PostgreSQL via Testcontainers).
2. **app**: controle dat gegenereerde code actueel is, `dart format`, `flutter analyze`, `flutter test` en een
   web-releasebuild.
3. **docker**: bouwt beide images.

## Openstaand voor productie

- **E-mailverzending voor wachtwoordherstel.** `PasswordResetNotifier` is een interface; in `dev` logt hij het token,
  in andere profielen waarschuwt hij alleen. Voor productie moet er een SMTP- of e-mail-API-implementatie komen.
- **Rate limiting** op `/auth/login`, `/auth/register` en `/auth/password/forgot`, bijvoorbeeld in de reverse proxy.
- **Echte kaart-/prijsprovider**: zie [pokemon-api-integration.md](pokemon-api-integration.md).
