import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:convert';

/// Device fingerprint generator for device binding.
/// Combines device info + app info into a stable hash.
class DeviceFingerprint {
  const DeviceFingerprint._();

  static String? _cachedFingerprint;

  /// Generate a stable device fingerprint.
  /// Cached after first generation for consistency.
  static Future<String> generate() async {
    if (_cachedFingerprint != null) return _cachedFingerprint!;

    final deviceInfo = DeviceInfoPlugin();
    final packageInfo = await PackageInfo.fromPlatform();

    final components = <String>[
      packageInfo.packageName,
      packageInfo.version,
      packageInfo.buildNumber,
    ];

    // Platform-specific identifiers
    try {
      final iosInfo = await deviceInfo.iosInfo;
      components.addAll([
        iosInfo.identifierForVendor ?? '',
        iosInfo.model,
        iosInfo.systemVersion,
        'ios',
      ]);
    } catch (_) {
      try {
        final androidInfo = await deviceInfo.androidInfo;
        components.addAll([
          androidInfo.id,
          androidInfo.model,
          androidInfo.version.release,
          androidInfo.brand,
          'android',
        ]);
      } catch (_) {
        components.add('unknown_platform');
      }
    }

    final raw = components.join('|');
    final digest = sha256.convert(utf8.encode(raw));
    _cachedFingerprint = digest.toString().substring(0, 32);

    return _cachedFingerprint!;
  }

  /// Get device headers for API requests.
  static Future<Map<String, String>> getDeviceHeaders() async {
    final fingerprint = await generate();
    final packageInfo = await PackageInfo.fromPlatform();
    final deviceInfo = DeviceInfoPlugin();

    String osVersion = 'unknown';
    String deviceModel = 'unknown';
    String deviceBrand = 'unknown';

    try {
      final iosInfo = await deviceInfo.iosInfo;
      osVersion = iosInfo.systemVersion;
      deviceModel = iosInfo.model;
      deviceBrand = 'Apple';
    } catch (_) {
      try {
        final androidInfo = await deviceInfo.androidInfo;
        osVersion = androidInfo.version.release;
        deviceModel = androidInfo.model;
        deviceBrand = androidInfo.brand;
      } catch (_) {}
    }

    return {
      'X-Device-Fingerprint': fingerprint,
      'X-Device-Id': fingerprint,
      'X-Device-Brand': deviceBrand,
      'X-Device-Model': deviceModel,
      'X-OS-Version': osVersion,
      'X-App-Version': packageInfo.version,
    };
  }
}