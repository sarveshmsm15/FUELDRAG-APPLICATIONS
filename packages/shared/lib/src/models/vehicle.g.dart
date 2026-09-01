// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Vehicle _$VehicleFromJson(Map<String, dynamic> json) => _Vehicle(
  id: json['id'] as String,
  userId: json['userId'] as String,
  registrationNumber: json['registrationNumber'] as String,
  make: json['make'] as String,
  model: json['model'] as String,
  year: (json['year'] as num?)?.toInt(),
  fuelType: $enumDecode(_$FuelTypeEnumMap, json['fuelType']),
  tankCapacityLiters: (json['tankCapacityLiters'] as num?)?.toDouble(),
  color: json['color'] as String?,
  isDefault: json['isDefault'] as bool? ?? false,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$VehicleToJson(_Vehicle instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'registrationNumber': instance.registrationNumber,
  'make': instance.make,
  'model': instance.model,
  'year': instance.year,
  'fuelType': _$FuelTypeEnumMap[instance.fuelType]!,
  'tankCapacityLiters': instance.tankCapacityLiters,
  'color': instance.color,
  'isDefault': instance.isDefault,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

const _$FuelTypeEnumMap = {
  FuelType.petrol: 'petrol',
  FuelType.diesel: 'diesel',
  FuelType.cng: 'cng',
  FuelType.evCharge: 'ev_charge',
};

_VehicleCreateRequest _$VehicleCreateRequestFromJson(
  Map<String, dynamic> json,
) => _VehicleCreateRequest(
  registrationNumber: json['registrationNumber'] as String,
  make: json['make'] as String,
  model: json['model'] as String,
  year: (json['year'] as num?)?.toInt(),
  fuelType: $enumDecode(_$FuelTypeEnumMap, json['fuelType']),
  tankCapacityLiters: (json['tankCapacityLiters'] as num?)?.toDouble(),
  color: json['color'] as String?,
  isDefault: json['isDefault'] as bool? ?? false,
);

Map<String, dynamic> _$VehicleCreateRequestToJson(
  _VehicleCreateRequest instance,
) => <String, dynamic>{
  'registrationNumber': instance.registrationNumber,
  'make': instance.make,
  'model': instance.model,
  'year': instance.year,
  'fuelType': _$FuelTypeEnumMap[instance.fuelType]!,
  'tankCapacityLiters': instance.tankCapacityLiters,
  'color': instance.color,
  'isDefault': instance.isDefault,
};
