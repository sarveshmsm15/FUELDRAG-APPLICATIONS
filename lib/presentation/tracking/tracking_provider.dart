import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Current driver location for active tracking.
final driverLocationProvider = StateProvider<DriverLocation?>((ref) => null);

class DriverLocation {
  final double latitude;
  final double longitude;
  final DateTime timestamp;

  const DriverLocation({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });
}

/// Order status updates stream.
final orderStatusProvider = StateProvider<String?>((ref) => null);

/// Notifications list.
final notificationsProvider = StateProvider<List<Map<String, dynamic>>>((ref) => []);

/// Chat messages for current chat.
final chatMessagesProvider = StateProvider<List<Map<String, dynamic>>>((ref) => []);