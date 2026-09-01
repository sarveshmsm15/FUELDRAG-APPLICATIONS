import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/auth_repository.dart';
import '../../services/local/secure_storage.dart';

sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  const AuthAuthenticated({
    required this.userId,
    required this.phone,
    this.name,
    this.email,
    required this.role,
    required this.isNew,
  });

  final String userId;
  final String phone;
  final String? name;
  final String? email;
  final String role;
  final bool isNew;
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  const AuthError(this.message);

  final String message;
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final authStateProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

class AuthNotifier extends Notifier<AuthState> {
  late final AuthRepository _repo;

  @override
  AuthState build() {
    _repo = ref.read(authRepositoryProvider);
    Future.microtask(_checkExistingSession);
    return const AuthInitial();
  }

  Future<void> _checkExistingSession() async {
    try {
      final token = await SecureStorage.getAccessToken();

      if (token == null) {
        state = const AuthUnauthenticated();
        return;
      }

      final profile = await _repo.getProfile(token);

      if (profile == null) {
        state = const AuthUnauthenticated();
        return;
      }

      state = AuthAuthenticated(
        userId: profile['id'] as String,
        phone: profile['phone'] as String,
        name: profile['name'] as String?,
        email: profile['email'] as String?,
        role: profile['role'] as String,
        isNew: false,
      );
    } catch (_) {
      state = const AuthUnauthenticated();
    }
  }

  /// Send OTP — does NOT change auth state to prevent router redirects.
  Future<({bool success, String message})> sendOtp(String phone) async {
    try {
      final result = await _repo.sendOtp(phone);
      return result;
    } catch (e) {
      final message = _cleanError(e);
      return (success: false, message: message);
    }
  }

  /// Verify OTP and login — changes auth state on success.
  Future<({bool success, String message})> verifyOtp(
    String phone,
    String otp,
  ) async {
    state = const AuthLoading();

    try {
      final result = await _repo.verifyOtp(phone, otp);

      if (result.success && result.data != null) {
        final data = result.data!;
        final user = data['user'] as Map<String, dynamic>;

        state = AuthAuthenticated(
          userId: user['id'] as String,
          phone: user['phone'] as String,
          name: user['name'] as String?,
          email: user['email'] as String?,
          role: user['role'] as String,
          isNew: user['isNew'] as bool,
        );
      } else {
        state = const AuthUnauthenticated();
      }

      return (success: result.success, message: result.message);
    } catch (e) {
      final message = _cleanError(e);
      state = AuthError(message);
      return (success: false, message: message);
    }
  }

  /// Update profile (name, email).
  Future<({bool success, String message})> updateProfile({
    String? name,
    String? email,
  }) async {
    try {
      await _repo.updateProfile(name: name, email: email);

      final current = state;
      if (current is AuthAuthenticated) {
        state = AuthAuthenticated(
          userId: current.userId,
          phone: current.phone,
          name: name ?? current.name,
          email: email ?? current.email,
          role: current.role,
          isNew: false,
        );
      }

      return (success: true, message: 'Profile updated');
    } catch (e) {
      return (success: false, message: _cleanError(e));
    }
  }

  /// Setup PIN.
  Future<({bool success, String message})> setupPin(String pin) async {
    try {
      await _repo.setupPin(pin);
      await SecureStorage.savePinHash(pin);
      return (success: true, message: 'PIN set successfully');
    } catch (e) {
      return (success: false, message: _cleanError(e));
    }
  }

  /// Enable biometric.
  Future<({bool success, String message})> enableBiometric() async {
    try {
      await _repo.enableBiometric();
      await SecureStorage.saveBiometricEnabled(true);
      return (success: true, message: 'Biometric enabled');
    } catch (e) {
      return (success: false, message: _cleanError(e));
    }
  }

  /// Logout.
  Future<void> logout() async {
    try {
      await _repo.logout();
    } catch (_) {}
    await SecureStorage.clearTokens();
    state = const AuthUnauthenticated();
  }

  String _cleanError(Object error) {
    final text = error.toString();
    return text.replaceFirst('Exception: ', '');
  }
}