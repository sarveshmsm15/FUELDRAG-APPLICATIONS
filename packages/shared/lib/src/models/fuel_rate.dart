import 'package:freezed_annotation/freezed_annotation.dart';
import '../enums/fuel_type.dart';

part 'fuel_rate.freezed.dart';
part 'fuel_rate.g.dart';

@freezed
abstract class FuelRate with _$FuelRate {
  const factory FuelRate({
    required String id,
    required FuelType fuelType,
    required double pricePerLiter,
    required DateTime effectiveFrom,
    DateTime? effectiveTo,
    @Default('default') String region,
    @Default(true) bool isActive,
    required DateTime createdAt,
  }) = _FuelRate;

  factory FuelRate.fromJson(Map<String, dynamic> json) =>
      _$FuelRateFromJson(json);
}