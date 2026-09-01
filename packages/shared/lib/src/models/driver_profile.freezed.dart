// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'driver_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DriverProfile {

 String get id; String get userId; String get licenseNumber; DateTime get licenseExpiry; String get vehicleType; double get tankerCapacityLiters; double? get currentLatitude; double? get currentLongitude; bool get isAvailable; bool get isOnDelivery; double get rating; int get totalDeliveries; bool get kycVerified; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of DriverProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DriverProfileCopyWith<DriverProfile> get copyWith => _$DriverProfileCopyWithImpl<DriverProfile>(this as DriverProfile, _$identity);

  /// Serializes this DriverProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DriverProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.licenseNumber, licenseNumber) || other.licenseNumber == licenseNumber)&&(identical(other.licenseExpiry, licenseExpiry) || other.licenseExpiry == licenseExpiry)&&(identical(other.vehicleType, vehicleType) || other.vehicleType == vehicleType)&&(identical(other.tankerCapacityLiters, tankerCapacityLiters) || other.tankerCapacityLiters == tankerCapacityLiters)&&(identical(other.currentLatitude, currentLatitude) || other.currentLatitude == currentLatitude)&&(identical(other.currentLongitude, currentLongitude) || other.currentLongitude == currentLongitude)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&(identical(other.isOnDelivery, isOnDelivery) || other.isOnDelivery == isOnDelivery)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.totalDeliveries, totalDeliveries) || other.totalDeliveries == totalDeliveries)&&(identical(other.kycVerified, kycVerified) || other.kycVerified == kycVerified)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,licenseNumber,licenseExpiry,vehicleType,tankerCapacityLiters,currentLatitude,currentLongitude,isAvailable,isOnDelivery,rating,totalDeliveries,kycVerified,createdAt,updatedAt);

