import 'package:freezed_annotation/freezed_annotation.dart';
import '../enums/fuel_type.dart';

part 'pricing_snapshot.freezed.dart';
part 'pricing_snapshot.g.dart';

@freezed
abstract class PricingSnapshot with _$PricingSnapshot {
  const factory PricingSnapshot({
    required String id,
    String? orderId,
    required FuelType fuelType,
    required double basePrice,
    @Default(1.0) double surgeMultiplier,
    required double deliveryFee,
    required double taxAmount,
    @Default(0) double discountAmount,
    required double totalAmount,
    required double quantityLiters,
    required DateTime priceLockedAt,
    required DateTime priceExpiresAt,
    required DateTime createdAt,
  }) = _PricingSnapshot;

  factory PricingSnapshot.fromJson(Map<String, dynamic> json) =>
      _$PricingSnapshotFromJson(json);
}

@freezed
abstract class PricingCalculateRequest with _$PricingCalculateRequest {
  const factory PricingCalculateRequest({
    required FuelType fuelType,
    required double quantityLiters,
    required double distanceKm,
    String? promoCode,
  }) = _PricingCalculateRequest;

  factory PricingCalculateRequest.fromJson(Map<String, dynamic> json) =>
      _$PricingCalculateRequestFromJson(json);
}