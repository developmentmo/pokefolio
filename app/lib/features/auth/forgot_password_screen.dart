import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/app_config.dart';
import '../../core/widgets/states.dart';
import '../../data/providers.dart';
import 'auth_layout.dart';

/// Two steps: request a reset code by e-mail, then set a new password with that code.
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _requestForm = GlobalKey<FormState>();
  final _resetForm = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _token = TextEditingController();
  final _password = TextEditingController();
  bool _requested = false;
  bool _busy = false;

  @override
  void dispose() {
    _email.dispose();
    _token.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _request() async {
    if (!_requestForm.currentState!.validate()) return;
    setState(() => _busy = true);
    try {
      await ref.read(authenticationRepositoryProvider).requestPasswordReset(_email.text.trim());
      if (AppConfig.useMockData) {
        _token.text = ref.read(mockBackendProvider).lastResetToken ?? '';
      }
      setState(() => _requested = true);
    } catch (e) {
      if (mounted) showError(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _reset() async {
    if (!_resetForm.currentState!.validate()) return;
    setState(() => _busy = true);
    try {
      await ref.read(authenticationRepositoryProvider).resetPassword(_token.text.trim(), _password.text);
      if (!mounted) return;
      showMessage(context, 'Je wachtwoord is gewijzigd. Log in met je nieuwe wachtwoord.');
      context.go('/login');
    } catch (e) {
      if (mounted) showError(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: 'Wachtwoord herstellen',
      subtitle: _requested
          ? 'Als er een account bij dit e-mailadres hoort, is er een herstelcode verstuurd. '
                'Vul de code en je nieuwe wachtwoord in.'
          : 'Vul je e-mailadres in. Je ontvangt een code om een nieuw wachtwoord in te stellen.',
      child: _requested ? _resetStep() : _requestStep(),
    );
  }

  Widget _requestStep() => Form(
    key: _requestForm,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: _email,
          decoration: const InputDecoration(labelText: 'E-mailadres', prefixIcon: Icon(Icons.mail_outline)),
          keyboardType: TextInputType.emailAddress,
          validator: validateEmail,
          onFieldSubmitted: (_) => _request(),
        ),
        const SizedBox(height: 24),
        FilledButton(onPressed: _busy ? null : _request, child: const Text('Herstelcode aanvragen')),
        const SizedBox(height: 12),
        TextButton(onPressed: () => context.go('/login'), child: const Text('Terug naar inloggen')),
      ],
    ),
  );

  Widget _resetStep() => Form(
    key: _resetForm,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: _token,
          decoration: const InputDecoration(labelText: 'Herstelcode', prefixIcon: Icon(Icons.key_outlined)),
          validator: (v) => v == null || v.trim().isEmpty ? 'Vul de herstelcode in' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _password,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Nieuw wachtwoord',
            helperText: 'Minimaal 10 tekens',
            prefixIcon: Icon(Icons.lock_outline),
          ),
          validator: validateNewPassword,
          onFieldSubmitted: (_) => _reset(),
        ),
        const SizedBox(height: 24),
        FilledButton(onPressed: _busy ? null : _reset, child: const Text('Wachtwoord opslaan')),
        const SizedBox(height: 12),
        TextButton(onPressed: () => setState(() => _requested = false), child: const Text('Andere e-mail gebruiken')),
      ],
    ),
  );
}
