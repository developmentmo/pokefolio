import 'package:flutter/material.dart';

/// PokeFolio visual identity: deep navy surfaces with violet and electric-blue accents.
class PokeFolioColors {
  const PokeFolioColors._();

  static const background = Color(0xFF0A0F1F);
  static const surface = Color(0xFF111831);
  static const surfaceRaised = Color(0xFF18213F);
  static const outline = Color(0xFF2A3560);
  static const violet = Color(0xFF8B5CF6);
  static const electric = Color(0xFF38BDF8);
  static const textPrimary = Color(0xFFF1F4FF);
  static const textSecondary = Color(0xFFA9B2D6);
  static const gain = Color(0xFF34D399);
  static const loss = Color(0xFFFB7185);
  static const warning = Color(0xFFFBBF24);

  static const brandGradient = LinearGradient(
    colors: [violet, electric],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

ThemeData buildPokeFolioTheme() {
  final scheme = ColorScheme.fromSeed(seedColor: PokeFolioColors.violet, brightness: Brightness.dark).copyWith(
    primary: PokeFolioColors.violet,
    secondary: PokeFolioColors.electric,
    surface: PokeFolioColors.surface,
    surfaceContainerHighest: PokeFolioColors.surfaceRaised,
    outline: PokeFolioColors.outline,
    onSurface: PokeFolioColors.textPrimary,
    onSurfaceVariant: PokeFolioColors.textSecondary,
    error: PokeFolioColors.loss,
  );
  final base = ThemeData(useMaterial3: true, colorScheme: scheme, brightness: Brightness.dark);
  final text = base.textTheme.apply(bodyColor: PokeFolioColors.textPrimary, displayColor: PokeFolioColors.textPrimary);
  return base.copyWith(
    scaffoldBackgroundColor: PokeFolioColors.background,
    textTheme: text.copyWith(
      headlineMedium: text.headlineMedium?.copyWith(fontWeight: FontWeight.w700, letterSpacing: -0.5),
      headlineSmall: text.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
      titleLarge: text.titleLarge?.copyWith(fontWeight: FontWeight.w600),
      titleMedium: text.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      labelLarge: text.labelLarge?.copyWith(fontWeight: FontWeight.w600),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: PokeFolioColors.background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      color: PokeFolioColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: PokeFolioColors.outline, width: 0.6),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: PokeFolioColors.surfaceRaised,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: PokeFolioColors.outline, width: 0.6),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: PokeFolioColors.electric, width: 1.5),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(64, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(64, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: const BorderSide(color: PokeFolioColors.outline),
      ),
    ),
    chipTheme: base.chipTheme.copyWith(
      backgroundColor: PokeFolioColors.surfaceRaised,
      side: const BorderSide(color: PokeFolioColors.outline, width: 0.6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: PokeFolioColors.surface,
      indicatorColor: PokeFolioColors.violet.withValues(alpha: 0.25),
      surfaceTintColor: Colors.transparent,
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: PokeFolioColors.surface,
      indicatorColor: PokeFolioColors.violet.withValues(alpha: 0.25),
    ),
    dividerTheme: const DividerThemeData(color: PokeFolioColors.outline, thickness: 0.6),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
  );
}
