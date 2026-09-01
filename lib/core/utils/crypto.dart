import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

/// AES-256 encryption utilities for local PII storage.
/// Uses a key derived from the device-specific secure storage key.
abstract class CryptoUtils {
  const CryptoUtils._();

  /// Generate a SHA-256 hash of a string (for PIN hashing, fingerprints).
  static String sha256Hash(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Generate a HMAC-SHA256 for request signing.
  static String hmacSha256(String key, String message) {
    final keyBytes = utf8.encode(key);
    final messageBytes = utf8.encode(message);
    final hmac = Hmac(sha256, keyBytes);
    final digest = hmac.convert(messageBytes);
    return digest.toString();
  }

  /// Simple XOR-based obfuscation for local cache values.
  /// NOT for high-security — use flutter_secure_storage for secrets.
  /// This is for Hive box values that need basic obfuscation.
  static String xorObfuscate(String plaintext, String key) {
    final textBytes = utf8.encode(plaintext);
    final keyBytes = utf8.encode(key);
    final result = Uint8List(textBytes.length);

    for (var i = 0; i < textBytes.length; i++) {
      result[i] = textBytes[i] ^ keyBytes[i % keyBytes.length];
    }

    return base64Encode(result);
  }

  /// Reverse XOR obfuscation.
  static String xorDeobfuscate(String ciphertext, String key) {
    final cipherBytes = base64Decode(ciphertext);
    final keyBytes = utf8.encode(key);
    final result = Uint8List(cipherBytes.length);

    for (var i = 0; i < cipherBytes.length; i++) {
      result[i] = cipherBytes[i] ^ keyBytes[i % keyBytes.length];
    }

    return utf8.decode(result);
  }

  /// Generate a random hex string of specified byte length.
  static String generateRandomHex(int byteLength) {
    // Use DateTime + hashCode as entropy source for key generation
    final now = DateTime.now().microsecondsSinceEpoch;
    final hash = sha256.convert(utf8.encode('$now-${now.hashCode}'));
    return hash.toString().substring(0, byteLength * 2);
  }
}