// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fuel_rate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FuelRate _$FuelRateFromJson(Map<String, dynamic> json) => _FuelRate(
  id: json['id'] as String,
  fuelType: $enumDecode(_$FuelTypeEnumMap, json['fuelType']),
  pricePerLiter: (json['pricePerLiter'] as num).toDouble(),
  effectiveFrom: DateTime.parse(json['effectiveFrom'] as String),
  effectiveTo: json['effectiveTo'] == null
      ? null
      : DateTime.parse(json['effectiveTo'] as String),
  region: json['region'] as String? ?? 'default',
  isActive: json['isActive'] as bool? ?? true,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$FuelRateToJson(_FuelRate instance) => <String, dynamic>{
  'id': instance.id,
  'fuelType': _$FuelTypeEnumMap[instance.fuelType]!,
  'pricePerLiter': instance.pricePerLiter,
  'effectiveFrom': instance.effectiveFrom.toIso8601String(),
  'effectiveTo': instance.effectiveTo?.toIso8601String(),
  'region': instance.region,
  'isActive': instance.isActive,
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$FuelTypeEnumMap = {
  FuelType.petrol: 'petrol',
  FuelType.diesel: 'diesel',
  FuelType.cng: 'cng',
  FuelType.evCharge: 'ev_charge',
};
