// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Order _$OrderFromJson(Map<String, dynamic> json) => _Order(
  id: json['id'] as String,
  userId: json['userId'] as String,
  driverId: json['driverId'] as String?,
  addressId: json['addressId'] as String,
  vehicleId: json['vehicleId'] as String?,
  fuelType: $enumDecode(_$FuelTypeEnumMap, json['fuelType']),
  quantityLiters: (json['quantityLiters'] as num).toDouble(),
  status:
      $enumDecodeNullable(_$OrderStatusEnumMap, json['status']) ??
      OrderStatus.pending,
  subtotal: (json['subtotal'] as num).toDouble(),
  deliveryFee: (json['deliveryFee'] as num).toDouble(),
  taxAmount: (json['taxAmount'] as num).toDouble(),
  discountAmount: (json['discountAmount'] as num?)?.toDouble() ?? 0,
  totalAmount: (json['totalAmount'] as num).toDouble(),
  promoCode: json['promoCode'] as String?,
  notes: json['notes'] as String?,
  estimatedArrival: json['estimatedArrival'] == null
      ? null
      : DateTime.parse(json['estimatedArrival'] as String),
  actualArrival: json['actualArrival'] == null
      ? null
      : DateTime.parse(json['actualArrival'] as String),
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
  cancelledAt: json['cancelledAt'] == null
      ? null
      : DateTime.parse(json['cancelledAt'] as String),
  cancelReason: json['cancelReason'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$OrderToJson(_Order instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'driverId': instance.driverId,
  'addressId': instance.addressId,
  'vehicleId': instance.vehicleId,
  'fuelType': _$FuelTypeEnumMap[instance.fuelType]!,
  'quantityLiters': instance.quantityLiters,
  'status': _$OrderStatusEnumMap[instance.status]!,
  'subtotal': instance.subtotal,
  'deliveryFee': instance.deliveryFee,
  'taxAmount': instance.taxAmount,
  'discountAmount': instance.discountAmount,
  'totalAmount': instance.totalAmount,
  'promoCode': instance.promoCode,
  'notes': instance.notes,
  'estimatedArrival': instance.estimatedArrival?.toIso8601String(),
  'actualArrival': instance.actualArrival?.toIso8601String(),
  'completedAt': instance.completedAt?.toIso8601String(),
  'cancelledAt': instance.cancelledAt?.toIso8601String(),
  'cancelReason': instance.cancelReason,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

const _$FuelTypeEnumMap = {
  FuelType.petrol: 'petrol',
  FuelType.diesel: 'diesel',
  FuelType.cng: 'cng',
  FuelType.evCharge: 'ev_charge',
};

const _$OrderStatusEnumMap = {
  OrderStatus.pending: 'pending',
  OrderStatus.confirmed: 'confirmed',
  OrderStatus.driverAssigned: 'driver_assigned',
  OrderStatus.driverEnRoute: 'driver_en_route',
  OrderStatus.arrived: 'arrived',
  OrderStatus.fueling: 'fueling',
  OrderStatus.completed: 'completed',
  OrderStatus.cancelled: 'cancelled',
  OrderStatus.failed: 'failed',
};

_OrderCreateRequest _$OrderCreateRequestFromJson(Map<String, dynamic> json) =>
    _OrderCreateRequest(
      addressId: json['addressId'] as String,
      vehicleId: json['vehicleId'] as String?,
      fuelType: $enumDecode(_$FuelTypeEnumMap, json['fuelType']),
      quantityLiters: (json['quantityLiters'] as num).toDouble(),
      promoCode: json['promoCode'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$OrderCreateRequestToJson(_OrderCreateRequest instance) =>
    <String, dynamic>{
      'addressId': instance.addressId,
      'vehicleId': instance.vehicleId,
      'fuelType': _$FuelTypeEnumMap[instance.fuelType]!,
      'quantityLiters': instance.quantityLiters,
      'promoCode': instance.promoCode,
      'notes': instance.notes,
    };
