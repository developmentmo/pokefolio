# syntax=docker/dockerfile:1
# Builds the PokeFolio Flutter web app and serves it with nginx.

FROM debian:bookworm-slim AS build
# Pinned to the same Flutter release as CI (.github/workflows/ci.yml).
ARG FLUTTER_VERSION=3.47.7
RUN apt-get update \
 && apt-get install -y --no-install-recommends ca-certificates curl git unzip xz-utils \
 && rm -rf /var/lib/apt/lists/*
RUN git clone --depth 1 --branch ${FLUTTER_VERSION} https://github.com/flutter/flutter.git /opt/flutter
ENV PATH="/opt/flutter/bin:${PATH}"
RUN flutter config --no-analytics --enable-web && flutter precache --web
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
