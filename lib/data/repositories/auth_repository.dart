import 'package:dio/dio.dart';

import '../../core/constants/env_config.dart';
import '../../services/api/dio_client.dart';
import '../../services/local/secure_storage.dart';

/// Result wrapper for auth operations.
class AuthResult {
  const AuthResult({required this.success, required this.message, this.data});
  final bool success;
  final String message;
  final Map<String, dynamic>? data;
}

/// Auth repository — handles all auth API calls.
class AuthRepository {
  Dio get _dio => DioClient.instance;

  String get _baseUrl => '/auth';

  /// Send OTP to phone.
  Future<({bool success, String message})> sendOtp(String phone) async {
    final response = await _dio.post('$_baseUrl/send-otp', data: {'phone': phone});
    final data = response.data as Map<String, dynamic>;
    return (
      success: data['success'] == true,
      message: (data['data'] as Map?)?['message'] as String? ?? 'OTP sent',
    );
  }

  /// Verify OTP and get tokens.
  Future<AuthResult> verifyOtp(String phone, String otp) async {
    final response = await _dio.post('$_baseUrl/verify-otp', data: {'phone': phone, 'otp': otp});
    final data = response.data as Map<String, dynamic>;
    final responseData = data['data'] as Map<String, dynamic>;

    // Save tokens
    await SecureStorage.saveTokens(
      accessToken: responseData['accessToken'] as String,
      refreshToken: responseData['refreshToken'] as String,
    );

    return AuthResult(success: true, message: 'Login successful', data: responseData);
  }

  /// Refresh tokens.
  Future<({String accessToken, String refreshToken})?> refreshToken(String refreshToken) async {
    try {
      final response = await _dio.post('$_baseUrl/refresh', data: {'refreshToken': refreshToken});
      final data = (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;

      await SecureStorage.saveTokens(
        accessToken: data['accessToken'] as String,
        refreshToken: data['refreshToken'] as String,
      );

      return (
        accessToken: data['accessToken'] as String,
        refreshToken: data['refreshToken'] as String,
      );
    } catch (_) {
      return null;
    }
  }

  /// Get current user profile.
  Future<Map<String, dynamic>?> getProfile(String token) async {
    try {
      final response = await _dio.get('$_baseUrl/me',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>?;
    } catch (_) {
      return null;
    }
  }

  /// Update profile.
  Future<void> updateProfile({String? name, String? email}) async {
    await _dio.put('$_baseUrl/profile', data: {
      if (name != null) 'name': name,
      if (email != null) 'email': email,
    });
  }

  /// Setup PIN.
  Future<void> setupPin(String pin) async {
    await _dio.post('$_baseUrl/pin/setup', data: {'pin': pin});
  }

  /// Verify PIN.
  Future<bool> verifyPin(String pin) async {
    final response = await _dio.post('$_baseUrl/pin/verify', data: {'pin': pin});
    return (response.data as Map<String, dynamic>)['data']?['valid'] == true;
  }

  /// Enable biometric.
  Future<void> enableBiometric() async {
    await _dio.post('$_baseUrl/biometric/setup');
  }

  /// Logout.
  Future<void> logout() async {
    await _dio.post('$_baseUrl/logout');
  }
}