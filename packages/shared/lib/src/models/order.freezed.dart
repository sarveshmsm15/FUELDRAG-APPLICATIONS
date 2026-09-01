// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Order {

 String get id; String get userId; String? get driverId; String get addressId; String? get vehicleId; FuelType get fuelType; double get quantityLiters; OrderStatus get status; double get subtotal; double get deliveryFee; double get taxAmount; double get discountAmount; double get totalAmount; String? get promoCode; String? get notes; DateTime? get estimatedArrival; DateTime? get actualArrival; DateTime? get completedAt; DateTime? get cancelledAt; String? get cancelReason; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderCopyWith<Order> get copyWith => _$OrderCopyWithImpl<Order>(this as Order, _$identity);

  /// Serializes this Order to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Order&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.driverId, driverId) || other.driverId == driverId)&&(identical(other.addressId, addressId) || other.addressId == addressId)&&(identical(other.vehicleId, vehicleId) || other.vehicleId == vehicleId)&&(identical(other.fuelType, fuelType) || other.fuelType == fuelType)&&(identical(other.quantityLiters, quantityLiters) || other.quantityLiters == quantityLiters)&&(identical(other.status, status) || other.status == status)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.deliveryFee, deliveryFee) || other.deliveryFee == deliveryFee)&&(identical(other.taxAmount, taxAmount) || other.taxAmount == taxAmount)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.promoCode, promoCode) || other.promoCode == promoCode)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.estimatedArrival, estimatedArrival) || other.estimatedArrival == estimatedArrival)&&(identical(other.actualArrival, actualArrival) || other.actualArrival == actualArrival)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.cancelledAt, cancelledAt) || other.cancelledAt == cancelledAt)&&(identical(other.cancelReason, cancelReason) || other.cancelReason == cancelReason)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,userId,driverId,addressId,vehicleId,fuelType,quantityLiters,status,subtotal,deliveryFee,taxAmount,discountAmount,totalAmount,promoCode,notes,estimatedArrival,actualArrival,completedAt,cancelledAt,cancelReason,createdAt,updatedAt]);

