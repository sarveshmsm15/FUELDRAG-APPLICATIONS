import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Wrapper around flutter_secure_storage.
/// iOS: Keychain | Android: EncryptedSharedPreferences / Keystore
class SecureStorage {
  const SecureStorage._();

  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(),
    iOptions: IOSOptions(
      accountName: 'com.fuelrush.app.secure',
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );
  // ── Key Constants ──
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _pinHashKey = 'pin_hash';
  static const _themePrefKey = 'theme_preference';
  static const _deviceIdKey = 'device_id';
  static const _biometricEnabledKey = 'biometric_enabled';
  static const _hiveEncryptionKey = 'hive_encryption_key';

  // ── Token Management ──
  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  static Future<String?> getAccessToken() =>
      _storage.read(key: _accessTokenKey);

  static Future<String?> getRefreshToken() =>
      _storage.read(key: _refreshTokenKey);

  static Future<void> clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }

  // ── PIN ──
  static Future<void> savePinHash(String hash) =>
      _storage.write(key: _pinHashKey, value: hash);

  static Future<String?> getPinHash() =>
      _storage.read(key: _pinHashKey);

  static Future<void> clearPinHash() =>
      _storage.delete(key: _pinHashKey);

  // ── Theme Preference ──
  static Future<void> saveThemePreference(String theme) =>
      _storage.write(key: _themePrefKey, value: theme);

  static Future<String?> getThemePreference() =>
      _storage.read(key: _themePrefKey);

  // ── Device ID ──
  static Future<void> saveDeviceId(String id) =>
      _storage.write(key: _deviceIdKey, value: id);

  static Future<String?> getDeviceId() =>
      _storage.read(key: _deviceIdKey);

  // ── Biometric ──
  static Future<void> saveBiometricEnabled(bool enabled) =>
      _storage.write(key: _biometricEnabledKey, value: enabled.toString());

  static Future<bool> isBiometricEnabled() async {
    final value = await _storage.read(key: _biometricEnabledKey);
    return value == 'true';
  }

  // ── Hive Encryption Key ──
  static Future<void> saveHiveEncryptionKey(String key) =>
      _storage.write(key: _hiveEncryptionKey, value: key);

  static Future<String?> getHiveEncryptionKey() =>
      _storage.read(key: _hiveEncryptionKey);

  // ── Utility ──
  static Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  static Future<String?> read(String key) =>
      _storage.read(key: key);

  static Future<void> delete(String key) =>
      _storage.delete(key: key);

  /// Clear ALL secure storage (nuclear option — full logout).
  static Future<void> clearAll() => _storage.deleteAll();
}