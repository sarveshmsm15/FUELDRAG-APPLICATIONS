// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DriverProfile _$DriverProfileFromJson(Map<String, dynamic> json) =>
    _DriverProfile(
      id: json['id'] as String,
      userId: json['userId'] as String,
      licenseNumber: json['licenseNumber'] as String,
      licenseExpiry: DateTime.parse(json['licenseExpiry'] as String),
      vehicleType: json['vehicleType'] as String,
      tankerCapacityLiters: (json['tankerCapacityLiters'] as num).toDouble(),
      currentLatitude: (json['currentLatitude'] as num?)?.toDouble(),
      currentLongitude: (json['currentLongitude'] as num?)?.toDouble(),
      isAvailable: json['isAvailable'] as bool? ?? true,
      isOnDelivery: json['isOnDelivery'] as bool? ?? false,
      rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
      totalDeliveries: (json['totalDeliveries'] as num?)?.toInt() ?? 0,
      kycVerified: json['kycVerified'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$DriverProfileToJson(_DriverProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'licenseNumber': instance.licenseNumber,
      'licenseExpiry': instance.licenseExpiry.toIso8601String(),
      'vehicleType': instance.vehicleType,
      'tankerCapacityLiters': instance.tankerCapacityLiters,
      'currentLatitude': instance.currentLatitude,
      'currentLongitude': instance.currentLongitude,
      'isAvailable': instance.isAvailable,
      'isOnDelivery': instance.isOnDelivery,
      'rating': instance.rating,
      'totalDeliveries': instance.totalDeliveries,
      'kycVerified': instance.kycVerified,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
