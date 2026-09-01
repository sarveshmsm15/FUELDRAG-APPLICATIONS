import 'package:flutter_riverpod/flutter_riverpod.dart';

final driverLocationProvider = NotifierProvider<DriverLocationNotifier, DriverLocation?>(DriverLocationNotifier.new);

class DriverLocationNotifier extends Notifier<DriverLocation?> {
  @override
  DriverLocation? build() => null;
  void set(DriverLocation? loc) => state = loc;
}

class DriverLocation {
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  const DriverLocation({required this.latitude, required this.longitude, required this.timestamp});
}

final orderStatusProvider = NotifierProvider<OrderStatusNotifier, String?>(OrderStatusNotifier.new);

class OrderStatusNotifier extends Notifier<String?> {
  @override
  String? build() => null;
  void set(String? s) => state = s;
}

final notificationsProvider = NotifierProvider<NotificationsNotifier, List<Map<String, dynamic>>>(NotificationsNotifier.new);

class NotificationsNotifier extends Notifier<List<Map<String, dynamic>>> {
  @override
  List<Map<String, dynamic>> build() => [];
  void add(Map<String, dynamic> n) => state = [n, ...state];
}

final chatMessagesProvider = NotifierProvider<ChatMessagesNotifier, List<Map<String, dynamic>>>(ChatMessagesNotifier.new);

class ChatMessagesNotifier extends Notifier<List<Map<String, dynamic>>> {
  @override
  List<Map<String, dynamic>> build() => [];
  void add(Map<String, dynamic> m) => state = [...state, m];
}
