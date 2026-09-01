// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vehicle.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Vehicle {

 String get id; String get userId; String get registrationNumber; String get make; String get model; int? get year; FuelType get fuelType; double? get tankCapacityLiters; String? get color; bool get isDefault; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of Vehicle
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VehicleCopyWith<Vehicle> get copyWith => _$VehicleCopyWithImpl<Vehicle>(this as Vehicle, _$identity);

  /// Serializes this Vehicle to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Vehicle&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.registrationNumber, registrationNumber) || other.registrationNumber == registrationNumber)&&(identical(other.make, make) || other.make == make)&&(identical(other.model, model) || other.model == model)&&(identical(other.year, year) || other.year == year)&&(identical(other.fuelType, fuelType) || other.fuelType == fuelType)&&(identical(other.tankCapacityLiters, tankCapacityLiters) || other.tankCapacityLiters == tankCapacityLiters)&&(identical(other.color, color) || other.color == color)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,registrationNumber,make,model,year,fuelType,tankCapacityLiters,color,isDefault,createdAt,updatedAt);

@override
String toString() {
  return 'Vehicle(id: $id, userId: $userId, registrationNumber: $registrationNumber, make: $make, model: $model, year: $year, fuelType: $fuelType, tankCapacityLiters: $tankCapacityLiters, color: $color, isDefault: $isDefault, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $VehicleCopyWith<$Res>  {
  factory $VehicleCopyWith(Vehicle value, $Res Function(Vehicle) _then) = _$VehicleCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String registrationNumber, String make, String model, int? year, FuelType fuelType, double? tankCapacityLiters, String? color, bool isDefault, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$VehicleCopyWithImpl<$Res>
    implements $VehicleCopyWith<$Res> {
  _$VehicleCopyWithImpl(this._self, this._then);

  final Vehicle _self;
  final $Res Function(Vehicle) _then;

/// Create a copy of Vehicle
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? registrationNumber = null,Object? make = null,Object? model = null,Object? year = freezed,Object? fuelType = null,Object? tankCapacityLiters = freezed,Object? color = freezed,Object? isDefault = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,registrationNumber: null == registrationNumber ? _self.registrationNumber : registrationNumber // ignore: cast_nullable_to_non_nullable
as String,make: null == make ? _self.make : make // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,fuelType: null == fuelType ? _self.fuelType : fuelType // ignore: cast_nullable_to_non_nullable
as FuelType,tankCapacityLiters: freezed == tankCapacityLiters ? _self.tankCapacityLiters : tankCapacityLiters // ignore: cast_nullable_to_non_nullable
as double?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Vehicle].
extension VehiclePatterns on Vehicle {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Vehicle value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Vehicle() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Vehicle value)  $default,){
final _that = this;
switch (_that) {
case _Vehicle():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Vehicle value)?  $default,){
final _that = this;
switch (_that) {
case _Vehicle() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String registrationNumber,  String make,  String model,  int? year,  FuelType fuelType,  double? tankCapacityLiters,  String? color,  bool isDefault,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Vehicle() when $default != null:
return $default(_that.id,_that.userId,_that.registrationNumber,_that.make,_that.model,_that.year,_that.fuelType,_that.tankCapacityLiters,_that.color,_that.isDefault,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String registrationNumber,  String make,  String model,  int? year,  FuelType fuelType,  double? tankCapacityLiters,  String? color,  bool isDefault,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Vehicle():
return $default(_that.id,_that.userId,_that.registrationNumber,_that.make,_that.model,_that.year,_that.fuelType,_that.tankCapacityLiters,_that.color,_that.isDefault,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String registrationNumber,  String make,  String model,  int? year,  FuelType fuelType,  double? tankCapacityLiters,  String? color,  bool isDefault,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Vehicle() when $default != null:
return $default(_that.id,_that.userId,_that.registrationNumber,_that.make,_that.model,_that.year,_that.fuelType,_that.tankCapacityLiters,_that.color,_that.isDefault,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Vehicle implements Vehicle {
  const _Vehicle({required this.id, required this.userId, required this.registrationNumber, required this.make, required this.model, this.year, required this.fuelType, this.tankCapacityLiters, this.color, this.isDefault = false, required this.createdAt, required this.updatedAt});
  factory _Vehicle.fromJson(Map<String, dynamic> json) => _$VehicleFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String registrationNumber;
@override final  String make;
@override final  String model;
@override final  int? year;
@override final  FuelType fuelType;
@override final  double? tankCapacityLiters;
@override final  String? color;
@override@JsonKey() final  bool isDefault;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of Vehicle
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VehicleCopyWith<_Vehicle> get copyWith => __$VehicleCopyWithImpl<_Vehicle>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VehicleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Vehicle&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.registrationNumber, registrationNumber) || other.registrationNumber == registrationNumber)&&(identical(other.make, make) || other.make == make)&&(identical(other.model, model) || other.model == model)&&(identical(other.year, year) || other.year == year)&&(identical(other.fuelType, fuelType) || other.fuelType == fuelType)&&(identical(other.tankCapacityLiters, tankCapacityLiters) || other.tankCapacityLiters == tankCapacityLiters)&&(identical(other.color, color) || other.color == color)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,registrationNumber,make,model,year,fuelType,tankCapacityLiters,color,isDefault,createdAt,updatedAt);

@override
String toString() {
  return 'Vehicle(id: $id, userId: $userId, registrationNumber: $registrationNumber, make: $make, model: $model, year: $year, fuelType: $fuelType, tankCapacityLiters: $tankCapacityLiters, color: $color, isDefault: $isDefault, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$VehicleCopyWith<$Res> implements $VehicleCopyWith<$Res> {
  factory _$VehicleCopyWith(_Vehicle value, $Res Function(_Vehicle) _then) = __$VehicleCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String registrationNumber, String make, String model, int? year, FuelType fuelType, double? tankCapacityLiters, String? color, bool isDefault, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$VehicleCopyWithImpl<$Res>
    implements _$VehicleCopyWith<$Res> {
  __$VehicleCopyWithImpl(this._self, this._then);

  final _Vehicle _self;
  final $Res Function(_Vehicle) _then;

/// Create a copy of Vehicle
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? registrationNumber = null,Object? make = null,Object? model = null,Object? year = freezed,Object? fuelType = null,Object? tankCapacityLiters = freezed,Object? color = freezed,Object? isDefault = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Vehicle(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,registrationNumber: null == registrationNumber ? _self.registrationNumber : registrationNumber // ignore: cast_nullable_to_non_nullable
as String,make: null == make ? _self.make : make // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,fuelType: null == fuelType ? _self.fuelType : fuelType // ignore: cast_nullable_to_non_nullable
as FuelType,tankCapacityLiters: freezed == tankCapacityLiters ? _self.tankCapacityLiters : tankCapacityLiters // ignore: cast_nullable_to_non_nullable
as double?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$VehicleCreateRequest {

 String get registrationNumber; String get make; String get model; int? get year; FuelType get fuelType; double? get tankCapacityLiters; String? get color; bool get isDefault;
/// Create a copy of VehicleCreateRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VehicleCreateRequestCopyWith<VehicleCreateRequest> get copyWith => _$VehicleCreateRequestCopyWithImpl<VehicleCreateRequest>(this as VehicleCreateRequest, _$identity);

  /// Serializes this VehicleCreateRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VehicleCreateRequest&&(identical(other.registrationNumber, registrationNumber) || other.registrationNumber == registrationNumber)&&(identical(other.make, make) || other.make == make)&&(identical(other.model, model) || other.model == model)&&(identical(other.year, year) || other.year == year)&&(identical(other.fuelType, fuelType) || other.fuelType == fuelType)&&(identical(other.tankCapacityLiters, tankCapacityLiters) || other.tankCapacityLiters == tankCapacityLiters)&&(identical(other.color, color) || other.color == color)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,registrationNumber,make,model,year,fuelType,tankCapacityLiters,color,isDefault);

@override
String toString() {
  return 'VehicleCreateRequest(registrationNumber: $registrationNumber, make: $make, model: $model, year: $year, fuelType: $fuelType, tankCapacityLiters: $tankCapacityLiters, color: $color, isDefault: $isDefault)';
}


}

/// @nodoc
abstract mixin class $VehicleCreateRequestCopyWith<$Res>  {
  factory $VehicleCreateRequestCopyWith(VehicleCreateRequest value, $Res Function(VehicleCreateRequest) _then) = _$VehicleCreateRequestCopyWithImpl;
@useResult
$Res call({
 String registrationNumber, String make, String model, int? year, FuelType fuelType, double? tankCapacityLiters, String? color, bool isDefault
});




}
/// @nodoc
class _$VehicleCreateRequestCopyWithImpl<$Res>
    implements $VehicleCreateRequestCopyWith<$Res> {
  _$VehicleCreateRequestCopyWithImpl(this._self, this._then);

  final VehicleCreateRequest _self;
  final $Res Function(VehicleCreateRequest) _then;

/// Create a copy of VehicleCreateRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? registrationNumber = null,Object? make = null,Object? model = null,Object? year = freezed,Object? fuelType = null,Object? tankCapacityLiters = freezed,Object? color = freezed,Object? isDefault = null,}) {
  return _then(_self.copyWith(
registrationNumber: null == registrationNumber ? _self.registrationNumber : registrationNumber // ignore: cast_nullable_to_non_nullable
as String,make: null == make ? _self.make : make // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,fuelType: null == fuelType ? _self.fuelType : fuelType // ignore: cast_nullable_to_non_nullable
as FuelType,tankCapacityLiters: freezed == tankCapacityLiters ? _self.tankCapacityLiters : tankCapacityLiters // ignore: cast_nullable_to_non_nullable
as double?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [VehicleCreateRequest].
extension VehicleCreateRequestPatterns on VehicleCreateRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VehicleCreateRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VehicleCreateRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VehicleCreateRequest value)  $default,){
final _that = this;
switch (_that) {
case _VehicleCreateRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VehicleCreateRequest value)?  $default,){
final _that = this;
switch (_that) {
case _VehicleCreateRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String registrationNumber,  String make,  String model,  int? year,  FuelType fuelType,  double? tankCapacityLiters,  String? color,  bool isDefault)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VehicleCreateRequest() when $default != null:
return $default(_that.registrationNumber,_that.make,_that.model,_that.year,_that.fuelType,_that.tankCapacityLiters,_that.color,_that.isDefault);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String registrationNumber,  String make,  String model,  int? year,  FuelType fuelType,  double? tankCapacityLiters,  String? color,  bool isDefault)  $default,) {final _that = this;
switch (_that) {
case _VehicleCreateRequest():
return $default(_that.registrationNumber,_that.make,_that.model,_that.year,_that.fuelType,_that.tankCapacityLiters,_that.color,_that.isDefault);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String registrationNumber,  String make,  String model,  int? year,  FuelType fuelType,  double? tankCapacityLiters,  String? color,  bool isDefault)?  $default,) {final _that = this;
switch (_that) {
case _VehicleCreateRequest() when $default != null:
return $default(_that.registrationNumber,_that.make,_that.model,_that.year,_that.fuelType,_that.tankCapacityLiters,_that.color,_that.isDefault);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VehicleCreateRequest implements VehicleCreateRequest {
  const _VehicleCreateRequest({required this.registrationNumber, required this.make, required this.model, this.year, required this.fuelType, this.tankCapacityLiters, this.color, this.isDefault = false});
  factory _VehicleCreateRequest.fromJson(Map<String, dynamic> json) => _$VehicleCreateRequestFromJson(json);

@override final  String registrationNumber;
@override final  String make;
@override final  String model;
@override final  int? year;
@override final  FuelType fuelType;
@override final  double? tankCapacityLiters;
@override final  String? color;
@override@JsonKey() final  bool isDefault;

/// Create a copy of VehicleCreateRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VehicleCreateRequestCopyWith<_VehicleCreateRequest> get copyWith => __$VehicleCreateRequestCopyWithImpl<_VehicleCreateRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VehicleCreateRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VehicleCreateRequest&&(identical(other.registrationNumber, registrationNumber) || other.registrationNumber == registrationNumber)&&(identical(other.make, make) || other.make == make)&&(identical(other.model, model) || other.model == model)&&(identical(other.year, year) || other.year == year)&&(identical(other.fuelType, fuelType) || other.fuelType == fuelType)&&(identical(other.tankCapacityLiters, tankCapacityLiters) || other.tankCapacityLiters == tankCapacityLiters)&&(identical(other.color, color) || other.color == color)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,registrationNumber,make,model,year,fuelType,tankCapacityLiters,color,isDefault);

@override
String toString() {
  return 'VehicleCreateRequest(registrationNumber: $registrationNumber, make: $make, model: $model, year: $year, fuelType: $fuelType, tankCapacityLiters: $tankCapacityLiters, color: $color, isDefault: $isDefault)';
}


}

/// @nodoc
abstract mixin class _$VehicleCreateRequestCopyWith<$Res> implements $VehicleCreateRequestCopyWith<$Res> {
  factory _$VehicleCreateRequestCopyWith(_VehicleCreateRequest value, $Res Function(_VehicleCreateRequest) _then) = __$VehicleCreateRequestCopyWithImpl;
@override @useResult
$Res call({
 String registrationNumber, String make, String model, int? year, FuelType fuelType, double? tankCapacityLiters, String? color, bool isDefault
});




}
/// @nodoc
class __$VehicleCreateRequestCopyWithImpl<$Res>
    implements _$VehicleCreateRequestCopyWith<$Res> {
  __$VehicleCreateRequestCopyWithImpl(this._self, this._then);

  final _VehicleCreateRequest _self;
  final $Res Function(_VehicleCreateRequest) _then;

/// Create a copy of VehicleCreateRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? registrationNumber = null,Object? make = null,Object? model = null,Object? year = freezed,Object? fuelType = null,Object? tankCapacityLiters = freezed,Object? color = freezed,Object? isDefault = null,}) {
  return _then(_VehicleCreateRequest(
registrationNumber: null == registrationNumber ? _self.registrationNumber : registrationNumber // ignore: cast_nullable_to_non_nullable
as String,make: null == make ? _self.make : make // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,fuelType: null == fuelType ? _self.fuelType : fuelType // ignore: cast_nullable_to_non_nullable
as FuelType,tankCapacityLiters: freezed == tankCapacityLiters ? _self.tankCapacityLiters : tankCapacityLiters // ignore: cast_nullable_to_non_nullable
as double?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