@override
String toString() {
  return 'Order(id: $id, userId: $userId, driverId: $driverId, addressId: $addressId, vehicleId: $vehicleId, fuelType: $fuelType, quantityLiters: $quantityLiters, status: $status, subtotal: $subtotal, deliveryFee: $deliveryFee, taxAmount: $taxAmount, discountAmount: $discountAmount, totalAmount: $totalAmount, promoCode: $promoCode, notes: $notes, estimatedArrival: $estimatedArrival, actualArrival: $actualArrival, completedAt: $completedAt, cancelledAt: $cancelledAt, cancelReason: $cancelReason, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $OrderCopyWith<$Res>  {
  factory $OrderCopyWith(Order value, $Res Function(Order) _then) = _$OrderCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String? driverId, String addressId, String? vehicleId, FuelType fuelType, double quantityLiters, OrderStatus status, double subtotal, double deliveryFee, double taxAmount, double discountAmount, double totalAmount, String? promoCode, String? notes, DateTime? estimatedArrival, DateTime? actualArrival, DateTime? completedAt, DateTime? cancelledAt, String? cancelReason, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$OrderCopyWithImpl<$Res>
    implements $OrderCopyWith<$Res> {
  _$OrderCopyWithImpl(this._self, this._then);

  final Order _self;
  final $Res Function(Order) _then;

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? driverId = freezed,Object? addressId = null,Object? vehicleId = freezed,Object? fuelType = null,Object? quantityLiters = null,Object? status = null,Object? subtotal = null,Object? deliveryFee = null,Object? taxAmount = null,Object? discountAmount = null,Object? totalAmount = null,Object? promoCode = freezed,Object? notes = freezed,Object? estimatedArrival = freezed,Object? actualArrival = freezed,Object? completedAt = freezed,Object? cancelledAt = freezed,Object? cancelReason = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,driverId: freezed == driverId ? _self.driverId : driverId // ignore: cast_nullable_to_non_nullable
as String?,addressId: null == addressId ? _self.addressId : addressId // ignore: cast_nullable_to_non_nullable
as String,vehicleId: freezed == vehicleId ? _self.vehicleId : vehicleId // ignore: cast_nullable_to_non_nullable
as String?,fuelType: null == fuelType ? _self.fuelType : fuelType // ignore: cast_nullable_to_non_nullable
as FuelType,quantityLiters: null == quantityLiters ? _self.quantityLiters : quantityLiters // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatus,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as double,deliveryFee: null == deliveryFee ? _self.deliveryFee : deliveryFee // ignore: cast_nullable_to_non_nullable
as double,taxAmount: null == taxAmount ? _self.taxAmount : taxAmount // ignore: cast_nullable_to_non_nullable
as double,discountAmount: null == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as double,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,promoCode: freezed == promoCode ? _self.promoCode : promoCode // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,estimatedArrival: freezed == estimatedArrival ? _self.estimatedArrival : estimatedArrival // ignore: cast_nullable_to_non_nullable
as DateTime?,actualArrival: freezed == actualArrival ? _self.actualArrival : actualArrival // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancelledAt: freezed == cancelledAt ? _self.cancelledAt : cancelledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancelReason: freezed == cancelReason ? _self.cancelReason : cancelReason // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Order].
extension OrderPatterns on Order {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Order value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Order() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Order value)  $default,){
final _that = this;
switch (_that) {
case _Order():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Order value)?  $default,){
final _that = this;
switch (_that) {
case _Order() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String? driverId,  String addressId,  String? vehicleId,  FuelType fuelType,  double quantityLiters,  OrderStatus status,  double subtotal,  double deliveryFee,  double taxAmount,  double discountAmount,  double totalAmount,  String? promoCode,  String? notes,  DateTime? estimatedArrival,  DateTime? actualArrival,  DateTime? completedAt,  DateTime? cancelledAt,  String? cancelReason,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Order() when $default != null:
return $default(_that.id,_that.userId,_that.driverId,_that.addressId,_that.vehicleId,_that.fuelType,_that.quantityLiters,_that.status,_that.subtotal,_that.deliveryFee,_that.taxAmount,_that.discountAmount,_that.totalAmount,_that.promoCode,_that.notes,_that.estimatedArrival,_that.actualArrival,_that.completedAt,_that.cancelledAt,_that.cancelReason,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String? driverId,  String addressId,  String? vehicleId,  FuelType fuelType,  double quantityLiters,  OrderStatus status,  double subtotal,  double deliveryFee,  double taxAmount,  double discountAmount,  double totalAmount,  String? promoCode,  String? notes,  DateTime? estimatedArrival,  DateTime? actualArrival,  DateTime? completedAt,  DateTime? cancelledAt,  String? cancelReason,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Order():
return $default(_that.id,_that.userId,_that.driverId,_that.addressId,_that.vehicleId,_that.fuelType,_that.quantityLiters,_that.status,_that.subtotal,_that.deliveryFee,_that.taxAmount,_that.discountAmount,_that.totalAmount,_that.promoCode,_that.notes,_that.estimatedArrival,_that.actualArrival,_that.completedAt,_that.cancelledAt,_that.cancelReason,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String? driverId,  String addressId,  String? vehicleId,  FuelType fuelType,  double quantityLiters,  OrderStatus status,  double subtotal,  double deliveryFee,  double taxAmount,  double discountAmount,  double totalAmount,  String? promoCode,  String? notes,  DateTime? estimatedArrival,  DateTime? actualArrival,  DateTime? completedAt,  DateTime? cancelledAt,  String? cancelReason,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Order() when $default != null:
return $default(_that.id,_that.userId,_that.driverId,_that.addressId,_that.vehicleId,_that.fuelType,_that.quantityLiters,_that.status,_that.subtotal,_that.deliveryFee,_that.taxAmount,_that.discountAmount,_that.totalAmount,_that.promoCode,_that.notes,_that.estimatedArrival,_that.actualArrival,_that.completedAt,_that.cancelledAt,_that.cancelReason,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Order implements Order {
  const _Order({required this.id, required this.userId, this.driverId, required this.addressId, this.vehicleId, required this.fuelType, required this.quantityLiters, this.status = OrderStatus.pending, required this.subtotal, required this.deliveryFee, required this.taxAmount, this.discountAmount = 0, required this.totalAmount, this.promoCode, this.notes, this.estimatedArrival, this.actualArrival, this.completedAt, this.cancelledAt, this.cancelReason, required this.createdAt, required this.updatedAt});
  factory _Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String? driverId;
@override final  String addressId;
@override final  String? vehicleId;
@override final  FuelType fuelType;
@override final  double quantityLiters;
@override@JsonKey() final  OrderStatus status;
@override final  double subtotal;
@override final  double deliveryFee;
@override final  double taxAmount;
@override@JsonKey() final  double discountAmount;
@override final  double totalAmount;
@override final  String? promoCode;
@override final  String? notes;
@override final  DateTime? estimatedArrival;
@override final  DateTime? actualArrival;
@override final  DateTime? completedAt;
@override final  DateTime? cancelledAt;
@override final  String? cancelReason;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderCopyWith<_Order> get copyWith => __$OrderCopyWithImpl<_Order>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Order&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.driverId, driverId) || other.driverId == driverId)&&(identical(other.addressId, addressId) || other.addressId == addressId)&&(identical(other.vehicleId, vehicleId) || other.vehicleId == vehicleId)&&(identical(other.fuelType, fuelType) || other.fuelType == fuelType)&&(identical(other.quantityLiters, quantityLiters) || other.quantityLiters == quantityLiters)&&(identical(other.status, status) || other.status == status)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.deliveryFee, deliveryFee) || other.deliveryFee == deliveryFee)&&(identical(other.taxAmount, taxAmount) || other.taxAmount == taxAmount)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.promoCode, promoCode) || other.promoCode == promoCode)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.estimatedArrival, estimatedArrival) || other.estimatedArrival == estimatedArrival)&&(identical(other.actualArrival, actualArrival) || other.actualArrival == actualArrival)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.cancelledAt, cancelledAt) || other.cancelledAt == cancelledAt)&&(identical(other.cancelReason, cancelReason) || other.cancelReason == cancelReason)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,userId,driverId,addressId,vehicleId,fuelType,quantityLiters,status,subtotal,deliveryFee,taxAmount,discountAmount,totalAmount,promoCode,notes,estimatedArrival,actualArrival,completedAt,cancelledAt,cancelReason,createdAt,updatedAt]);