@override
String toString() {
  return 'DriverProfile(id: $id, userId: $userId, licenseNumber: $licenseNumber, licenseExpiry: $licenseExpiry, vehicleType: $vehicleType, tankerCapacityLiters: $tankerCapacityLiters, currentLatitude: $currentLatitude, currentLongitude: $currentLongitude, isAvailable: $isAvailable, isOnDelivery: $isOnDelivery, rating: $rating, totalDeliveries: $totalDeliveries, kycVerified: $kycVerified, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $DriverProfileCopyWith<$Res>  {
  factory $DriverProfileCopyWith(DriverProfile value, $Res Function(DriverProfile) _then) = _$DriverProfileCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String licenseNumber, DateTime licenseExpiry, String vehicleType, double tankerCapacityLiters, double? currentLatitude, double? currentLongitude, bool isAvailable, bool isOnDelivery, double rating, int totalDeliveries, bool kycVerified, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$DriverProfileCopyWithImpl<$Res>
    implements $DriverProfileCopyWith<$Res> {
  _$DriverProfileCopyWithImpl(this._self, this._then);

  final DriverProfile _self;
  final $Res Function(DriverProfile) _then;

/// Create a copy of DriverProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? licenseNumber = null,Object? licenseExpiry = null,Object? vehicleType = null,Object? tankerCapacityLiters = null,Object? currentLatitude = freezed,Object? currentLongitude = freezed,Object? isAvailable = null,Object? isOnDelivery = null,Object? rating = null,Object? totalDeliveries = null,Object? kycVerified = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,licenseNumber: null == licenseNumber ? _self.licenseNumber : licenseNumber // ignore: cast_nullable_to_non_nullable
as String,licenseExpiry: null == licenseExpiry ? _self.licenseExpiry : licenseExpiry // ignore: cast_nullable_to_non_nullable
as DateTime,vehicleType: null == vehicleType ? _self.vehicleType : vehicleType // ignore: cast_nullable_to_non_nullable
as String,tankerCapacityLiters: null == tankerCapacityLiters ? _self.tankerCapacityLiters : tankerCapacityLiters // ignore: cast_nullable_to_non_nullable
as double,currentLatitude: freezed == currentLatitude ? _self.currentLatitude : currentLatitude // ignore: cast_nullable_to_non_nullable
as double?,currentLongitude: freezed == currentLongitude ? _self.currentLongitude : currentLongitude // ignore: cast_nullable_to_non_nullable
as double?,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,isOnDelivery: null == isOnDelivery ? _self.isOnDelivery : isOnDelivery // ignore: cast_nullable_to_non_nullable
as bool,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,totalDeliveries: null == totalDeliveries ? _self.totalDeliveries : totalDeliveries // ignore: cast_nullable_to_non_nullable
as int,kycVerified: null == kycVerified ? _self.kycVerified : kycVerified // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [DriverProfile].
extension DriverProfilePatterns on DriverProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DriverProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DriverProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DriverProfile value)  $default,){
final _that = this;
switch (_that) {
case _DriverProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DriverProfile value)?  $default,){
final _that = this;
switch (_that) {
case _DriverProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String licenseNumber,  DateTime licenseExpiry,  String vehicleType,  double tankerCapacityLiters,  double? currentLatitude,  double? currentLongitude,  bool isAvailable,  bool isOnDelivery,  double rating,  int totalDeliveries,  bool kycVerified,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DriverProfile() when $default != null:
return $default(_that.id,_that.userId,_that.licenseNumber,_that.licenseExpiry,_that.vehicleType,_that.tankerCapacityLiters,_that.currentLatitude,_that.currentLongitude,_that.isAvailable,_that.isOnDelivery,_that.rating,_that.totalDeliveries,_that.kycVerified,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String licenseNumber,  DateTime licenseExpiry,  String vehicleType,  double tankerCapacityLiters,  double? currentLatitude,  double? currentLongitude,  bool isAvailable,  bool isOnDelivery,  double rating,  int totalDeliveries,  bool kycVerified,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _DriverProfile():
return $default(_that.id,_that.userId,_that.licenseNumber,_that.licenseExpiry,_that.vehicleType,_that.tankerCapacityLiters,_that.currentLatitude,_that.currentLongitude,_that.isAvailable,_that.isOnDelivery,_that.rating,_that.totalDeliveries,_that.kycVerified,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String licenseNumber,  DateTime licenseExpiry,  String vehicleType,  double tankerCapacityLiters,  double? currentLatitude,  double? currentLongitude,  bool isAvailable,  bool isOnDelivery,  double rating,  int totalDeliveries,  bool kycVerified,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _DriverProfile() when $default != null:
return $default(_that.id,_that.userId,_that.licenseNumber,_that.licenseExpiry,_that.vehicleType,_that.tankerCapacityLiters,_that.currentLatitude,_that.currentLongitude,_that.isAvailable,_that.isOnDelivery,_that.rating,_that.totalDeliveries,_that.kycVerified,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DriverProfile implements DriverProfile {
  const _DriverProfile({required this.id, required this.userId, required this.licenseNumber, required this.licenseExpiry, required this.vehicleType, required this.tankerCapacityLiters, this.currentLatitude, this.currentLongitude, this.isAvailable = true, this.isOnDelivery = false, this.rating = 5.0, this.totalDeliveries = 0, this.kycVerified = false, required this.createdAt, required this.updatedAt});
  factory _DriverProfile.fromJson(Map<String, dynamic> json) => _$DriverProfileFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String licenseNumber;
@override final  DateTime licenseExpiry;
@override final  String vehicleType;
@override final  double tankerCapacityLiters;
@override final  double? currentLatitude;
@override final  double? currentLongitude;
@override@JsonKey() final  bool isAvailable;
@override@JsonKey() final  bool isOnDelivery;
@override@JsonKey() final  double rating;
@override@JsonKey() final  int totalDeliveries;
@override@JsonKey() final  bool kycVerified;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of DriverProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DriverProfileCopyWith<_DriverProfile> get copyWith => __$DriverProfileCopyWithImpl<_DriverProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DriverProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DriverProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.licenseNumber, licenseNumber) || other.licenseNumber == licenseNumber)&&(identical(other.licenseExpiry, licenseExpiry) || other.licenseExpiry == licenseExpiry)&&(identical(other.vehicleType, vehicleType) || other.vehicleType == vehicleType)&&(identical(other.tankerCapacityLiters, tankerCapacityLiters) || other.tankerCapacityLiters == tankerCapacityLiters)&&(identical(other.currentLatitude, currentLatitude) || other.currentLatitude == currentLatitude)&&(identical(other.currentLongitude, currentLongitude) || other.currentLongitude == currentLongitude)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&(identical(other.isOnDelivery, isOnDelivery) || other.isOnDelivery == isOnDelivery)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.totalDeliveries, totalDeliveries) || other.totalDeliveries == totalDeliveries)&&(identical(other.kycVerified, kycVerified) || other.kycVerified == kycVerified)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,licenseNumber,licenseExpiry,vehicleType,tankerCapacityLiters,currentLatitude,currentLongitude,isAvailable,isOnDelivery,rating,totalDeliveries,kycVerified,createdAt,updatedAt);

@override
String toString() {
  return 'DriverProfile(id: $id, userId: $userId, licenseNumber: $licenseNumber, licenseExpiry: $licenseExpiry, vehicleType: $vehicleType, tankerCapacityLiters: $tankerCapacityLiters, currentLatitude: $currentLatitude, currentLongitude: $currentLongitude, isAvailable: $isAvailable, isOnDelivery: $isOnDelivery, rating: $rating, totalDeliveries: $totalDeliveries, kycVerified: $kycVerified, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$DriverProfileCopyWith<$Res> implements $DriverProfileCopyWith<$Res> {
  factory _$DriverProfileCopyWith(_DriverProfile value, $Res Function(_DriverProfile) _then) = __$DriverProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String licenseNumber, DateTime licenseExpiry, String vehicleType, double tankerCapacityLiters, double? currentLatitude, double? currentLongitude, bool isAvailable, bool isOnDelivery, double rating, int totalDeliveries, bool kycVerified, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$DriverProfileCopyWithImpl<$Res>
    implements _$DriverProfileCopyWith<$Res> {
  __$DriverProfileCopyWithImpl(this._self, this._then);

  final _DriverProfile _self;
  final $Res Function(_DriverProfile) _then;

/// Create a copy of DriverProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? licenseNumber = null,Object? licenseExpiry = null,Object? vehicleType = null,Object? tankerCapacityLiters = null,Object? currentLatitude = freezed,Object? currentLongitude = freezed,Object? isAvailable = null,Object? isOnDelivery = null,Object? rating = null,Object? totalDeliveries = null,Object? kycVerified = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_DriverProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,licenseNumber: null == licenseNumber ? _self.licenseNumber : licenseNumber // ignore: cast_nullable_to_non_nullable
as String,licenseExpiry: null == licenseExpiry ? _self.licenseExpiry : licenseExpiry // ignore: cast_nullable_to_non_nullable
as DateTime,vehicleType: null == vehicleType ? _self.vehicleType : vehicleType // ignore: cast_nullable_to_non_nullable
as String,tankerCapacityLiters: null == tankerCapacityLiters ? _self.tankerCapacityLiters : tankerCapacityLiters // ignore: cast_nullable_to_non_nullable
as double,currentLatitude: freezed == currentLatitude ? _self.currentLatitude : currentLatitude // ignore: cast_nullable_to_non_nullable
as double?,currentLongitude: freezed == currentLongitude ? _self.currentLongitude : currentLongitude // ignore: cast_nullable_to_non_nullable
as double?,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,isOnDelivery: null == isOnDelivery ? _self.isOnDelivery : isOnDelivery // ignore: cast_nullable_to_non_nullable
as bool,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,totalDeliveries: null == totalDeliveries ? _self.totalDeliveries : totalDeliveries // ignore: cast_nullable_to_non_nullable
as int,kycVerified: null == kycVerified ? _self.kycVerified : kycVerified // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
