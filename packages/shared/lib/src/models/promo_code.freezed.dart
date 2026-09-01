// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'promo_code.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PromoCode {

 String get id; String get code; String get description; String get discountType; double get discountValue; double get minOrderAmount; double? get maxDiscount; int? get usageLimit; int get usageCount; DateTime get validFrom; DateTime get validUntil; bool get isActive; DateTime get createdAt;
/// Create a copy of PromoCode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PromoCodeCopyWith<PromoCode> get copyWith => _$PromoCodeCopyWithImpl<PromoCode>(this as PromoCode, _$identity);

  /// Serializes this PromoCode to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PromoCode&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.description, description) || other.description == description)&&(identical(other.discountType, discountType) || other.discountType == discountType)&&(identical(other.discountValue, discountValue) || other.discountValue == discountValue)&&(identical(other.minOrderAmount, minOrderAmount) || other.minOrderAmount == minOrderAmount)&&(identical(other.maxDiscount, maxDiscount) || other.maxDiscount == maxDiscount)&&(identical(other.usageLimit, usageLimit) || other.usageLimit == usageLimit)&&(identical(other.usageCount, usageCount) || other.usageCount == usageCount)&&(identical(other.validFrom, validFrom) || other.validFrom == validFrom)&&(identical(other.validUntil, validUntil) || other.validUntil == validUntil)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,description,discountType,discountValue,minOrderAmount,maxDiscount,usageLimit,usageCount,validFrom,validUntil,isActive,createdAt);

