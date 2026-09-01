import 'package:json_annotation/json_annotation.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum PaymentMethod {
  @JsonValue('wallet')
  wallet,

  @JsonValue('stripe')
  stripe,

  @JsonValue('razorpay')
  razorpay,

  @JsonValue('upi')
  upi,

  @JsonValue('cash')
  cash,
}