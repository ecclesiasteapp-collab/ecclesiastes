import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecclesiaste/services/auth_service.dart';

enum AuthState {
  loading,
  authenticated,
  unauthenticated,
}

class AuthStateNotifier extends StateNotifier<AuthState> {
  AuthStateNotifier() : super(AuthState.loading) {
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    // Simule un délai pour l'initialisation si nécessaire, ou supprimez-le
    // await Future.delayed(const Duration(seconds: 1)); 

    // Tente de restaurer la session
    await AuthService.restoreSession(); // Assurez-vous que cette méthode existe et met à jour AuthService.currentUser

    if (AuthService.currentUser != null) {
      state = AuthState.authenticated;
    } else {
      state = AuthState.unauthenticated;
    }
  }

  void login() {
    state = AuthState.authenticated;
  }

  void logout() {
    state = AuthState.unauthenticated;
  }
}

final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>(
  (ref) => AuthStateNotifier(),
);
