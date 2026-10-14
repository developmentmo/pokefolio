import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/app_config.dart';
import 'core/theme/app_theme.dart';
import 'router.dart';

class PokeFolioApp extends ConsumerWidget {
  const PokeFolioApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: buildPokeFolioTheme(),
      darkTheme: buildPokeFolioTheme(),
      themeMode: ThemeMode.dark,
      locale: const Locale('nl', 'NL'),
      supportedLocales: const [Locale('nl', 'NL'), Locale('en')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      routerConfig: ref.watch(routerProvider),
    );
  }
}
