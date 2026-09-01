// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pricing_snapshot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PricingSnapshot {

 String get id; String? get orderId; FuelType get fuelType; double get basePrice; double get surgeMultiplier; double get deliveryFee; double get taxAmount; double get discountAmount; double get totalAmount; double get quantityLiters; DateTime get priceLockedAt; DateTime get priceExpiresAt; DateTime get createdAt;
/// Create a copy of PricingSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PricingSnapshotCopyWith<PricingSnapshot> get copyWith => _$PricingSnapshotCopyWithImpl<PricingSnapshot>(this as PricingSnapshot, _$identity);

  /// Serializes this PricingSnapshot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PricingSnapshot&&(identical(other.id, id) || other.id == id)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.fuelType, fuelType) || other.fuelType == fuelType)&&(identical(other.basePrice, basePrice) || other.basePrice == basePrice)&&(identical(other.surgeMultiplier, surgeMultiplier) || other.surgeMultiplier == surgeMultiplier)&&(identical(other.deliveryFee, deliveryFee) || other.deliveryFee == deliveryFee)&&(identical(other.taxAmount, taxAmount) || other.taxAmount == taxAmount)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.quantityLiters, quantityLiters) || other.quantityLiters == quantityLiters)&&(identical(other.priceLockedAt, priceLockedAt) || other.priceLockedAt == priceLockedAt)&&(identical(other.priceExpiresAt, priceExpiresAt) || other.priceExpiresAt == priceExpiresAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orderId,fuelType,basePrice,surgeMultiplier,deliveryFee,taxAmount,discountAmount,totalAmount,quantityLiters,priceLockedAt,priceExpiresAt,createdAt);

