// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promo_code.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PromoCode _$PromoCodeFromJson(Map<String, dynamic> json) => _PromoCode(
  id: json['id'] as String,
  code: json['code'] as String,
  description: json['description'] as String,
  discountType: json['discountType'] as String,
  discountValue: (json['discountValue'] as num).toDouble(),
  minOrderAmount: (json['minOrderAmount'] as num?)?.toDouble() ?? 0,
  maxDiscount: (json['maxDiscount'] as num?)?.toDouble(),
  usageLimit: (json['usageLimit'] as num?)?.toInt(),
  usageCount: (json['usageCount'] as num?)?.toInt() ?? 0,
  validFrom: DateTime.parse(json['validFrom'] as String),
  validUntil: DateTime.parse(json['validUntil'] as String),
  isActive: json['isActive'] as bool? ?? true,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$PromoCodeToJson(_PromoCode instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'description': instance.description,
      'discountType': instance.discountType,
      'discountValue': instance.discountValue,
      'minOrderAmount': instance.minOrderAmount,
      'maxDiscount': instance.maxDiscount,
      'usageLimit': instance.usageLimit,
      'usageCount': instance.usageCount,
      'validFrom': instance.validFrom.toIso8601String(),
      'validUntil': instance.validUntil.toIso8601String(),
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
    };
