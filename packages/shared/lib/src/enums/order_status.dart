import 'package:json_annotation/json_annotation.dart';

/// Order status lifecycle matching PostgreSQL enum values exactly.
@JsonEnum(fieldRename: FieldRename.snake)
enum OrderStatus {
  @JsonValue('pending')
  pending,

  @JsonValue('confirmed')
  confirmed,

  @JsonValue('driver_assigned')
  driverAssigned,

  @JsonValue('driver_en_route')
  driverEnRoute,

  @JsonValue('arrived')
  arrived,

  @JsonValue('fueling')
  fueling,

  @JsonValue('completed')
  completed,

  @JsonValue('cancelled')
  cancelled,

  @JsonValue('failed')
  failed,
}