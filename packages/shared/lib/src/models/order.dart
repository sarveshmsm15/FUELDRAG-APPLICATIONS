import 'package:freezed_annotation/freezed_annotation.dart';
import '../enums/fuel_type.dart';
import '../enums/order_status.dart';

part 'order.freezed.dart';
part 'order.g.dart';

@freezed
abstract class Order with _$Order {
  const factory Order({
    required String id,
    required String userId,
    String? driverId,
    required String addressId,
    String? vehicleId,
    required FuelType fuelType,
    required double quantityLiters,
    @Default(OrderStatus.pending) OrderStatus status,
    required double subtotal,
    required double deliveryFee,
    required double taxAmount,
    @Default(0) double discountAmount,
    required double totalAmount,
    String? promoCode,
    String? notes,
    DateTime? estimatedArrival,
    DateTime? actualArrival,
    DateTime? completedAt,
    DateTime? cancelledAt,
    String? cancelReason,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}

@freezed
abstract class OrderCreateRequest with _$OrderCreateRequest {
  const factory OrderCreateRequest({
    required String addressId,
    String? vehicleId,
    required FuelType fuelType,
    required double quantityLiters,
    String? promoCode,
    String? notes,
  }) = _OrderCreateRequest;

  factory OrderCreateRequest.fromJson(Map<String, dynamic> json) =>
      _$OrderCreateRequestFromJson(json);
}