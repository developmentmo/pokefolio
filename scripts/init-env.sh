#!/usr/bin/env sh
# Creates .env from .env.example with freshly generated secrets.
# Works on macOS and Linux. Refuses to overwrite an existing .env.
set -eu
cd "$(dirname "$0")/.."
if [ -f .env ]; then
  echo ".env bestaat al; niets gewijzigd. Verwijder het eerst als je nieuwe geheimen wilt." >&2
  exit 1
fi
db_password=$(openssl rand -hex 24)
jwt_secret=$(openssl rand -hex 48)
awk -v db="$db_password" -v jwt="$jwt_secret" '
  /^POKEFOLIO_DB_PASSWORD=/ { print "POKEFOLIO_DB_PASSWORD=" db; next }
  /^POKEFOLIO_JWT_SECRET=/  { print "POKEFOLIO_JWT_SECRET=" jwt; next }
  { print }
' .env.example > .env
chmod 600 .env
echo ".env aangemaakt met nieuwe geheimen. Start nu: docker compose up -d --build"
