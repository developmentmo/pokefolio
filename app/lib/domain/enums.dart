import 'package:json_annotation/json_annotation.dart';

/// Physical condition of a copy. Labels are shown in the UI.
enum CardCondition {
  @JsonValue('MINT')
  mint('Mint'),
  @JsonValue('NEAR_MINT')
  nearMint('Near Mint'),
  @JsonValue('EXCELLENT')
  excellent('Excellent'),
  @JsonValue('GOOD')
  good('Good'),
  @JsonValue('LIGHT_PLAYED')
  lightPlayed('Light Played'),
  @JsonValue('PLAYED')
  played('Played'),
  @JsonValue('POOR')
  poor('Poor');

  const CardCondition(this.label);
  final String label;
}

enum CardLanguage {
  @JsonValue('EN')
  en('Engels'),
  @JsonValue('NL')
  nl('Nederlands'),
  @JsonValue('DE')
  de('Duits'),
  @JsonValue('FR')
  fr('Frans'),
  @JsonValue('IT')
  it('Italiaans'),
  @JsonValue('ES')
  es('Spaans'),
  @JsonValue('PT')
  pt('Portugees'),
  @JsonValue('JA')
  ja('Japans'),
  @JsonValue('KO')
  ko('Koreaans'),
  @JsonValue('ZH')
  zh('Chinees');

  const CardLanguage(this.label);
  final String label;
}

enum CardVariant {
  @JsonValue('NORMAL')
  normal('Normaal'),
  @JsonValue('HOLO')
  holo('Holo'),
  @JsonValue('REVERSE_HOLO')
  reverseHolo('Reverse Holo'),
  @JsonValue('FIRST_EDITION')
  firstEdition('1st Edition'),
  @JsonValue('SHADOWLESS')
  shadowless('Shadowless'),
  @JsonValue('UNLIMITED')
  unlimited('Unlimited'),
  @JsonValue('PROMO')
  promo('Promo'),
  @JsonValue('STAMPED')
  stamped('Stamped');

  const CardVariant(this.label);
  final String label;
}

enum HoldingStatus {
  @JsonValue('ACTIVE')
  active('In collectie'),
  @JsonValue('SOLD')
  sold('Verkocht'),
  @JsonValue('GIVEN_AWAY')
  givenAway('Weggegeven'),
  @JsonValue('TRADED_AWAY')
  tradedAway('Geruild'),
  @JsonValue('REMOVED')
  removed('Verwijderd');

  const HoldingStatus(this.label);
  final String label;
}

enum TransactionType {
  @JsonValue('PURCHASE')
  purchase('Aankoop'),
  @JsonValue('SALE')
  sale('Verkoop'),
  @JsonValue('GIFT')
  gift('Weggegeven'),
  @JsonValue('TRADE')
  trade('Ruil'),
  @JsonValue('CORRECTION')
  correction('Correctie');

  const TransactionType(this.label);
  final String label;

  String get apiValue => switch (this) {
    purchase => 'PURCHASE',
    sale => 'SALE',
    gift => 'GIFT',
    trade => 'TRADE',
    correction => 'CORRECTION',
  };
}

enum LineDirection {
  @JsonValue('IN')
  incoming,
  @JsonValue('OUT')
  outgoing,
}

enum PriceStatus {
  @JsonValue('AVAILABLE')
  available,
  @JsonValue('UNKNOWN')
  unknown,
}

/// API value of an enum annotated with @JsonValue (SCREAMING_SNAKE of its name).
String enumApiValue(Enum value) => value.name.replaceAllMapped(RegExp('[A-Z]'), (m) => '_${m[0]}').toUpperCase();