@override
String toString() {
  return 'PricingSnapshot(id: $id, orderId: $orderId, fuelType: $fuelType, basePrice: $basePrice, surgeMultiplier: $surgeMultiplier, deliveryFee: $deliveryFee, taxAmount: $taxAmount, discountAmount: $discountAmount, totalAmount: $totalAmount, quantityLiters: $quantityLiters, priceLockedAt: $priceLockedAt, priceExpiresAt: $priceExpiresAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $PricingSnapshotCopyWith<$Res>  {
  factory $PricingSnapshotCopyWith(PricingSnapshot value, $Res Function(PricingSnapshot) _then) = _$PricingSnapshotCopyWithImpl;
@useResult
$Res call({
 String id, String? orderId, FuelType fuelType, double basePrice, double surgeMultiplier, double deliveryFee, double taxAmount, double discountAmount, double totalAmount, double quantityLiters, DateTime priceLockedAt, DateTime priceExpiresAt, DateTime createdAt
});




}
/// @nodoc
class _$PricingSnapshotCopyWithImpl<$Res>
    implements $PricingSnapshotCopyWith<$Res> {
  _$PricingSnapshotCopyWithImpl(this._self, this._then);

  final PricingSnapshot _self;
  final $Res Function(PricingSnapshot) _then;

/// Create a copy of PricingSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orderId = freezed,Object? fuelType = null,Object? basePrice = null,Object? surgeMultiplier = null,Object? deliveryFee = null,Object? taxAmount = null,Object? discountAmount = null,Object? totalAmount = null,Object? quantityLiters = null,Object? priceLockedAt = null,Object? priceExpiresAt = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderId: freezed == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String?,fuelType: null == fuelType ? _self.fuelType : fuelType // ignore: cast_nullable_to_non_nullable
as FuelType,basePrice: null == basePrice ? _self.basePrice : basePrice // ignore: cast_nullable_to_non_nullable
as double,surgeMultiplier: null == surgeMultiplier ? _self.surgeMultiplier : surgeMultiplier // ignore: cast_nullable_to_non_nullable
as double,deliveryFee: null == deliveryFee ? _self.deliveryFee : deliveryFee // ignore: cast_nullable_to_non_nullable
as double,taxAmount: null == taxAmount ? _self.taxAmount : taxAmount // ignore: cast_nullable_to_non_nullable
as double,discountAmount: null == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as double,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,quantityLiters: null == quantityLiters ? _self.quantityLiters : quantityLiters // ignore: cast_nullable_to_non_nullable
as double,priceLockedAt: null == priceLockedAt ? _self.priceLockedAt : priceLockedAt // ignore: cast_nullable_to_non_nullable
as DateTime,priceExpiresAt: null == priceExpiresAt ? _self.priceExpiresAt : priceExpiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [PricingSnapshot].
extension PricingSnapshotPatterns on PricingSnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PricingSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PricingSnapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PricingSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _PricingSnapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PricingSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _PricingSnapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? orderId,  FuelType fuelType,  double basePrice,  double surgeMultiplier,  double deliveryFee,  double taxAmount,  double discountAmount,  double totalAmount,  double quantityLiters,  DateTime priceLockedAt,  DateTime priceExpiresAt,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PricingSnapshot() when $default != null:
return $default(_that.id,_that.orderId,_that.fuelType,_that.basePrice,_that.surgeMultiplier,_that.deliveryFee,_that.taxAmount,_that.discountAmount,_that.totalAmount,_that.quantityLiters,_that.priceLockedAt,_that.priceExpiresAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? orderId,  FuelType fuelType,  double basePrice,  double surgeMultiplier,  double deliveryFee,  double taxAmount,  double discountAmount,  double totalAmount,  double quantityLiters,  DateTime priceLockedAt,  DateTime priceExpiresAt,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _PricingSnapshot():
return $default(_that.id,_that.orderId,_that.fuelType,_that.basePrice,_that.surgeMultiplier,_that.deliveryFee,_that.taxAmount,_that.discountAmount,_that.totalAmount,_that.quantityLiters,_that.priceLockedAt,_that.priceExpiresAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? orderId,  FuelType fuelType,  double basePrice,  double surgeMultiplier,  double deliveryFee,  double taxAmount,  double discountAmount,  double totalAmount,  double quantityLiters,  DateTime priceLockedAt,  DateTime priceExpiresAt,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _PricingSnapshot() when $default != null:
return $default(_that.id,_that.orderId,_that.fuelType,_that.basePrice,_that.surgeMultiplier,_that.deliveryFee,_that.taxAmount,_that.discountAmount,_that.totalAmount,_that.quantityLiters,_that.priceLockedAt,_that.priceExpiresAt,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PricingSnapshot implements PricingSnapshot {
  const _PricingSnapshot({required this.id, this.orderId, required this.fuelType, required this.basePrice, this.surgeMultiplier = 1.0, required this.deliveryFee, required this.taxAmount, this.discountAmount = 0, required this.totalAmount, required this.quantityLiters, required this.priceLockedAt, required this.priceExpiresAt, required this.createdAt});
  factory _PricingSnapshot.fromJson(Map<String, dynamic> json) => _$PricingSnapshotFromJson(json);

@override final  String id;
@override final  String? orderId;
@override final  FuelType fuelType;
@override final  double basePrice;
@override@JsonKey() final  double surgeMultiplier;
@override final  double deliveryFee;
@override final  double taxAmount;
@override@JsonKey() final  double discountAmount;
@override final  double totalAmount;
@override final  double quantityLiters;
@override final  DateTime priceLockedAt;
@override final  DateTime priceExpiresAt;
@override final  DateTime createdAt;

/// Create a copy of PricingSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PricingSnapshotCopyWith<_PricingSnapshot> get copyWith => __$PricingSnapshotCopyWithImpl<_PricingSnapshot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PricingSnapshotToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PricingSnapshot&&(identical(other.id, id) || other.id == id)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.fuelType, fuelType) || other.fuelType == fuelType)&&(identical(other.basePrice, basePrice) || other.basePrice == basePrice)&&(identical(other.surgeMultiplier, surgeMultiplier) || other.surgeMultiplier == surgeMultiplier)&&(identical(other.deliveryFee, deliveryFee) || other.deliveryFee == deliveryFee)&&(identical(other.taxAmount, taxAmount) || other.taxAmount == taxAmount)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.quantityLiters, quantityLiters) || other.quantityLiters == quantityLiters)&&(identical(other.priceLockedAt, priceLockedAt) || other.priceLockedAt == priceLockedAt)&&(identical(other.priceExpiresAt, priceExpiresAt) || other.priceExpiresAt == priceExpiresAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orderId,fuelType,basePrice,surgeMultiplier,deliveryFee,taxAmount,discountAmount,totalAmount,quantityLiters,priceLockedAt,priceExpiresAt,createdAt);

@override
String toString() {
  return 'PricingSnapshot(id: $id, orderId: $orderId, fuelType: $fuelType, basePrice: $basePrice, surgeMultiplier: $surgeMultiplier, deliveryFee: $deliveryFee, taxAmount: $taxAmount, discountAmount: $discountAmount, totalAmount: $totalAmount, quantityLiters: $quantityLiters, priceLockedAt: $priceLockedAt, priceExpiresAt: $priceExpiresAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$PricingSnapshotCopyWith<$Res> implements $PricingSnapshotCopyWith<$Res> {
  factory _$PricingSnapshotCopyWith(_PricingSnapshot value, $Res Function(_PricingSnapshot) _then) = __$PricingSnapshotCopyWithImpl;
@override @useResult
$Res call({
 String id, String? orderId, FuelType fuelType, double basePrice, double surgeMultiplier, double deliveryFee, double taxAmount, double discountAmount, double totalAmount, double quantityLiters, DateTime priceLockedAt, DateTime priceExpiresAt, DateTime createdAt
});




}
/// @nodoc
class __$PricingSnapshotCopyWithImpl<$Res>
    implements _$PricingSnapshotCopyWith<$Res> {
  __$PricingSnapshotCopyWithImpl(this._self, this._then);

  final _PricingSnapshot _self;
  final $Res Function(_PricingSnapshot) _then;

/// Create a copy of PricingSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orderId = freezed,Object? fuelType = null,Object? basePrice = null,Object? surgeMultiplier = null,Object? deliveryFee = null,Object? taxAmount = null,Object? discountAmount = null,Object? totalAmount = null,Object? quantityLiters = null,Object? priceLockedAt = null,Object? priceExpiresAt = null,Object? createdAt = null,}) {
  return _then(_PricingSnapshot(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderId: freezed == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String?,fuelType: null == fuelType ? _self.fuelType : fuelType // ignore: cast_nullable_to_non_nullable
as FuelType,basePrice: null == basePrice ? _self.basePrice : basePrice // ignore: cast_nullable_to_non_nullable
as double,surgeMultiplier: null == surgeMultiplier ? _self.surgeMultiplier : surgeMultiplier // ignore: cast_nullable_to_non_nullable
as double,deliveryFee: null == deliveryFee ? _self.deliveryFee : deliveryFee // ignore: cast_nullable_to_non_nullable
as double,taxAmount: null == taxAmount ? _self.taxAmount : taxAmount // ignore: cast_nullable_to_non_nullable
as double,discountAmount: null == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as double,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,quantityLiters: null == quantityLiters ? _self.quantityLiters : quantityLiters // ignore: cast_nullable_to_non_nullable
as double,priceLockedAt: null == priceLockedAt ? _self.priceLockedAt : priceLockedAt // ignore: cast_nullable_to_non_nullable
as DateTime,priceExpiresAt: null == priceExpiresAt ? _self.priceExpiresAt : priceExpiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$PricingCalculateRequest {

 FuelType get fuelType; double get quantityLiters; double get distanceKm; String? get promoCode;
/// Create a copy of PricingCalculateRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PricingCalculateRequestCopyWith<PricingCalculateRequest> get copyWith => _$PricingCalculateRequestCopyWithImpl<PricingCalculateRequest>(this as PricingCalculateRequest, _$identity);

  /// Serializes this PricingCalculateRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PricingCalculateRequest&&(identical(other.fuelType, fuelType) || other.fuelType == fuelType)&&(identical(other.quantityLiters, quantityLiters) || other.quantityLiters == quantityLiters)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm)&&(identical(other.promoCode, promoCode) || other.promoCode == promoCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fuelType,quantityLiters,distanceKm,promoCode);

@override
String toString() {
  return 'PricingCalculateRequest(fuelType: $fuelType, quantityLiters: $quantityLiters, distanceKm: $distanceKm, promoCode: $promoCode)';
}


}

/// @nodoc
abstract mixin class $PricingCalculateRequestCopyWith<$Res>  {
  factory $PricingCalculateRequestCopyWith(PricingCalculateRequest value, $Res Function(PricingCalculateRequest) _then) = _$PricingCalculateRequestCopyWithImpl;
@useResult
$Res call({
 FuelType fuelType, double quantityLiters, double distanceKm, String? promoCode
});




}
/// @nodoc
class _$PricingCalculateRequestCopyWithImpl<$Res>
    implements $PricingCalculateRequestCopyWith<$Res> {
  _$PricingCalculateRequestCopyWithImpl(this._self, this._then);

  final PricingCalculateRequest _self;
  final $Res Function(PricingCalculateRequest) _then;

/// Create a copy of PricingCalculateRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fuelType = null,Object? quantityLiters = null,Object? distanceKm = null,Object? promoCode = freezed,}) {
  return _then(_self.copyWith(
fuelType: null == fuelType ? _self.fuelType : fuelType // ignore: cast_nullable_to_non_nullable
as FuelType,quantityLiters: null == quantityLiters ? _self.quantityLiters : quantityLiters // ignore: cast_nullable_to_non_nullable
as double,distanceKm: null == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double,promoCode: freezed == promoCode ? _self.promoCode : promoCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PricingCalculateRequest].
extension PricingCalculateRequestPatterns on PricingCalculateRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PricingCalculateRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PricingCalculateRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PricingCalculateRequest value)  $default,){
final _that = this;
switch (_that) {
case _PricingCalculateRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PricingCalculateRequest value)?  $default,){
final _that = this;
switch (_that) {
case _PricingCalculateRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( FuelType fuelType,  double quantityLiters,  double distanceKm,  String? promoCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PricingCalculateRequest() when $default != null:
return $default(_that.fuelType,_that.quantityLiters,_that.distanceKm,_that.promoCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( FuelType fuelType,  double quantityLiters,  double distanceKm,  String? promoCode)  $default,) {final _that = this;
switch (_that) {
case _PricingCalculateRequest():
return $default(_that.fuelType,_that.quantityLiters,_that.distanceKm,_that.promoCode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( FuelType fuelType,  double quantityLiters,  double distanceKm,  String? promoCode)?  $default,) {final _that = this;
switch (_that) {
case _PricingCalculateRequest() when $default != null:
return $default(_that.fuelType,_that.quantityLiters,_that.distanceKm,_that.promoCode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PricingCalculateRequest implements PricingCalculateRequest {
  const _PricingCalculateRequest({required this.fuelType, required this.quantityLiters, required this.distanceKm, this.promoCode});
  factory _PricingCalculateRequest.fromJson(Map<String, dynamic> json) => _$PricingCalculateRequestFromJson(json);

@override final  FuelType fuelType;
@override final  double quantityLiters;
@override final  double distanceKm;
@override final  String? promoCode;

/// Create a copy of PricingCalculateRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PricingCalculateRequestCopyWith<_PricingCalculateRequest> get copyWith => __$PricingCalculateRequestCopyWithImpl<_PricingCalculateRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PricingCalculateRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PricingCalculateRequest&&(identical(other.fuelType, fuelType) || other.fuelType == fuelType)&&(identical(other.quantityLiters, quantityLiters) || other.quantityLiters == quantityLiters)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm)&&(identical(other.promoCode, promoCode) || other.promoCode == promoCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fuelType,quantityLiters,distanceKm,promoCode);

@override
String toString() {
  return 'PricingCalculateRequest(fuelType: $fuelType, quantityLiters: $quantityLiters, distanceKm: $distanceKm, promoCode: $promoCode)';
}


}

/// @nodoc
abstract mixin class _$PricingCalculateRequestCopyWith<$Res> implements $PricingCalculateRequestCopyWith<$Res> {
  factory _$PricingCalculateRequestCopyWith(_PricingCalculateRequest value, $Res Function(_PricingCalculateRequest) _then) = __$PricingCalculateRequestCopyWithImpl;
@override @useResult
$Res call({
 FuelType fuelType, double quantityLiters, double distanceKm, String? promoCode
});




}
/// @nodoc
class __$PricingCalculateRequestCopyWithImpl<$Res>
    implements _$PricingCalculateRequestCopyWith<$Res> {
  __$PricingCalculateRequestCopyWithImpl(this._self, this._then);

  final _PricingCalculateRequest _self;
  final $Res Function(_PricingCalculateRequest) _then;

/// Create a copy of PricingCalculateRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fuelType = null,Object? quantityLiters = null,Object? distanceKm = null,Object? promoCode = freezed,}) {
  return _then(_PricingCalculateRequest(
fuelType: null == fuelType ? _self.fuelType : fuelType // ignore: cast_nullable_to_non_nullable
as FuelType,quantityLiters: null == quantityLiters ? _self.quantityLiters : quantityLiters // ignore: cast_nullable_to_non_nullable
as double,distanceKm: null == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double,promoCode: freezed == promoCode ? _self.promoCode : promoCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
