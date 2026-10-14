-- PokeFolio initial schema.
-- Money columns use NUMERIC(12,2); currencies are ISO-4217 codes.

CREATE TABLE users (
    id                 UUID PRIMARY KEY,
    email              VARCHAR(320) NOT NULL,
    password_hash      VARCHAR(100) NOT NULL,
    display_name       VARCHAR(80)  NOT NULL,
    preferred_currency VARCHAR(3)      NOT NULL DEFAULT 'EUR',
    created_at         TIMESTAMPTZ  NOT NULL,
    updated_at         TIMESTAMPTZ  NOT NULL,
    version            BIGINT       NOT NULL DEFAULT 0,
    CONSTRAINT uq_users_email UNIQUE (email),
    CONSTRAINT ck_users_email_lower CHECK (email = lower(email))
);

CREATE TABLE refresh_tokens (
    id         UUID PRIMARY KEY,
    user_id    UUID        NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    token_hash VARCHAR(64)    NOT NULL,
    expires_at TIMESTAMPTZ NOT NULL,
    revoked_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL,
    CONSTRAINT uq_refresh_tokens_hash UNIQUE (token_hash)
);
CREATE INDEX ix_refresh_tokens_user ON refresh_tokens (user_id);

CREATE TABLE password_reset_tokens (
    id         UUID PRIMARY KEY,
    user_id    UUID        NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    token_hash VARCHAR(64)    NOT NULL,
    expires_at TIMESTAMPTZ NOT NULL,
    used_at    TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL,
    CONSTRAINT uq_password_reset_tokens_hash UNIQUE (token_hash)
);
CREATE INDEX ix_password_reset_tokens_user ON password_reset_tokens (user_id);

-- Catalog: shared by all users, synchronised from the configured catalog provider.
CREATE TABLE card_sets (
    id           UUID PRIMARY KEY,
    provider     VARCHAR(32)  NOT NULL,
    external_id  VARCHAR(64)  NOT NULL,
    name         VARCHAR(120) NOT NULL,
    series       VARCHAR(120),
    release_date DATE,
    total_cards  INTEGER,
    created_at   TIMESTAMPTZ  NOT NULL,
    updated_at   TIMESTAMPTZ  NOT NULL,
    CONSTRAINT uq_card_sets_provider_external UNIQUE (provider, external_id)
);

CREATE TABLE pokemon_cards (
    id              UUID PRIMARY KEY,
    set_id          UUID         NOT NULL REFERENCES card_sets (id),
    provider        VARCHAR(32)  NOT NULL,
    external_id     VARCHAR(64)  NOT NULL,
    name            VARCHAR(120) NOT NULL,
    number          VARCHAR(16)  NOT NULL,
    rarity          VARCHAR(64),
    supertype       VARCHAR(32),
    pokemon_type    VARCHAR(32),
    image_url       VARCHAR(500),
    image_url_large VARCHAR(500),
    created_at      TIMESTAMPTZ  NOT NULL,
    updated_at      TIMESTAMPTZ  NOT NULL,
    CONSTRAINT uq_pokemon_cards_provider_external UNIQUE (provider, external_id)
);
CREATE INDEX ix_pokemon_cards_set ON pokemon_cards (set_id);
CREATE INDEX ix_pokemon_cards_name ON pokemon_cards (lower(name));
CREATE INDEX ix_pokemon_cards_number ON pokemon_cards (number);

-- Dated market price observations. A missing price is the absence of a row, never a zero.
CREATE TABLE price_observations (
    id           UUID PRIMARY KEY,
    card_id      UUID          NOT NULL REFERENCES pokemon_cards (id) ON DELETE CASCADE,
    source       VARCHAR(64)   NOT NULL,
    currency     VARCHAR(3)       NOT NULL,
    market_price NUMERIC(12, 2) NOT NULL CHECK (market_price >= 0),
    low_price    NUMERIC(12, 2) CHECK (low_price >= 0),
    high_price   NUMERIC(12, 2) CHECK (high_price >= 0),
    sample_data  BOOLEAN       NOT NULL,
    observed_at  TIMESTAMPTZ   NOT NULL,
    created_at   TIMESTAMPTZ   NOT NULL,
    CONSTRAINT uq_price_observation UNIQUE (card_id, source, currency, observed_at)
);
CREATE INDEX ix_price_observations_card_time ON price_observations (card_id, observed_at DESC);

-- A physical copy owned by a user. Disposed copies are kept (status + disposed_on) for history.
CREATE TABLE card_holdings (
    id                UUID PRIMARY KEY,
    user_id           UUID          NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    card_id           UUID          NOT NULL REFERENCES pokemon_cards (id),
    card_condition    VARCHAR(32)   NOT NULL,
    language          VARCHAR(8)    NOT NULL,
    variant           VARCHAR(32)   NOT NULL,
    purchase_price    NUMERIC(12, 2) CHECK (purchase_price >= 0),
    purchase_currency VARCHAR(3)       NOT NULL,
    purchase_date     DATE,
    acquired_on       DATE          NOT NULL,
    notes             VARCHAR(2000),
    status            VARCHAR(16)   NOT NULL,
    disposed_on       DATE,
    created_at        TIMESTAMPTZ   NOT NULL,
    updated_at        TIMESTAMPTZ   NOT NULL,
    version           BIGINT        NOT NULL DEFAULT 0,
    CONSTRAINT ck_card_holdings_status CHECK (status IN ('ACTIVE', 'SOLD', 'GIVEN_AWAY', 'TRADED_AWAY', 'REMOVED')),
    CONSTRAINT ck_card_holdings_disposed CHECK ((status = 'ACTIVE') = (disposed_on IS NULL)),
    CONSTRAINT ck_card_holdings_dates CHECK (disposed_on IS NULL OR disposed_on >= acquired_on)
);
CREATE INDEX ix_card_holdings_user_status ON card_holdings (user_id, status);
CREATE INDEX ix_card_holdings_user_card ON card_holdings (user_id, card_id);

CREATE TABLE transactions (
    id          UUID PRIMARY KEY,
    user_id     UUID          NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    type        VARCHAR(16)   NOT NULL,
    occurred_on DATE          NOT NULL,
    currency    VARCHAR(3)       NOT NULL,
    cash_in     NUMERIC(12, 2) CHECK (cash_in >= 0),
    cash_out    NUMERIC(12, 2) CHECK (cash_out >= 0),
    fees        NUMERIC(12, 2) CHECK (fees >= 0),
    notes       VARCHAR(2000),
    created_at  TIMESTAMPTZ   NOT NULL,
    CONSTRAINT ck_transactions_type CHECK (type IN ('PURCHASE', 'SALE', 'GIFT', 'TRADE', 'CORRECTION'))
);
CREATE INDEX ix_transactions_user_date ON transactions (user_id, occurred_on DESC, created_at DESC);

-- One line per physical copy that entered (IN) or left (OUT) the collection.
CREATE TABLE transaction_lines (
    id               UUID PRIMARY KEY,
    transaction_id   UUID          NOT NULL REFERENCES transactions (id) ON DELETE CASCADE,
    holding_id       UUID          NOT NULL REFERENCES card_holdings (id) ON DELETE CASCADE,
    card_id          UUID          NOT NULL REFERENCES pokemon_cards (id),
    direction        VARCHAR(3)    NOT NULL CHECK (direction IN ('IN', 'OUT')),
    allocated_amount NUMERIC(12, 2),
    CONSTRAINT uq_transaction_line UNIQUE (transaction_id, holding_id)
);
CREATE INDEX ix_transaction_lines_holding ON transaction_lines (holding_id);