@override
String toString() {
  return 'PromoCode(id: $id, code: $code, description: $description, discountType: $discountType, discountValue: $discountValue, minOrderAmount: $minOrderAmount, maxDiscount: $maxDiscount, usageLimit: $usageLimit, usageCount: $usageCount, validFrom: $validFrom, validUntil: $validUntil, isActive: $isActive, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $PromoCodeCopyWith<$Res>  {
  factory $PromoCodeCopyWith(PromoCode value, $Res Function(PromoCode) _then) = _$PromoCodeCopyWithImpl;
@useResult
$Res call({
 String id, String code, String description, String discountType, double discountValue, double minOrderAmount, double? maxDiscount, int? usageLimit, int usageCount, DateTime validFrom, DateTime validUntil, bool isActive, DateTime createdAt
});




}
/// @nodoc
class _$PromoCodeCopyWithImpl<$Res>
    implements $PromoCodeCopyWith<$Res> {
  _$PromoCodeCopyWithImpl(this._self, this._then);

  final PromoCode _self;
  final $Res Function(PromoCode) _then;

/// Create a copy of PromoCode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? description = null,Object? discountType = null,Object? discountValue = null,Object? minOrderAmount = null,Object? maxDiscount = freezed,Object? usageLimit = freezed,Object? usageCount = null,Object? validFrom = null,Object? validUntil = null,Object? isActive = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,discountType: null == discountType ? _self.discountType : discountType // ignore: cast_nullable_to_non_nullable
as String,discountValue: null == discountValue ? _self.discountValue : discountValue // ignore: cast_nullable_to_non_nullable
as double,minOrderAmount: null == minOrderAmount ? _self.minOrderAmount : minOrderAmount // ignore: cast_nullable_to_non_nullable
as double,maxDiscount: freezed == maxDiscount ? _self.maxDiscount : maxDiscount // ignore: cast_nullable_to_non_nullable
as double?,usageLimit: freezed == usageLimit ? _self.usageLimit : usageLimit // ignore: cast_nullable_to_non_nullable
as int?,usageCount: null == usageCount ? _self.usageCount : usageCount // ignore: cast_nullable_to_non_nullable
as int,validFrom: null == validFrom ? _self.validFrom : validFrom // ignore: cast_nullable_to_non_nullable
as DateTime,validUntil: null == validUntil ? _self.validUntil : validUntil // ignore: cast_nullable_to_non_nullable
as DateTime,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [PromoCode].
extension PromoCodePatterns on PromoCode {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PromoCode value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PromoCode() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PromoCode value)  $default,){
final _that = this;
switch (_that) {
case _PromoCode():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PromoCode value)?  $default,){
final _that = this;
switch (_that) {
case _PromoCode() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String code,  String description,  String discountType,  double discountValue,  double minOrderAmount,  double? maxDiscount,  int? usageLimit,  int usageCount,  DateTime validFrom,  DateTime validUntil,  bool isActive,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PromoCode() when $default != null:
return $default(_that.id,_that.code,_that.description,_that.discountType,_that.discountValue,_that.minOrderAmount,_that.maxDiscount,_that.usageLimit,_that.usageCount,_that.validFrom,_that.validUntil,_that.isActive,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String code,  String description,  String discountType,  double discountValue,  double minOrderAmount,  double? maxDiscount,  int? usageLimit,  int usageCount,  DateTime validFrom,  DateTime validUntil,  bool isActive,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _PromoCode():
return $default(_that.id,_that.code,_that.description,_that.discountType,_that.discountValue,_that.minOrderAmount,_that.maxDiscount,_that.usageLimit,_that.usageCount,_that.validFrom,_that.validUntil,_that.isActive,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String code,  String description,  String discountType,  double discountValue,  double minOrderAmount,  double? maxDiscount,  int? usageLimit,  int usageCount,  DateTime validFrom,  DateTime validUntil,  bool isActive,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _PromoCode() when $default != null:
return $default(_that.id,_that.code,_that.description,_that.discountType,_that.discountValue,_that.minOrderAmount,_that.maxDiscount,_that.usageLimit,_that.usageCount,_that.validFrom,_that.validUntil,_that.isActive,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PromoCode implements PromoCode {
  const _PromoCode({required this.id, required this.code, required this.description, required this.discountType, required this.discountValue, this.minOrderAmount = 0, this.maxDiscount, this.usageLimit, this.usageCount = 0, required this.validFrom, required this.validUntil, this.isActive = true, required this.createdAt});
  factory _PromoCode.fromJson(Map<String, dynamic> json) => _$PromoCodeFromJson(json);

@override final  String id;
@override final  String code;
@override final  String description;
@override final  String discountType;
@override final  double discountValue;
@override@JsonKey() final  double minOrderAmount;
@override final  double? maxDiscount;
@override final  int? usageLimit;
@override@JsonKey() final  int usageCount;
@override final  DateTime validFrom;
@override final  DateTime validUntil;
@override@JsonKey() final  bool isActive;
@override final  DateTime createdAt;

/// Create a copy of PromoCode
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PromoCodeCopyWith<_PromoCode> get copyWith => __$PromoCodeCopyWithImpl<_PromoCode>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PromoCodeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PromoCode&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.description, description) || other.description == description)&&(identical(other.discountType, discountType) || other.discountType == discountType)&&(identical(other.discountValue, discountValue) || other.discountValue == discountValue)&&(identical(other.minOrderAmount, minOrderAmount) || other.minOrderAmount == minOrderAmount)&&(identical(other.maxDiscount, maxDiscount) || other.maxDiscount == maxDiscount)&&(identical(other.usageLimit, usageLimit) || other.usageLimit == usageLimit)&&(identical(other.usageCount, usageCount) || other.usageCount == usageCount)&&(identical(other.validFrom, validFrom) || other.validFrom == validFrom)&&(identical(other.validUntil, validUntil) || other.validUntil == validUntil)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,description,discountType,discountValue,minOrderAmount,maxDiscount,usageLimit,usageCount,validFrom,validUntil,isActive,createdAt);

@override
String toString() {
  return 'PromoCode(id: $id, code: $code, description: $description, discountType: $discountType, discountValue: $discountValue, minOrderAmount: $minOrderAmount, maxDiscount: $maxDiscount, usageLimit: $usageLimit, usageCount: $usageCount, validFrom: $validFrom, validUntil: $validUntil, isActive: $isActive, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$PromoCodeCopyWith<$Res> implements $PromoCodeCopyWith<$Res> {
  factory _$PromoCodeCopyWith(_PromoCode value, $Res Function(_PromoCode) _then) = __$PromoCodeCopyWithImpl;
@override @useResult
$Res call({
 String id, String code, String description, String discountType, double discountValue, double minOrderAmount, double? maxDiscount, int? usageLimit, int usageCount, DateTime validFrom, DateTime validUntil, bool isActive, DateTime createdAt
});




}
/// @nodoc
class __$PromoCodeCopyWithImpl<$Res>
    implements _$PromoCodeCopyWith<$Res> {
  __$PromoCodeCopyWithImpl(this._self, this._then);

  final _PromoCode _self;
  final $Res Function(_PromoCode) _then;

/// Create a copy of PromoCode
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? description = null,Object? discountType = null,Object? discountValue = null,Object? minOrderAmount = null,Object? maxDiscount = freezed,Object? usageLimit = freezed,Object? usageCount = null,Object? validFrom = null,Object? validUntil = null,Object? isActive = null,Object? createdAt = null,}) {
  return _then(_PromoCode(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,discountType: null == discountType ? _self.discountType : discountType // ignore: cast_nullable_to_non_nullable
as String,discountValue: null == discountValue ? _self.discountValue : discountValue // ignore: cast_nullable_to_non_nullable
as double,minOrderAmount: null == minOrderAmount ? _self.minOrderAmount : minOrderAmount // ignore: cast_nullable_to_non_nullable
as double,maxDiscount: freezed == maxDiscount ? _self.maxDiscount : maxDiscount // ignore: cast_nullable_to_non_nullable
as double?,usageLimit: freezed == usageLimit ? _self.usageLimit : usageLimit // ignore: cast_nullable_to_non_nullable
as int?,usageCount: null == usageCount ? _self.usageCount : usageCount // ignore: cast_nullable_to_non_nullable
as int,validFrom: null == validFrom ? _self.validFrom : validFrom // ignore: cast_nullable_to_non_nullable
as DateTime,validUntil: null == validUntil ? _self.validUntil : validUntil // ignore: cast_nullable_to_non_nullable
as DateTime,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
