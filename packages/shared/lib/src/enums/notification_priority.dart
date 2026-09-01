import 'package:json_annotation/json_annotation.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum NotificationPriority {
  @JsonValue('low')
  low,

  @JsonValue('normal')
  normal,

  @JsonValue('high')
  high,

  @JsonValue('critical')
  critical,
}