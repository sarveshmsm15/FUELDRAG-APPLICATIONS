// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fuel_rate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FuelRate {

 String get id; FuelType get fuelType; double get pricePerLiter; DateTime get effectiveFrom; DateTime? get effectiveTo; String get region; bool get isActive; DateTime get createdAt;
/// Create a copy of FuelRate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FuelRateCopyWith<FuelRate> get copyWith => _$FuelRateCopyWithImpl<FuelRate>(this as FuelRate, _$identity);

  /// Serializes this FuelRate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FuelRate&&(identical(other.id, id) || other.id == id)&&(identical(other.fuelType, fuelType) || other.fuelType == fuelType)&&(identical(other.pricePerLiter, pricePerLiter) || other.pricePerLiter == pricePerLiter)&&(identical(other.effectiveFrom, effectiveFrom) || other.effectiveFrom == effectiveFrom)&&(identical(other.effectiveTo, effectiveTo) || other.effectiveTo == effectiveTo)&&(identical(other.region, region) || other.region == region)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fuelType,pricePerLiter,effectiveFrom,effectiveTo,region,isActive,createdAt);

@override
String toString() {
  return 'FuelRate(id: $id, fuelType: $fuelType, pricePerLiter: $pricePerLiter, effectiveFrom: $effectiveFrom, effectiveTo: $effectiveTo, region: $region, isActive: $isActive, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $FuelRateCopyWith<$Res>  {
  factory $FuelRateCopyWith(FuelRate value, $Res Function(FuelRate) _then) = _$FuelRateCopyWithImpl;
@useResult
$Res call({
 String id, FuelType fuelType, double pricePerLiter, DateTime effectiveFrom, DateTime? effectiveTo, String region, bool isActive, DateTime createdAt
});




}
/// @nodoc
class _$FuelRateCopyWithImpl<$Res>
    implements $FuelRateCopyWith<$Res> {
  _$FuelRateCopyWithImpl(this._self, this._then);

  final FuelRate _self;
  final $Res Function(FuelRate) _then;

/// Create a copy of FuelRate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fuelType = null,Object? pricePerLiter = null,Object? effectiveFrom = null,Object? effectiveTo = freezed,Object? region = null,Object? isActive = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fuelType: null == fuelType ? _self.fuelType : fuelType // ignore: cast_nullable_to_non_nullable
as FuelType,pricePerLiter: null == pricePerLiter ? _self.pricePerLiter : pricePerLiter // ignore: cast_nullable_to_non_nullable
as double,effectiveFrom: null == effectiveFrom ? _self.effectiveFrom : effectiveFrom // ignore: cast_nullable_to_non_nullable
as DateTime,effectiveTo: freezed == effectiveTo ? _self.effectiveTo : effectiveTo // ignore: cast_nullable_to_non_nullable
as DateTime?,region: null == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [FuelRate].
extension FuelRatePatterns on FuelRate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FuelRate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FuelRate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FuelRate value)  $default,){
final _that = this;
switch (_that) {
case _FuelRate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FuelRate value)?  $default,){
final _that = this;
switch (_that) {
case _FuelRate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  FuelType fuelType,  double pricePerLiter,  DateTime effectiveFrom,  DateTime? effectiveTo,  String region,  bool isActive,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FuelRate() when $default != null:
return $default(_that.id,_that.fuelType,_that.pricePerLiter,_that.effectiveFrom,_that.effectiveTo,_that.region,_that.isActive,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  FuelType fuelType,  double pricePerLiter,  DateTime effectiveFrom,  DateTime? effectiveTo,  String region,  bool isActive,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _FuelRate():
return $default(_that.id,_that.fuelType,_that.pricePerLiter,_that.effectiveFrom,_that.effectiveTo,_that.region,_that.isActive,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  FuelType fuelType,  double pricePerLiter,  DateTime effectiveFrom,  DateTime? effectiveTo,  String region,  bool isActive,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _FuelRate() when $default != null:
return $default(_that.id,_that.fuelType,_that.pricePerLiter,_that.effectiveFrom,_that.effectiveTo,_that.region,_that.isActive,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FuelRate implements FuelRate {
  const _FuelRate({required this.id, required this.fuelType, required this.pricePerLiter, required this.effectiveFrom, this.effectiveTo, this.region = 'default', this.isActive = true, required this.createdAt});
  factory _FuelRate.fromJson(Map<String, dynamic> json) => _$FuelRateFromJson(json);

@override final  String id;
@override final  FuelType fuelType;
@override final  double pricePerLiter;
@override final  DateTime effectiveFrom;
@override final  DateTime? effectiveTo;
@override@JsonKey() final  String region;
@override@JsonKey() final  bool isActive;
@override final  DateTime createdAt;

/// Create a copy of FuelRate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FuelRateCopyWith<_FuelRate> get copyWith => __$FuelRateCopyWithImpl<_FuelRate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FuelRateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FuelRate&&(identical(other.id, id) || other.id == id)&&(identical(other.fuelType, fuelType) || other.fuelType == fuelType)&&(identical(other.pricePerLiter, pricePerLiter) || other.pricePerLiter == pricePerLiter)&&(identical(other.effectiveFrom, effectiveFrom) || other.effectiveFrom == effectiveFrom)&&(identical(other.effectiveTo, effectiveTo) || other.effectiveTo == effectiveTo)&&(identical(other.region, region) || other.region == region)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fuelType,pricePerLiter,effectiveFrom,effectiveTo,region,isActive,createdAt);

@override
String toString() {
  return 'FuelRate(id: $id, fuelType: $fuelType, pricePerLiter: $pricePerLiter, effectiveFrom: $effectiveFrom, effectiveTo: $effectiveTo, region: $region, isActive: $isActive, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$FuelRateCopyWith<$Res> implements $FuelRateCopyWith<$Res> {
  factory _$FuelRateCopyWith(_FuelRate value, $Res Function(_FuelRate) _then) = __$FuelRateCopyWithImpl;
@override @useResult
$Res call({
 String id, FuelType fuelType, double pricePerLiter, DateTime effectiveFrom, DateTime? effectiveTo, String region, bool isActive, DateTime createdAt
});




}
/// @nodoc
class __$FuelRateCopyWithImpl<$Res>
    implements _$FuelRateCopyWith<$Res> {
  __$FuelRateCopyWithImpl(this._self, this._then);

  final _FuelRate _self;
  final $Res Function(_FuelRate) _then;

/// Create a copy of FuelRate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fuelType = null,Object? pricePerLiter = null,Object? effectiveFrom = null,Object? effectiveTo = freezed,Object? region = null,Object? isActive = null,Object? createdAt = null,}) {
  return _then(_FuelRate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fuelType: null == fuelType ? _self.fuelType : fuelType // ignore: cast_nullable_to_non_nullable
as FuelType,pricePerLiter: null == pricePerLiter ? _self.pricePerLiter : pricePerLiter // ignore: cast_nullable_to_non_nullable
as double,effectiveFrom: null == effectiveFrom ? _self.effectiveFrom : effectiveFrom // ignore: cast_nullable_to_non_nullable
as DateTime,effectiveTo: freezed == effectiveTo ? _self.effectiveTo : effectiveTo // ignore: cast_nullable_to_non_nullable
as DateTime?,region: null == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
