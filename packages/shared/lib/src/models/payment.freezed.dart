// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Payment {

 String get id; String get orderId; String get userId; PaymentMethod get method; PaymentStatus get status; double get amount; String get currency; String? get gatewayTxnId; Map<String, dynamic>? get gatewayResponse; String get idempotencyKey; String? get failureReason; DateTime get initiatedAt; DateTime? get completedAt; DateTime? get refundedAt; double? get refundAmount;
/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentCopyWith<Payment> get copyWith => _$PaymentCopyWithImpl<Payment>(this as Payment, _$identity);

  /// Serializes this Payment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Payment&&(identical(other.id, id) || other.id == id)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.method, method) || other.method == method)&&(identical(other.status, status) || other.status == status)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.gatewayTxnId, gatewayTxnId) || other.gatewayTxnId == gatewayTxnId)&&const DeepCollectionEquality().equals(other.gatewayResponse, gatewayResponse)&&(identical(other.idempotencyKey, idempotencyKey) || other.idempotencyKey == idempotencyKey)&&(identical(other.failureReason, failureReason) || other.failureReason == failureReason)&&(identical(other.initiatedAt, initiatedAt) || other.initiatedAt == initiatedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.refundedAt, refundedAt) || other.refundedAt == refundedAt)&&(identical(other.refundAmount, refundAmount) || other.refundAmount == refundAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orderId,userId,method,status,amount,currency,gatewayTxnId,const DeepCollectionEquality().hash(gatewayResponse),idempotencyKey,failureReason,initiatedAt,completedAt,refundedAt,refundAmount);

@override
String toString() {
  return 'Payment(id: $id, orderId: $orderId, userId: $userId, method: $method, status: $status, amount: $amount, currency: $currency, gatewayTxnId: $gatewayTxnId, gatewayResponse: $gatewayResponse, idempotencyKey: $idempotencyKey, failureReason: $failureReason, initiatedAt: $initiatedAt, completedAt: $completedAt, refundedAt: $refundedAt, refundAmount: $refundAmount)';
}


}

