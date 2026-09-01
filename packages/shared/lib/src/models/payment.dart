import 'package:freezed_annotation/freezed_annotation.dart';
import '../enums/payment_method.dart';
import '../enums/payment_status.dart';

part 'payment.freezed.dart';
part 'payment.g.dart';

@freezed
abstract class Payment with _$Payment {
  const factory Payment({
    required String id,
    required String orderId,
    required String userId,
    required PaymentMethod method,
    @Default(PaymentStatus.pending) PaymentStatus status,
    required double amount,
    @Default('INR') String currency,
    String? gatewayTxnId,
    Map<String, dynamic>? gatewayResponse,
    required String idempotencyKey,
    String? failureReason,
    required DateTime initiatedAt,
    DateTime? completedAt,
    DateTime? refundedAt,
    double? refundAmount,
  }) = _Payment;

  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);
}

@freezed
abstract class PaymentInitiateRequest with _$PaymentInitiateRequest {
  const factory PaymentInitiateRequest({
    required String orderId,
    required PaymentMethod method,
    required double amount,
    required String idempotencyKey,
  }) = _PaymentInitiateRequest;

  factory PaymentInitiateRequest.fromJson(Map<String, dynamic> json) =>
      _$PaymentInitiateRequestFromJson(json);
}