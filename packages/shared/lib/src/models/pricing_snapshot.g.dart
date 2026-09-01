// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pricing_snapshot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PricingSnapshot _$PricingSnapshotFromJson(Map<String, dynamic> json) =>
    _PricingSnapshot(
      id: json['id'] as String,
      orderId: json['orderId'] as String?,
      fuelType: $enumDecode(_$FuelTypeEnumMap, json['fuelType']),
      basePrice: (json['basePrice'] as num).toDouble(),
      surgeMultiplier: (json['surgeMultiplier'] as num?)?.toDouble() ?? 1.0,
      deliveryFee: (json['deliveryFee'] as num).toDouble(),
      taxAmount: (json['taxAmount'] as num).toDouble(),
      discountAmount: (json['discountAmount'] as num?)?.toDouble() ?? 0,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      quantityLiters: (json['quantityLiters'] as num).toDouble(),
      priceLockedAt: DateTime.parse(json['priceLockedAt'] as String),
      priceExpiresAt: DateTime.parse(json['priceExpiresAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$PricingSnapshotToJson(_PricingSnapshot instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderId': instance.orderId,
      'fuelType': _$FuelTypeEnumMap[instance.fuelType]!,
      'basePrice': instance.basePrice,
      'surgeMultiplier': instance.surgeMultiplier,
      'deliveryFee': instance.deliveryFee,
      'taxAmount': instance.taxAmount,
      'discountAmount': instance.discountAmount,
      'totalAmount': instance.totalAmount,
      'quantityLiters': instance.quantityLiters,
      'priceLockedAt': instance.priceLockedAt.toIso8601String(),
      'priceExpiresAt': instance.priceExpiresAt.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$FuelTypeEnumMap = {
  FuelType.petrol: 'petrol',
  FuelType.diesel: 'diesel',
  FuelType.cng: 'cng',
  FuelType.evCharge: 'ev_charge',
};

_PricingCalculateRequest _$PricingCalculateRequestFromJson(
  Map<String, dynamic> json,
) => _PricingCalculateRequest(
  fuelType: $enumDecode(_$FuelTypeEnumMap, json['fuelType']),
  quantityLiters: (json['quantityLiters'] as num).toDouble(),
  distanceKm: (json['distanceKm'] as num).toDouble(),
  promoCode: json['promoCode'] as String?,
);

Map<String, dynamic> _$PricingCalculateRequestToJson(
  _PricingCalculateRequest instance,
) => <String, dynamic>{
  'fuelType': _$FuelTypeEnumMap[instance.fuelType]!,
  'quantityLiters': instance.quantityLiters,
  'distanceKm': instance.distanceKm,
  'promoCode': instance.promoCode,
};