@override
String toString() {
  return 'Order(id: $id, userId: $userId, driverId: $driverId, addressId: $addressId, vehicleId: $vehicleId, fuelType: $fuelType, quantityLiters: $quantityLiters, status: $status, subtotal: $subtotal, deliveryFee: $deliveryFee, taxAmount: $taxAmount, discountAmount: $discountAmount, totalAmount: $totalAmount, promoCode: $promoCode, notes: $notes, estimatedArrival: $estimatedArrival, actualArrival: $actualArrival, completedAt: $completedAt, cancelledAt: $cancelledAt, cancelReason: $cancelReason, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$OrderCopyWith<$Res> implements $OrderCopyWith<$Res> {
  factory _$OrderCopyWith(_Order value, $Res Function(_Order) _then) = __$OrderCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String? driverId, String addressId, String? vehicleId, FuelType fuelType, double quantityLiters, OrderStatus status, double subtotal, double deliveryFee, double taxAmount, double discountAmount, double totalAmount, String? promoCode, String? notes, DateTime? estimatedArrival, DateTime? actualArrival, DateTime? completedAt, DateTime? cancelledAt, String? cancelReason, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$OrderCopyWithImpl<$Res>
    implements _$OrderCopyWith<$Res> {
  __$OrderCopyWithImpl(this._self, this._then);

  final _Order _self;
  final $Res Function(_Order) _then;

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? driverId = freezed,Object? addressId = null,Object? vehicleId = freezed,Object? fuelType = null,Object? quantityLiters = null,Object? status = null,Object? subtotal = null,Object? deliveryFee = null,Object? taxAmount = null,Object? discountAmount = null,Object? totalAmount = null,Object? promoCode = freezed,Object? notes = freezed,Object? estimatedArrival = freezed,Object? actualArrival = freezed,Object? completedAt = freezed,Object? cancelledAt = freezed,Object? cancelReason = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Order(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,driverId: freezed == driverId ? _self.driverId : driverId // ignore: cast_nullable_to_non_nullable
as String?,addressId: null == addressId ? _self.addressId : addressId // ignore: cast_nullable_to_non_nullable
as String,vehicleId: freezed == vehicleId ? _self.vehicleId : vehicleId // ignore: cast_nullable_to_non_nullable
as String?,fuelType: null == fuelType ? _self.fuelType : fuelType // ignore: cast_nullable_to_non_nullable
as FuelType,quantityLiters: null == quantityLiters ? _self.quantityLiters : quantityLiters // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatus,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as double,deliveryFee: null == deliveryFee ? _self.deliveryFee : deliveryFee // ignore: cast_nullable_to_non_nullable
as double,taxAmount: null == taxAmount ? _self.taxAmount : taxAmount // ignore: cast_nullable_to_non_nullable
as double,discountAmount: null == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as double,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,promoCode: freezed == promoCode ? _self.promoCode : promoCode // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,estimatedArrival: freezed == estimatedArrival ? _self.estimatedArrival : estimatedArrival // ignore: cast_nullable_to_non_nullable
as DateTime?,actualArrival: freezed == actualArrival ? _self.actualArrival : actualArrival // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancelledAt: freezed == cancelledAt ? _self.cancelledAt : cancelledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancelReason: freezed == cancelReason ? _self.cancelReason : cancelReason // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$OrderCreateRequest {

 String get addressId; String? get vehicleId; FuelType get fuelType; double get quantityLiters; String? get promoCode; String? get notes;
/// Create a copy of OrderCreateRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderCreateRequestCopyWith<OrderCreateRequest> get copyWith => _$OrderCreateRequestCopyWithImpl<OrderCreateRequest>(this as OrderCreateRequest, _$identity);

  /// Serializes this OrderCreateRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderCreateRequest&&(identical(other.addressId, addressId) || other.addressId == addressId)&&(identical(other.vehicleId, vehicleId) || other.vehicleId == vehicleId)&&(identical(other.fuelType, fuelType) || other.fuelType == fuelType)&&(identical(other.quantityLiters, quantityLiters) || other.quantityLiters == quantityLiters)&&(identical(other.promoCode, promoCode) || other.promoCode == promoCode)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,addressId,vehicleId,fuelType,quantityLiters,promoCode,notes);

@override
String toString() {
  return 'OrderCreateRequest(addressId: $addressId, vehicleId: $vehicleId, fuelType: $fuelType, quantityLiters: $quantityLiters, promoCode: $promoCode, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $OrderCreateRequestCopyWith<$Res>  {
  factory $OrderCreateRequestCopyWith(OrderCreateRequest value, $Res Function(OrderCreateRequest) _then) = _$OrderCreateRequestCopyWithImpl;
@useResult
$Res call({
 String addressId, String? vehicleId, FuelType fuelType, double quantityLiters, String? promoCode, String? notes
});




}
/// @nodoc
class _$OrderCreateRequestCopyWithImpl<$Res>
    implements $OrderCreateRequestCopyWith<$Res> {
  _$OrderCreateRequestCopyWithImpl(this._self, this._then);

  final OrderCreateRequest _self;
  final $Res Function(OrderCreateRequest) _then;

/// Create a copy of OrderCreateRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? addressId = null,Object? vehicleId = freezed,Object? fuelType = null,Object? quantityLiters = null,Object? promoCode = freezed,Object? notes = freezed,}) {
  return _then(_self.copyWith(
addressId: null == addressId ? _self.addressId : addressId // ignore: cast_nullable_to_non_nullable
as String,vehicleId: freezed == vehicleId ? _self.vehicleId : vehicleId // ignore: cast_nullable_to_non_nullable
as String?,fuelType: null == fuelType ? _self.fuelType : fuelType // ignore: cast_nullable_to_non_nullable
as FuelType,quantityLiters: null == quantityLiters ? _self.quantityLiters : quantityLiters // ignore: cast_nullable_to_non_nullable
as double,promoCode: freezed == promoCode ? _self.promoCode : promoCode // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderCreateRequest].
extension OrderCreateRequestPatterns on OrderCreateRequest {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderCreateRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderCreateRequest() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderCreateRequest value)  $default,){
final _that = this;
switch (_that) {
case _OrderCreateRequest():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderCreateRequest value)?  $default,){
final _that = this;
switch (_that) {
case _OrderCreateRequest() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String addressId,  String? vehicleId,  FuelType fuelType,  double quantityLiters,  String? promoCode,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderCreateRequest() when $default != null:
return $default(_that.addressId,_that.vehicleId,_that.fuelType,_that.quantityLiters,_that.promoCode,_that.notes);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String addressId,  String? vehicleId,  FuelType fuelType,  double quantityLiters,  String? promoCode,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _OrderCreateRequest():
return $default(_that.addressId,_that.vehicleId,_that.fuelType,_that.quantityLiters,_that.promoCode,_that.notes);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String addressId,  String? vehicleId,  FuelType fuelType,  double quantityLiters,  String? promoCode,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _OrderCreateRequest() when $default != null:
return $default(_that.addressId,_that.vehicleId,_that.fuelType,_that.quantityLiters,_that.promoCode,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderCreateRequest implements OrderCreateRequest {
  const _OrderCreateRequest({required this.addressId, this.vehicleId, required this.fuelType, required this.quantityLiters, this.promoCode, this.notes});
  factory _OrderCreateRequest.fromJson(Map<String, dynamic> json) => _$OrderCreateRequestFromJson(json);

@override final  String addressId;
@override final  String? vehicleId;
@override final  FuelType fuelType;
@override final  double quantityLiters;
@override final  String? promoCode;
@override final  String? notes;

/// Create a copy of OrderCreateRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderCreateRequestCopyWith<_OrderCreateRequest> get copyWith => __$OrderCreateRequestCopyWithImpl<_OrderCreateRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderCreateRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderCreateRequest&&(identical(other.addressId, addressId) || other.addressId == addressId)&&(identical(other.vehicleId, vehicleId) || other.vehicleId == vehicleId)&&(identical(other.fuelType, fuelType) || other.fuelType == fuelType)&&(identical(other.quantityLiters, quantityLiters) || other.quantityLiters == quantityLiters)&&(identical(other.promoCode, promoCode) || other.promoCode == promoCode)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,addressId,vehicleId,fuelType,quantityLiters,promoCode,notes);

@override
String toString() {
  return 'OrderCreateRequest(addressId: $addressId, vehicleId: $vehicleId, fuelType: $fuelType, quantityLiters: $quantityLiters, promoCode: $promoCode, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$OrderCreateRequestCopyWith<$Res> implements $OrderCreateRequestCopyWith<$Res> {
  factory _$OrderCreateRequestCopyWith(_OrderCreateRequest value, $Res Function(_OrderCreateRequest) _then) = __$OrderCreateRequestCopyWithImpl;
@override @useResult
$Res call({
 String addressId, String? vehicleId, FuelType fuelType, double quantityLiters, String? promoCode, String? notes
});




}
/// @nodoc
class __$OrderCreateRequestCopyWithImpl<$Res>
    implements _$OrderCreateRequestCopyWith<$Res> {
  __$OrderCreateRequestCopyWithImpl(this._self, this._then);

  final _OrderCreateRequest _self;
  final $Res Function(_OrderCreateRequest) _then;

/// Create a copy of OrderCreateRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? addressId = null,Object? vehicleId = freezed,Object? fuelType = null,Object? quantityLiters = null,Object? promoCode = freezed,Object? notes = freezed,}) {
  return _then(_OrderCreateRequest(
addressId: null == addressId ? _self.addressId : addressId // ignore: cast_nullable_to_non_nullable
as String,vehicleId: freezed == vehicleId ? _self.vehicleId : vehicleId // ignore: cast_nullable_to_non_nullable
as String?,fuelType: null == fuelType ? _self.fuelType : fuelType // ignore: cast_nullable_to_non_nullable
as FuelType,quantityLiters: null == quantityLiters ? _self.quantityLiters : quantityLiters // ignore: cast_nullable_to_non_nullable
as double,promoCode: freezed == promoCode ? _self.promoCode : promoCode // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
