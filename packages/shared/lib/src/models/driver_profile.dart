import 'package:freezed_annotation/freezed_annotation.dart';

part 'driver_profile.freezed.dart';
part 'driver_profile.g.dart';

@freezed
abstract class DriverProfile with _$DriverProfile {
  const factory DriverProfile({
    required String id,
    required String userId,
    required String licenseNumber,
    required DateTime licenseExpiry,
    required String vehicleType,
    required double tankerCapacityLiters,
    double? currentLatitude,
    double? currentLongitude,
    @Default(true) bool isAvailable,
    @Default(false) bool isOnDelivery,
    @Default(5.0) double rating,
    @Default(0) int totalDeliveries,
    @Default(false) bool kycVerified,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _DriverProfile;

  factory DriverProfile.fromJson(Map<String, dynamic> json) =>
      _$DriverProfileFromJson(json);
}