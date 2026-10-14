import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/states.dart';
import 'auth_controller.dart';
import 'auth_layout.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    for (final c in [_name, _email, _password, _confirm]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _busy = true);
    try {
      await ref.read(authControllerProvider.notifier).register(_email.text.trim(), _password.text, _name.text.trim());
    } catch (e) {
      if (mounted) showError(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: 'Maak je PokeFolio-account',
      subtitle: 'Start met het bijhouden van je collectie en de waarde ervan.',
      child: Form(
        key: _form,
        child: AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                key: const Key('register-name'),
                controller: _name,
                decoration: const InputDecoration(labelText: 'Weergavenaam', prefixIcon: Icon(Icons.badge_outlined)),
                autofillHints: const [AutofillHints.nickname],
                textInputAction: TextInputAction.next,
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'Vul een naam in'
                    : (v.trim().length > 80 ? 'Maximaal 80 tekens' : null),
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('register-email'),
                controller: _email,
                decoration: const InputDecoration(labelText: 'E-mailadres', prefixIcon: Icon(Icons.mail_outline)),
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                textInputAction: TextInputAction.next,
                validator: validateEmail,
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('register-password'),
                controller: _password,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Wachtwoord',
                  helperText: 'Minimaal 10 tekens',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                autofillHints: const [AutofillHints.newPassword],
                textInputAction: TextInputAction.next,
                validator: validateNewPassword,
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('register-confirm'),
                controller: _confirm,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Herhaal wachtwoord',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                onFieldSubmitted: (_) => _submit(),
                validator: (v) => v != _password.text ? 'Wachtwoorden komen niet overeen' : null,
              ),
              const SizedBox(height: 24),
              FilledButton(
                key: const Key('register-submit'),
                onPressed: _busy ? null : _submit,
                child: _busy
                    ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Account aanmaken'),
              ),
              const SizedBox(height: 16),
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Text('Al een account?'),
                  TextButton(onPressed: () => context.go('/login'), child: const Text('Inloggen')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
