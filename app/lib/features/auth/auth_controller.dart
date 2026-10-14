import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../../domain/models.dart';

/// Signed-in account, or null when signed out. The initial build restores a stored session.
class AuthController extends AsyncNotifier<Account?> {
  @override
  Future<Account?> build() async {
    try {
      return (await ref.read(authenticationRepositoryProvider).restoreSession())?.account;
    } catch (_) {
      return null;
    }
  }

  Future<void> login(String email, String password) async {
    final session = await ref.read(authenticationRepositoryProvider).login(email, password);
    state = AsyncData(session.account);
  }

  Future<void> register(String email, String password, String displayName) async {
    final session = await ref.read(authenticationRepositoryProvider).register(email, password, displayName);
    state = AsyncData(session.account);
  }

  Future<void> logout() async {
    await ref.read(authenticationRepositoryProvider).logout();
    state = const AsyncData(null);
  }

  Future<void> updateDisplayName(String name) async {
    final account = await ref.read(authenticationRepositoryProvider).updateAccount(displayName: name);
    state = AsyncData(account);
  }

  Future<void> deleteAccount(String password) async {
    await ref.read(authenticationRepositoryProvider).deleteAccount(password);
    state = const AsyncData(null);
  }

  void sessionExpired() => state = const AsyncData(null);
}

final authControllerProvider = AsyncNotifierProvider<AuthController, Account?>(AuthController.new);
