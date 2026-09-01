import 'dart:convert';
import 'dart:typed_data';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:crypto/crypto.dart';

import 'secure_storage.dart';

/// Hive service with AES-256 encryption for sensitive boxes.
/// Encryption key stored in flutter_secure_storage (Keychain/Keystore).
class HiveService {
  const HiveService._();

  // Box names
  static const userBox = 'user_box';
  static const settingsBox = 'settings_box';
  static const cacheBox = 'cache_box';
  static const fuelRatesBox = 'fuel_rates_box';

  static bool _initialized = false;

  /// Initialize Hive with encryption support.
  /// Must be called once at app startup after Hive.initFlutter().
  static Future<void> initialize() async {
    if (_initialized) return;

    // Register adapters here as needed in later phases

    // Get or generate encryption key
    var encryptionKey = await SecureStorage.getHiveEncryptionKey();
    if (encryptionKey == null) {
      // Generate a new 256-bit key
      final keyBytes = _generateEncryptionKey();
      encryptionKey = base64Encode(keyBytes);
      await SecureStorage.saveHiveEncryptionKey(encryptionKey);
    }

    final keyBytes = base64Decode(encryptionKey);
    final cipher = HiveAesCipher(keyBytes);

    // Open boxes — sensitive ones encrypted, cache unencrypted
    await Hive.openBox(userBox, encryptionCipher: cipher);
    await Hive.openBox(settingsBox, encryptionCipher: cipher);
    await Hive.openBox(cacheBox); // Cache doesn't need encryption
    await Hive.openBox(fuelRatesBox); // Public data, no encryption

    _initialized = true;
  }

  /// Generate a 32-byte AES-256 encryption key.
  static Uint8List _generateEncryptionKey() {
    final now = DateTime.now().microsecondsSinceEpoch;
    final hash = sha256.convert(utf8.encode('fuelrush-hive-key-$now'));
    return Uint8List.fromList(hash.bytes);
  }

  // ── User Box Operations ──
  static Box<dynamic> getUserBox() => Hive.box(userBox);

  static Future<void> saveUserProfile(Map<String, dynamic> profile) async {
    await getUserBox().put('profile', profile);
  }

  static Map<String, dynamic>? getUserProfile() {
    final data = getUserBox().get('profile');
    return data is Map<String, dynamic> ? data : null;
  }

  static Future<void> clearUserProfile() async {
    await getUserBox().delete('profile');
  }

  // ── Settings Box Operations ──
  static Box<dynamic> getSettingsBox() => Hive.box(settingsBox);

  static Future<void> saveSetting(String key, dynamic value) async {
    await getSettingsBox().put(key, value);
  }

  static T? getSetting<T>(String key) {
    return getSettingsBox().get(key) as T?;
  }

  // ── Cache Box Operations ──
  static Box<dynamic> getCacheBox() => Hive.box(cacheBox);

  static Future<void> cacheData(String key, dynamic data, {Duration? ttl}) async {
    await getCacheBox().put(key, {
      'data': data,
      'cached_at': DateTime.now().toIso8601String(),
      'ttl_seconds': ttl?.inSeconds,
    });
  }

  static dynamic getCachedData(String key) {
    final entry = getCacheBox().get(key);
    if (entry is! Map) return null;

    final ttlSeconds = entry['ttl_seconds'] as int?;
    if (ttlSeconds != null) {
      final cachedAt = DateTime.parse(entry['cached_at'] as String);
      final expiry = cachedAt.add(Duration(seconds: ttlSeconds));
      if (DateTime.now().isAfter(expiry)) {
        getCacheBox().delete(key);
        return null; // Expired
      }
    }

    return entry['data'];
  }

  static Future<void> clearCache() async {
    await getCacheBox().clear();
  }

  // ── Fuel Rates Box ──
  static Box<dynamic> getFuelRatesBox() => Hive.box(fuelRatesBox);

  static Future<void> cacheFuelRates(List<Map<String, dynamic>> rates) async {
    await getFuelRatesBox().put('rates', rates);
    await getFuelRatesBox().put(
      'cached_at',
      DateTime.now().toIso8601String(),
    );
  }

  static List<Map<String, dynamic>>? getCachedFuelRates() {
    final data = getFuelRatesBox().get('rates');
    if (data is! List) return null;

    // Check if cache is less than 5 minutes old
    final cachedAtStr = getFuelRatesBox().get('cached_at') as String?;
    if (cachedAtStr != null) {
      final cachedAt = DateTime.parse(cachedAtStr);
      if (DateTime.now().difference(cachedAt).inMinutes > 5) {
        return null; // Stale
      }
    }

    return data.cast<Map<String, dynamic>>();
  }

  // ── Cleanup ──
  static Future<void> clearAll() async {
    await getUserBox().clear();
    await getSettingsBox().clear();
    await getCacheBox().clear();
    await getFuelRatesBox().clear();
  }

  static Future<void> close() async {
    await Hive.close();
    _initialized = false;
  }
}