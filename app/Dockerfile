# syntax=docker/dockerfile:1
# Builds the PokeFolio Flutter web app and serves it with nginx.

FROM ghcr.io/cirruslabs/flutter:stable AS build
WORKDIR /app
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get
COPY . .
# Public build-time configuration only: never pass secrets here.
ARG POKEFOLIO_API_URL=""
ARG POKEFOLIO_DATA_SOURCE=""
RUN flutter build web --release --no-web-resources-cdn \
      --dart-define=POKEFOLIO_API_URL=${POKEFOLIO_API_URL} \
      --dart-define=POKEFOLIO_DATA_SOURCE=${POKEFOLIO_DATA_SOURCE}

FROM nginx:1.27-alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/build/web /usr/share/nginx/html
EXPOSE 80
HEALTHCHECK --interval=30s --timeout=3s CMD wget -qO- http://localhost/ >/dev/null || exit 1
