import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/app_config.dart';
import '../../core/format/formatters.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/brand.dart';
import '../../core/widgets/states.dart';
import '../../data/providers.dart';
import '../auth/auth_controller.dart';
import '../auth/auth_layout.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(authControllerProvider).value;
    if (account == null) return const Scaffold(body: LoadingView());
    return Scaffold(
      appBar: AppBar(title: const Text('Profiel en instellingen')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          PageBody(
            maxWidth: 720,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      radius: 26,
                      backgroundColor: PokeFolioColors.violet,
                      child: Text(
                        account.displayName.characters.first.toUpperCase(),
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ),
                    title: Text(account.displayName, style: Theme.of(context).textTheme.titleLarge),
                    subtitle: Text('${account.email}\nLid sinds ${Fmt.date(account.createdAt)}'),
                    isThreeLine: true,
                  ),
                ),
                const SectionTitle('Account'),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.badge_outlined),
                        title: const Text('Weergavenaam wijzigen'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _editName(context, ref, account.displayName),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.lock_outline),
                        title: const Text('Wachtwoord wijzigen'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _changePassword(context, ref),
                      ),
                      const Divider(height: 1),
                      const ListTile(leading: Icon(Icons.euro), title: Text('Valuta'), trailing: Text('EUR')),
                    ],
                  ),
                ),
                const SectionTitle('Gegevens'),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.storage_outlined),
                        title: const Text('Gegevensbron'),
                        subtitle: Text(
                          AppConfig.useMockData
                              ? 'Demo-modus: lokale voorbeelddata, niets wordt opgeslagen op een server.'
                              : 'PokeFolio-server: ${AppConfig.apiBaseUrl}',
                        ),
                      ),
                      const Divider(height: 1),
                      const ListTile(
                        leading: Icon(Icons.price_change_outlined),
                        title: Text('Marktprijzen'),
                        subtitle: Text(
                          'In deze versie zijn alle prijzen voorbeeldgegevens. De koppeling met een echte '
                          'prijsbron volgt zodra die is geverifieerd.',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                OutlinedButton.icon(
                  key: const Key('logout'),
                  onPressed: () => ref.read(authControllerProvider.notifier).logout(),
                  icon: const Icon(Icons.logout),
                  label: const Text('Uitloggen'),
                ),
                const SizedBox(height: 12),
                TextButton.icon(
                  style: TextButton.styleFrom(foregroundColor: PokeFolioColors.loss),
                  onPressed: () => _deleteAccount(context, ref),
                  icon: const Icon(Icons.delete_forever_outlined),
                  label: const Text('Account verwijderen'),
                ),
                const SizedBox(height: 32),
                const Center(child: PokeFolioWordmark(fontSize: 16)),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'PokeFolio is een onafhankelijke app en niet verbonden aan Nintendo, Creatures of The Pokémon Company.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: PokeFolioColors.textSecondary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _editName(BuildContext context, WidgetRef ref, String current) async {
    final controller = TextEditingController(text: current);
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Weergavenaam'),
        content: TextField(controller: controller, autofocus: true, maxLength: 80),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuleren')),
          FilledButton(onPressed: () => Navigator.pop(context, controller.text.trim()), child: const Text('Opslaan')),
        ],
      ),
    );
    controller.dispose();
    if (name == null || name.isEmpty) return;
    try {
      await ref.read(authControllerProvider.notifier).updateDisplayName(name);
      if (context.mounted) showMessage(context, 'Naam bijgewerkt');
    } catch (e) {
      if (context.mounted) showError(context, e);
    }
  }

  Future<void> _changePassword(BuildContext context, WidgetRef ref) async {
    final form = GlobalKey<FormState>();
    final current = TextEditingController();
    final next = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Wachtwoord wijzigen'),
        content: Form(
          key: form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: current,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Huidig wachtwoord'),
                validator: (v) => v == null || v.isEmpty ? 'Verplicht' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: next,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Nieuw wachtwoord', helperText: 'Minimaal 10 tekens'),
                validator: validateNewPassword,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuleren')),
          FilledButton(
            onPressed: () {
              if (form.currentState!.validate()) Navigator.pop(context, true);
            },
            child: const Text('Wijzigen'),
          ),
        ],
      ),
    );
    if (ok == true) {
      try {
        await ref.read(authenticationRepositoryProvider).changePassword(current.text, next.text);
        if (context.mounted) showMessage(context, 'Wachtwoord gewijzigd');
      } catch (e) {
        if (context.mounted) showError(context, e);
      }
    }
    current.dispose();
    next.dispose();
  }

  Future<void> _deleteAccount(BuildContext context, WidgetRef ref) async {
    final password = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Account verwijderen?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Je account, collectie en transactiehistorie worden definitief verwijderd. '
              'Dit kan niet ongedaan worden gemaakt.',
            ),
            const SizedBox(height: 12),
            TextField(
              controller: password,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Bevestig met je wachtwoord'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuleren')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: PokeFolioColors.loss),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Definitief verwijderen'),
          ),
        ],
      ),
    );
    if (ok == true) {
      try {
        await ref.read(authControllerProvider.notifier).deleteAccount(password.text);
      } catch (e) {
        if (context.mounted) showError(context, e);
      }
    }
    password.dispose();
  }
}
