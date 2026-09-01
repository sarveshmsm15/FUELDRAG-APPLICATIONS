import 'package:json_annotation/json_annotation.dart';

/// Payment status matching PostgreSQL enum values exactly.
@JsonEnum(fieldRename: FieldRename.snake)
enum PaymentStatus {
  @JsonValue('pending')
  pending,

  @JsonValue('processing')
  processing,

  @JsonValue('success')
  success,

  @JsonValue('failed')
  failed,

  @JsonValue('refunded')
  refunded,

  @JsonValue('partially_refunded')
  partiallyRefunded,
}