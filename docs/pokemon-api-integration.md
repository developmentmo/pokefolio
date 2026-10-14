# Integratie met pokemon-api.com

**Status: nog niet geactiveerd.** PokeFolio draait op de ingebouwde mock-provider met voorbeeldgegevens. De
integratie met pokemon-api.com (Basic-abonnement) wordt pas gebouwd en aangezet nadat het API-contract is
geverifieerd. Er zijn bewust geen endpoints, responsevelden of prijsfunctionaliteit verzonnen.

## Waarom nog niet

Tijdens de bouw was pokemon-api.com vanuit de buildomgeving niet bereikbaar: de netwerkpolicy van die omgeving
weigerde de host (proxy-antwoord `403` op `CONNECT pokemon-api.com:443`). De documentatie kon dus niet gelezen
worden en er kon geen testverzoek met de API-key gedaan worden.

Om verder te kunnen is één van deze dingen nodig:

1. De link naar de API-documentatie, of
2. De OpenAPI-specificatie (JSON/YAML), of
3. Een paar voorbeeldresponses (een kaart, een lijst/zoekresultaat, en, als het Basic-abonnement dat biedt, een
   prijs of prijshistorie) met de API-key eruit verwijderd.

## Wat er al klaarstaat

- `CardCatalogProvider` (`fetchSets()`, `fetchCards(setExternalId)`) en `PriceProvider` (`currentPrice(card)`,
  `history(card, from, to)`, `sourceId()`, `sampleData()`) zijn de enige twee interfaces die een nieuwe provider
  moet implementeren. Portfolio- en transactielogica lezen alleen uit de eigen database.
- Configuratie onder `pokefolio.pokemon-api`: `base-url`, `api-key` (uit `POKEMON_API_KEY`), `connect-timeout`,
  `read-timeout`.
- `PokemonApiProviderGuard` laat de applicatie bewust **niet starten** als `pokefolio.provider=pokemon-api` wordt
  gezet, zodat niemand per ongeluk een niet-geverifieerde integratie aanzet.
- Catalogus en prijzen zijn per provider gescheiden (`provider` + `external_id`, `source` per prijsobservatie).
  Mock-data en echte data kunnen dus naast elkaar bestaan, en mock-prijzen blijven als `sample_data` gemarkeerd.

## Verificatiechecklist vóór activering

- [ ] Documentatie of OpenAPI-specificatie ontvangen en gelezen.
- [ ] Authenticatiemethode bevestigd (header-naam en formaat van de API-key).
- [ ] Endpoints voor sets en kaarten (inclusief paginering) bevestigd met een echt verzoek.
- [ ] Vastgesteld welke prijsgegevens het Basic-abonnement levert: welke velden (market/low/high), welke valuta,
      welke bron (bijv. Cardmarket of TCGplayer), per variant of per kaart, en of er historie is.
- [ ] Rate limits en quotum van het Basic-abonnement bekend; refresh-schema (`pokefolio.pricing.refresh-cron`) en
      batchgrootte daarop afgestemd.
- [ ] Gedrag bij ontbrekende prijs vastgesteld en gemapt naar "geen observatie" (nooit `0`).
- [ ] Adapter gebouwd met contracttests op basis van de echte voorbeeldresponses (WireMock of opgenomen JSON).
- [ ] Foutafhandeling: timeouts, 429 met backoff, 5xx; een mislukte refresh laat de laatst bekende prijs staan en
      die wordt na 48 uur als verouderd gemarkeerd.
- [ ] Guard vervangen door de echte adapter; `POKEFOLIO_PROVIDER=pokemon-api` en `POKEMON_API_KEY` alleen in de
      backend-omgeving gezet.

## Beveiliging van de API-key

- De key staat uitsluitend in de omgeving van de backend (`POKEMON_API_KEY`), nooit in de Flutter-app, in
  `--dart-define`, in publieke configuratie of in Git.
- De app praat alleen met de PokeFolio-backend; die haalt catalogus en prijzen op en slaat ze op.
- Log de key nooit; log bij fouten alleen statuscode en endpoint.
