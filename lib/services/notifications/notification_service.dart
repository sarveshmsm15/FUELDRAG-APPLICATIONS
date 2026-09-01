import 'dart:ui';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _plugin.initialize(settings: settings);

    await _plugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    _initialized = true;
  }

  static Future<void> show({
    required String title,
    required String body,
    int id = 0,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'fuelrush_channel',
      'FuelRush Notifications',
      channelDescription: 'Order updates, promotions, and alerts',
      importance: Importance.high,
      priority: Priority.high,
      color: Color(0xFFFF6B35),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _plugin.show(id: id, title: title, body: body, notificationDetails: details, payload: payload);
  }

  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}

final notificationServiceProvider = Provider<NotificationService>((ref) => NotificationService());

final appNotificationsProvider = NotifierProvider<AppNotificationsNotifier, List<AppNotification>>(
  AppNotificationsNotifier.new,
);

class AppNotification {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  final bool isRead;
  final String? type;

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    this.isRead = false,
    this.type,
  });

  AppNotification copyWith({bool? isRead}) => AppNotification(
    id: id, title: title, body: body, timestamp: timestamp,
    isRead: isRead ?? this.isRead, type: type,
  );
}

class AppNotificationsNotifier extends Notifier<List<AppNotification>> {
  @override
  List<AppNotification> build() => [];

  void add(AppNotification notification) {
    state = [notification, ...state];
  }

  void markRead(String id) {
    state = state.map((n) => n.id == id ? n.copyWith(isRead: true) : n).toList();
  }

  void markAllRead() {
    state = state.map((n) => n.copyWith(isRead: true)).toList();
  }

  void clear() {
    state = [];
  }

  int get unreadCount => state.where((n) => !n.isRead).length;
}
