import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../config/app_config.dart';
import '../theme/app_theme.dart';
import 'brand.dart';

class _Destination {
  const _Destination(this.path, this.label, this.icon, this.selectedIcon);

  final String path;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

const _destinations = [
  _Destination('/', 'Dashboard', Icons.space_dashboard_outlined, Icons.space_dashboard),
  _Destination('/collection', 'Collectie', Icons.style_outlined, Icons.style),
  _Destination('/search', 'Zoeken', Icons.search, Icons.search),
  _Destination('/analysis', 'Analyse', Icons.insights_outlined, Icons.insights),
  _Destination('/transactions', 'Transacties', Icons.receipt_long_outlined, Icons.receipt_long),
  _Destination('/profile', 'Profiel', Icons.person_outline, Icons.person),
];

/// Responsive navigation: bottom bar on phones, rail on tablets, extended rail on desktop.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.location, required this.child});

  final String location;
  final Widget child;

  int get _index {
    final i = _destinations.lastIndexWhere((d) => d.path == '/' ? location == '/' : location.startsWith(d.path));
    return i < 0 ? 0 : i;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    void go(int i) => context.go(_destinations[i].path);
    if (width < 700) {
      return Scaffold(
        body: SafeArea(bottom: false, child: child),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: go,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          destinations: [
            for (final d in _destinations)
              NavigationDestination(icon: Icon(d.icon), selectedIcon: Icon(d.selectedIcon), label: d.label),
          ],
        ),
      );
    }
    final extended = width >= 1100;
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            NavigationRail(
              extended: extended,
              selectedIndex: _index,
              onDestinationSelected: go,
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: extended ? const PokeFolioWordmark(fontSize: 20) : const PokeFolioMark(size: 36),
              ),
              trailing: AppConfig.useMockData && extended
                  ? const Padding(
                      padding: EdgeInsets.only(top: 24),
                      child: Text('Demo-modus', style: TextStyle(color: PokeFolioColors.electric, fontSize: 12)),
                    )
                  : null,
              destinations: [
                for (final d in _destinations)
                  NavigationRailDestination(
                    icon: Icon(d.icon),
                    selectedIcon: Icon(d.selectedIcon),
                    label: Text(d.label),
                  ),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
