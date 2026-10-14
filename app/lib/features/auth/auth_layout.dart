import 'package:flutter/material.dart';

import '../../core/config/app_config.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/brand.dart';
import '../../core/widgets/states.dart';

/// Welcome layout for login, registration and password recovery: brand panel + form.
class AuthLayout extends StatelessWidget {
  const AuthLayout({super.key, required this.title, required this.subtitle, required this.child});

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 900;
    final form = Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!wide) ...[const Center(child: PokeFolioWordmark(fontSize: 28)), const SizedBox(height: 32)],
              Semantics(header: true, child: Text(title, style: Theme.of(context).textTheme.headlineMedium)),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: PokeFolioColors.textSecondary),
              ),
              const SizedBox(height: 28),
              if (AppConfig.useMockData) ...[
                const SampleDataBanner(
                  text:
                      'Demo-modus: alle kaarten en prijzen zijn voorbeeldgegevens. '
                      'Log in met demo@pokefolio.app / pokefolio-demo of maak een account.',
                ),
                const SizedBox(height: 20),
              ],
              child,
            ],
          ),
        ),
      ),
    );
    if (!wide) return Scaffold(body: SafeArea(child: form));
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1B1446), PokeFolioColors.background, Color(0xFF0B2A44)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.all(56),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PokeFolioWordmark(fontSize: 30),
                  const Spacer(),
                  Text(
                    'Jouw verzameling.\nJouw portfolio.',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Beheer je Pokémon TCG-kaarten, volg marktwaarde en winst, en houd elke verkoop, '
                    'gift en ruil bij in één overzicht.',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: PokeFolioColors.textSecondary),
                  ),
                  const SizedBox(height: 32),
                  const Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _Feature(Icons.show_chart, 'Portfoliowaarde'),
                      _Feature(Icons.style, 'Meerdere exemplaren'),
                      _Feature(Icons.swap_horiz, 'Ruilen & verkopen'),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    'PokeFolio is niet verbonden aan Nintendo, Creatures of The Pokémon Company.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: PokeFolioColors.textSecondary),
                  ),
                ],
              ),
            ),
          ),
          Expanded(child: form),
        ],
      ),
    );
  }
}

class _Feature extends StatelessWidget {
  const _Feature(this.icon, this.label);

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Chip(avatar: Icon(icon, size: 18), label: Text(label));
}

String? validateEmail(String? v) {
  if (v == null || v.trim().isEmpty) return 'Vul je e-mailadres in';
  if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim())) return 'Ongeldig e-mailadres';
  return null;
}

String? validateNewPassword(String? v) {
  if (v == null || v.length < 10) return 'Minimaal 10 tekens';
  if (v.length > 128) return 'Maximaal 128 tekens';
  return null;
}
