import 'package:freezed_annotation/freezed_annotation.dart';
import '../enums/fuel_type.dart';

part 'vehicle.freezed.dart';
part 'vehicle.g.dart';

@freezed
abstract class Vehicle with _$Vehicle {
  const factory Vehicle({
    required String id,
    required String userId,
    required String registrationNumber,
    required String make,
    required String model,
    int? year,
    required FuelType fuelType,
    double? tankCapacityLiters,
    String? color,
    @Default(false) bool isDefault,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Vehicle;

  factory Vehicle.fromJson(Map<String, dynamic> json) =>
      _$VehicleFromJson(json);
}

@freezed
abstract class VehicleCreateRequest with _$VehicleCreateRequest {
  const factory VehicleCreateRequest({
    required String registrationNumber,
    required String make,
    required String model,
    int? year,
    required FuelType fuelType,
    double? tankCapacityLiters,
    String? color,
    @Default(false) bool isDefault,
  }) = _VehicleCreateRequest;

  factory VehicleCreateRequest.fromJson(Map<String, dynamic> json) =>
      _$VehicleCreateRequestFromJson(json);
}