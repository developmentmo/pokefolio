import 'package:flutter/material.dart';

import '../../domain/models.dart';
import '../theme/app_theme.dart';

/// Card presentation. Uses the provider image when available, otherwise an original PokeFolio placeholder
/// (we do not bundle or hotlink official card artwork).
class CardArt extends StatelessWidget {
  const CardArt({super.key, required this.card, this.width = 120, this.large = false});

  final PokemonCard card;
  final double width;
  final bool large;

  static Color typeColor(String? type) => switch (type) {
    'Fire' => const Color(0xFFF97316),
    'Water' => const Color(0xFF3B82F6),
    'Grass' => const Color(0xFF22C55E),
    'Lightning' => const Color(0xFFEAB308),
    'Psychic' => const Color(0xFFA855F7),
    'Darkness' => const Color(0xFF475569),
    'Dragon' => const Color(0xFF14B8A6),
    'Colorless' => const Color(0xFF94A3B8),
    _ => PokeFolioColors.violet,
  };

  @override
  Widget build(BuildContext context) {
    final height = width * 88 / 63;
    final image = large ? (card.imageUrlLarge ?? card.imageUrl) : card.imageUrl;
    final placeholder = _Placeholder(card: card, width: width, height: height);
    return Semantics(
      label: '${card.name}, ${card.set.name} ${card.displayNumber}',
      image: true,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(width * 0.06),
        child: SizedBox(
          width: width,
          height: height,
          child: image == null
              ? placeholder
              : Image.network(image, fit: BoxFit.cover, errorBuilder: (_, _, _) => placeholder),
        ),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.card, required this.width, required this.height});

  final PokemonCard card;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final color = CardArt.typeColor(card.pokemonType);
    final scale = width / 120;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.95), PokeFolioColors.surfaceRaised, color.withValues(alpha: 0.6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.25), width: 2 * scale),
        borderRadius: BorderRadius.circular(width * 0.06),
      ),
      child: Padding(
        padding: EdgeInsets.all(8 * scale),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              card.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12 * scale, fontWeight: FontWeight.w800, color: Colors.white),
            ),
            const Spacer(),
            Center(
              child: Icon(Icons.auto_awesome, size: 36 * scale, color: Colors.white.withValues(alpha: 0.75)),
            ),
            const Spacer(),
            Text(
              card.set.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 9 * scale, color: Colors.white.withValues(alpha: 0.85)),
            ),
            Text(
              card.displayNumber,
              style: TextStyle(fontSize: 9 * scale, color: Colors.white.withValues(alpha: 0.85)),
            ),
          ],
        ),
      ),
    );
  }
}