/// @nodoc
abstract mixin class $PaymentCopyWith<$Res>  {
  factory $PaymentCopyWith(Payment value, $Res Function(Payment) _then) = _$PaymentCopyWithImpl;
@useResult
$Res call({
 String id, String orderId, String userId, PaymentMethod method, PaymentStatus status, double amount, String currency, String? gatewayTxnId, Map<String, dynamic>? gatewayResponse, String idempotencyKey, String? failureReason, DateTime initiatedAt, DateTime? completedAt, DateTime? refundedAt, double? refundAmount
});




}
/// @nodoc
class _$PaymentCopyWithImpl<$Res>
    implements $PaymentCopyWith<$Res> {
  _$PaymentCopyWithImpl(this._self, this._then);

  final Payment _self;
  final $Res Function(Payment) _then;

/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orderId = null,Object? userId = null,Object? method = null,Object? status = null,Object? amount = null,Object? currency = null,Object? gatewayTxnId = freezed,Object? gatewayResponse = freezed,Object? idempotencyKey = null,Object? failureReason = freezed,Object? initiatedAt = null,Object? completedAt = freezed,Object? refundedAt = freezed,Object? refundAmount = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as PaymentMethod,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PaymentStatus,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,gatewayTxnId: freezed == gatewayTxnId ? _self.gatewayTxnId : gatewayTxnId // ignore: cast_nullable_to_non_nullable
as String?,gatewayResponse: freezed == gatewayResponse ? _self.gatewayResponse : gatewayResponse // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,idempotencyKey: null == idempotencyKey ? _self.idempotencyKey : idempotencyKey // ignore: cast_nullable_to_non_nullable
as String,failureReason: freezed == failureReason ? _self.failureReason : failureReason // ignore: cast_nullable_to_non_nullable
as String?,initiatedAt: null == initiatedAt ? _self.initiatedAt : initiatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,refundedAt: freezed == refundedAt ? _self.refundedAt : refundedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,refundAmount: freezed == refundAmount ? _self.refundAmount : refundAmount // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [Payment].
extension PaymentPatterns on Payment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Payment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Payment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Payment value)  $default,){
final _that = this;
switch (_that) {
case _Payment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Payment value)?  $default,){
final _that = this;
switch (_that) {
case _Payment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String orderId,  String userId,  PaymentMethod method,  PaymentStatus status,  double amount,  String currency,  String? gatewayTxnId,  Map<String, dynamic>? gatewayResponse,  String idempotencyKey,  String? failureReason,  DateTime initiatedAt,  DateTime? completedAt,  DateTime? refundedAt,  double? refundAmount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Payment() when $default != null:
return $default(_that.id,_that.orderId,_that.userId,_that.method,_that.status,_that.amount,_that.currency,_that.gatewayTxnId,_that.gatewayResponse,_that.idempotencyKey,_that.failureReason,_that.initiatedAt,_that.completedAt,_that.refundedAt,_that.refundAmount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String orderId,  String userId,  PaymentMethod method,  PaymentStatus status,  double amount,  String currency,  String? gatewayTxnId,  Map<String, dynamic>? gatewayResponse,  String idempotencyKey,  String? failureReason,  DateTime initiatedAt,  DateTime? completedAt,  DateTime? refundedAt,  double? refundAmount)  $default,) {final _that = this;
switch (_that) {
case _Payment():
return $default(_that.id,_that.orderId,_that.userId,_that.method,_that.status,_that.amount,_that.currency,_that.gatewayTxnId,_that.gatewayResponse,_that.idempotencyKey,_that.failureReason,_that.initiatedAt,_that.completedAt,_that.refundedAt,_that.refundAmount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String orderId,  String userId,  PaymentMethod method,  PaymentStatus status,  double amount,  String currency,  String? gatewayTxnId,  Map<String, dynamic>? gatewayResponse,  String idempotencyKey,  String? failureReason,  DateTime initiatedAt,  DateTime? completedAt,  DateTime? refundedAt,  double? refundAmount)?  $default,) {final _that = this;
switch (_that) {
case _Payment() when $default != null:
return $default(_that.id,_that.orderId,_that.userId,_that.method,_that.status,_that.amount,_that.currency,_that.gatewayTxnId,_that.gatewayResponse,_that.idempotencyKey,_that.failureReason,_that.initiatedAt,_that.completedAt,_that.refundedAt,_that.refundAmount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Payment implements Payment {
  const _Payment({required this.id, required this.orderId, required this.userId, required this.method, this.status = PaymentStatus.pending, required this.amount, this.currency = 'INR', this.gatewayTxnId, final  Map<String, dynamic>? gatewayResponse, required this.idempotencyKey, this.failureReason, required this.initiatedAt, this.completedAt, this.refundedAt, this.refundAmount}): _gatewayResponse = gatewayResponse;
  factory _Payment.fromJson(Map<String, dynamic> json) => _$PaymentFromJson(json);

@override final  String id;
@override final  String orderId;
@override final  String userId;
@override final  PaymentMethod method;
@override@JsonKey() final  PaymentStatus status;
@override final  double amount;
@override@JsonKey() final  String currency;
@override final  String? gatewayTxnId;
 final  Map<String, dynamic>? _gatewayResponse;
@override Map<String, dynamic>? get gatewayResponse {
  final value = _gatewayResponse;
  if (value == null) return null;
  if (_gatewayResponse is EqualUnmodifiableMapView) return _gatewayResponse;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  String idempotencyKey;
@override final  String? failureReason;
@override final  DateTime initiatedAt;
@override final  DateTime? completedAt;
@override final  DateTime? refundedAt;
@override final  double? refundAmount;

/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentCopyWith<_Payment> get copyWith => __$PaymentCopyWithImpl<_Payment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Payment&&(identical(other.id, id) || other.id == id)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.method, method) || other.method == method)&&(identical(other.status, status) || other.status == status)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.gatewayTxnId, gatewayTxnId) || other.gatewayTxnId == gatewayTxnId)&&const DeepCollectionEquality().equals(other._gatewayResponse, _gatewayResponse)&&(identical(other.idempotencyKey, idempotencyKey) || other.idempotencyKey == idempotencyKey)&&(identical(other.failureReason, failureReason) || other.failureReason == failureReason)&&(identical(other.initiatedAt, initiatedAt) || other.initiatedAt == initiatedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.refundedAt, refundedAt) || other.refundedAt == refundedAt)&&(identical(other.refundAmount, refundAmount) || other.refundAmount == refundAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orderId,userId,method,status,amount,currency,gatewayTxnId,const DeepCollectionEquality().hash(_gatewayResponse),idempotencyKey,failureReason,initiatedAt,completedAt,refundedAt,refundAmount);

@override
String toString() {
  return 'Payment(id: $id, orderId: $orderId, userId: $userId, method: $method, status: $status, amount: $amount, currency: $currency, gatewayTxnId: $gatewayTxnId, gatewayResponse: $gatewayResponse, idempotencyKey: $idempotencyKey, failureReason: $failureReason, initiatedAt: $initiatedAt, completedAt: $completedAt, refundedAt: $refundedAt, refundAmount: $refundAmount)';
}


}

/// @nodoc
abstract mixin class _$PaymentCopyWith<$Res> implements $PaymentCopyWith<$Res> {
  factory _$PaymentCopyWith(_Payment value, $Res Function(_Payment) _then) = __$PaymentCopyWithImpl;
@override @useResult
$Res call({
 String id, String orderId, String userId, PaymentMethod method, PaymentStatus status, double amount, String currency, String? gatewayTxnId, Map<String, dynamic>? gatewayResponse, String idempotencyKey, String? failureReason, DateTime initiatedAt, DateTime? completedAt, DateTime? refundedAt, double? refundAmount
});




}
/// @nodoc
class __$PaymentCopyWithImpl<$Res>
    implements _$PaymentCopyWith<$Res> {
  __$PaymentCopyWithImpl(this._self, this._then);

  final _Payment _self;
  final $Res Function(_Payment) _then;

/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orderId = null,Object? userId = null,Object? method = null,Object? status = null,Object? amount = null,Object? currency = null,Object? gatewayTxnId = freezed,Object? gatewayResponse = freezed,Object? idempotencyKey = null,Object? failureReason = freezed,Object? initiatedAt = null,Object? completedAt = freezed,Object? refundedAt = freezed,Object? refundAmount = freezed,}) {
  return _then(_Payment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as PaymentMethod,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PaymentStatus,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,gatewayTxnId: freezed == gatewayTxnId ? _self.gatewayTxnId : gatewayTxnId // ignore: cast_nullable_to_non_nullable
as String?,gatewayResponse: freezed == gatewayResponse ? _self._gatewayResponse : gatewayResponse // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,idempotencyKey: null == idempotencyKey ? _self.idempotencyKey : idempotencyKey // ignore: cast_nullable_to_non_nullable
as String,failureReason: freezed == failureReason ? _self.failureReason : failureReason // ignore: cast_nullable_to_non_nullable
as String?,initiatedAt: null == initiatedAt ? _self.initiatedAt : initiatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,refundedAt: freezed == refundedAt ? _self.refundedAt : refundedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,refundAmount: freezed == refundAmount ? _self.refundAmount : refundAmount // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$PaymentInitiateRequest {

 String get orderId; PaymentMethod get method; double get amount; String get idempotencyKey;
/// Create a copy of PaymentInitiateRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentInitiateRequestCopyWith<PaymentInitiateRequest> get copyWith => _$PaymentInitiateRequestCopyWithImpl<PaymentInitiateRequest>(this as PaymentInitiateRequest, _$identity);

  /// Serializes this PaymentInitiateRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentInitiateRequest&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.method, method) || other.method == method)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.idempotencyKey, idempotencyKey) || other.idempotencyKey == idempotencyKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,orderId,method,amount,idempotencyKey);

@override
String toString() {
  return 'PaymentInitiateRequest(orderId: $orderId, method: $method, amount: $amount, idempotencyKey: $idempotencyKey)';
}


}

/// @nodoc
abstract mixin class $PaymentInitiateRequestCopyWith<$Res>  {
  factory $PaymentInitiateRequestCopyWith(PaymentInitiateRequest value, $Res Function(PaymentInitiateRequest) _then) = _$PaymentInitiateRequestCopyWithImpl;
@useResult
$Res call({
 String orderId, PaymentMethod method, double amount, String idempotencyKey
});




}
/// @nodoc
class _$PaymentInitiateRequestCopyWithImpl<$Res>
    implements $PaymentInitiateRequestCopyWith<$Res> {
  _$PaymentInitiateRequestCopyWithImpl(this._self, this._then);

  final PaymentInitiateRequest _self;
  final $Res Function(PaymentInitiateRequest) _then;

/// Create a copy of PaymentInitiateRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? orderId = null,Object? method = null,Object? amount = null,Object? idempotencyKey = null,}) {
  return _then(_self.copyWith(
orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as PaymentMethod,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,idempotencyKey: null == idempotencyKey ? _self.idempotencyKey : idempotencyKey // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PaymentInitiateRequest].
extension PaymentInitiateRequestPatterns on PaymentInitiateRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentInitiateRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentInitiateRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentInitiateRequest value)  $default,){
final _that = this;
switch (_that) {
case _PaymentInitiateRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentInitiateRequest value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentInitiateRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String orderId,  PaymentMethod method,  double amount,  String idempotencyKey)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentInitiateRequest() when $default != null:
return $default(_that.orderId,_that.method,_that.amount,_that.idempotencyKey);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String orderId,  PaymentMethod method,  double amount,  String idempotencyKey)  $default,) {final _that = this;
switch (_that) {
case _PaymentInitiateRequest():
return $default(_that.orderId,_that.method,_that.amount,_that.idempotencyKey);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String orderId,  PaymentMethod method,  double amount,  String idempotencyKey)?  $default,) {final _that = this;
switch (_that) {
case _PaymentInitiateRequest() when $default != null:
return $default(_that.orderId,_that.method,_that.amount,_that.idempotencyKey);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaymentInitiateRequest implements PaymentInitiateRequest {
  const _PaymentInitiateRequest({required this.orderId, required this.method, required this.amount, required this.idempotencyKey});
  factory _PaymentInitiateRequest.fromJson(Map<String, dynamic> json) => _$PaymentInitiateRequestFromJson(json);

@override final  String orderId;
@override final  PaymentMethod method;
@override final  double amount;
@override final  String idempotencyKey;

/// Create a copy of PaymentInitiateRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentInitiateRequestCopyWith<_PaymentInitiateRequest> get copyWith => __$PaymentInitiateRequestCopyWithImpl<_PaymentInitiateRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentInitiateRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentInitiateRequest&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.method, method) || other.method == method)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.idempotencyKey, idempotencyKey) || other.idempotencyKey == idempotencyKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,orderId,method,amount,idempotencyKey);

@override
String toString() {
  return 'PaymentInitiateRequest(orderId: $orderId, method: $method, amount: $amount, idempotencyKey: $idempotencyKey)';
}


}

/// @nodoc
abstract mixin class _$PaymentInitiateRequestCopyWith<$Res> implements $PaymentInitiateRequestCopyWith<$Res> {
  factory _$PaymentInitiateRequestCopyWith(_PaymentInitiateRequest value, $Res Function(_PaymentInitiateRequest) _then) = __$PaymentInitiateRequestCopyWithImpl;
@override @useResult
$Res call({
 String orderId, PaymentMethod method, double amount, String idempotencyKey
});




}
/// @nodoc
class __$PaymentInitiateRequestCopyWithImpl<$Res>
    implements _$PaymentInitiateRequestCopyWith<$Res> {
  __$PaymentInitiateRequestCopyWithImpl(this._self, this._then);

  final _PaymentInitiateRequest _self;
  final $Res Function(_PaymentInitiateRequest) _then;

/// Create a copy of PaymentInitiateRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? orderId = null,Object? method = null,Object? amount = null,Object? idempotencyKey = null,}) {
  return _then(_PaymentInitiateRequest(
orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as PaymentMethod,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,idempotencyKey: null == idempotencyKey ? _self.idempotencyKey : idempotencyKey // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
