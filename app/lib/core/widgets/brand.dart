import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// PokeFolio mark: a tilted collector card with a rising portfolio line. Original artwork, no third-party assets.
class PokeFolioMark extends StatelessWidget {
  const PokeFolioMark({super.key, this.size = 40});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'PokeFolio logo',
      image: true,
      child: SizedBox.square(
        dimension: size,
        child: CustomPaint(painter: _MarkPainter()),
      ),
    );
  }
}

class _MarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    // back card
    canvas.save();
    canvas.translate(w * 0.5, h * 0.5);
    canvas.rotate(-0.22);
    final back = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(-w * 0.06, 0), width: w * 0.58, height: h * 0.8),
      Radius.circular(w * 0.1),
    );
    canvas.drawRRect(back, Paint()..color = PokeFolioColors.violet.withValues(alpha: 0.35));
    canvas.restore();
    // front card
    canvas.save();
    canvas.translate(w * 0.5, h * 0.5);
    canvas.rotate(0.12);
    final frontRect = Rect.fromCenter(center: Offset(w * 0.05, 0), width: w * 0.6, height: h * 0.82);
    final front = RRect.fromRectAndRadius(frontRect, Radius.circular(w * 0.1));
    canvas.drawRRect(front, Paint()..shader = PokeFolioColors.brandGradient.createShader(frontRect));
    // rising line
    final path = Path()
      ..moveTo(frontRect.left + w * 0.1, frontRect.bottom - h * 0.2)
      ..lineTo(frontRect.left + w * 0.24, frontRect.bottom - h * 0.36)
      ..lineTo(frontRect.left + w * 0.34, frontRect.bottom - h * 0.3)
      ..lineTo(frontRect.right - w * 0.1, frontRect.top + h * 0.2);
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.06
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
    canvas.drawCircle(
      Offset(frontRect.right - w * 0.1, frontRect.top + h * 0.2),
      w * 0.055,
      Paint()..color = Colors.white,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// "PokeFolio" wordmark with gradient accent on "Folio".
class PokeFolioWordmark extends StatelessWidget {
  const PokeFolioWordmark({super.key, this.fontSize = 22, this.showMark = true});

  final double fontSize;
  final bool showMark;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(fontSize: fontSize, fontWeight: FontWeight.w800, letterSpacing: -0.5);
    return Semantics(
      label: 'PokeFolio',
      header: true,
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showMark) ...[PokeFolioMark(size: fontSize * 1.6), SizedBox(width: fontSize * 0.4)],
          Text('Poke', style: style.copyWith(color: PokeFolioColors.textPrimary)),
          ShaderMask(
            shaderCallback: (bounds) => PokeFolioColors.brandGradient.createShader(bounds),
            child: Text('Folio', style: style.copyWith(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
