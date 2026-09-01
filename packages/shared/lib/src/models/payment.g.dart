// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Payment _$PaymentFromJson(Map<String, dynamic> json) => _Payment(
  id: json['id'] as String,
  orderId: json['orderId'] as String,
  userId: json['userId'] as String,
  method: $enumDecode(_$PaymentMethodEnumMap, json['method']),
  status:
      $enumDecodeNullable(_$PaymentStatusEnumMap, json['status']) ??
      PaymentStatus.pending,
  amount: (json['amount'] as num).toDouble(),
  currency: json['currency'] as String? ?? 'INR',
  gatewayTxnId: json['gatewayTxnId'] as String?,
  gatewayResponse: json['gatewayResponse'] as Map<String, dynamic>?,
  idempotencyKey: json['idempotencyKey'] as String,
  failureReason: json['failureReason'] as String?,
  initiatedAt: DateTime.parse(json['initiatedAt'] as String),
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
  refundedAt: json['refundedAt'] == null
      ? null
      : DateTime.parse(json['refundedAt'] as String),
  refundAmount: (json['refundAmount'] as num?)?.toDouble(),
);

Map<String, dynamic> _$PaymentToJson(_Payment instance) => <String, dynamic>{
  'id': instance.id,
  'orderId': instance.orderId,
  'userId': instance.userId,
  'method': _$PaymentMethodEnumMap[instance.method]!,
  'status': _$PaymentStatusEnumMap[instance.status]!,
  'amount': instance.amount,
  'currency': instance.currency,
  'gatewayTxnId': instance.gatewayTxnId,
  'gatewayResponse': instance.gatewayResponse,
  'idempotencyKey': instance.idempotencyKey,
  'failureReason': instance.failureReason,
  'initiatedAt': instance.initiatedAt.toIso8601String(),
  'completedAt': instance.completedAt?.toIso8601String(),
  'refundedAt': instance.refundedAt?.toIso8601String(),
  'refundAmount': instance.refundAmount,
};

const _$PaymentMethodEnumMap = {
  PaymentMethod.wallet: 'wallet',
  PaymentMethod.stripe: 'stripe',
  PaymentMethod.razorpay: 'razorpay',
  PaymentMethod.upi: 'upi',
  PaymentMethod.cash: 'cash',
};

const _$PaymentStatusEnumMap = {
  PaymentStatus.pending: 'pending',
  PaymentStatus.processing: 'processing',
  PaymentStatus.success: 'success',
  PaymentStatus.failed: 'failed',
  PaymentStatus.refunded: 'refunded',
  PaymentStatus.partiallyRefunded: 'partially_refunded',
};

_PaymentInitiateRequest _$PaymentInitiateRequestFromJson(
  Map<String, dynamic> json,
) => _PaymentInitiateRequest(
  orderId: json['orderId'] as String,
  method: $enumDecode(_$PaymentMethodEnumMap, json['method']),
  amount: (json['amount'] as num).toDouble(),
  idempotencyKey: json['idempotencyKey'] as String,
);

Map<String, dynamic> _$PaymentInitiateRequestToJson(
  _PaymentInitiateRequest instance,
) => <String, dynamic>{
  'orderId': instance.orderId,
  'method': _$PaymentMethodEnumMap[instance.method]!,
  'amount': instance.amount,
  'idempotencyKey': instance.idempotencyKey,
};
