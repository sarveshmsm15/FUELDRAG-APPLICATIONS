import 'package:freezed_annotation/freezed_annotation.dart';
import '../enums/notification_priority.dart';

part 'notification.freezed.dart';
part 'notification.g.dart';

@freezed
abstract class AppNotification with _$AppNotification {
  const factory AppNotification({
    required String id,
    required String userId,
    required String title,
    required String body,
    @Default(NotificationPriority.normal) NotificationPriority priority,
    Map<String, dynamic>? data,
    @Default(false) bool isRead,
    DateTime? readAt,
    String? fcmMessageId,
    required DateTime createdAt,
  }) = _AppNotification;

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(json);
}