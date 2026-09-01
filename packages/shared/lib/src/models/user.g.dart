// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  id: json['id'] as String,
  phone: json['phone'] as String,
  email: json['email'] as String?,
  name: json['name'] as String?,
  avatarUrl: json['avatarUrl'] as String?,
  role:
      $enumDecodeNullable(_$UserRoleEnumMap, json['role']) ?? UserRole.customer,
  isVerified: json['isVerified'] as bool? ?? false,
  isActive: json['isActive'] as bool? ?? true,
  isSuspended: json['isSuspended'] as bool? ?? false,
  mfaEnabled: json['mfaEnabled'] as bool? ?? false,
  biometricEnabled: json['biometricEnabled'] as bool? ?? false,
  deviceFingerprint: json['deviceFingerprint'] as String?,
  lastLoginAt: json['lastLoginAt'] == null
      ? null
      : DateTime.parse(json['lastLoginAt'] as String),
  suspendedUntil: json['suspendedUntil'] == null
      ? null
      : DateTime.parse(json['suspendedUntil'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'id': instance.id,
  'phone': instance.phone,
  'email': instance.email,
  'name': instance.name,
  'avatarUrl': instance.avatarUrl,
  'role': _$UserRoleEnumMap[instance.role]!,
  'isVerified': instance.isVerified,
  'isActive': instance.isActive,
  'isSuspended': instance.isSuspended,
  'mfaEnabled': instance.mfaEnabled,
  'biometricEnabled': instance.biometricEnabled,
  'deviceFingerprint': instance.deviceFingerprint,
  'lastLoginAt': instance.lastLoginAt?.toIso8601String(),
  'suspendedUntil': instance.suspendedUntil?.toIso8601String(),
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

const _$UserRoleEnumMap = {
  UserRole.customer: 'customer',
  UserRole.driver: 'driver',
  UserRole.admin: 'admin',
  UserRole.superAdmin: 'super_admin',
};

_UserCreateRequest _$UserCreateRequestFromJson(Map<String, dynamic> json) =>
    _UserCreateRequest(
      phone: json['phone'] as String,
      email: json['email'] as String?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$UserCreateRequestToJson(_UserCreateRequest instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'email': instance.email,
      'name': instance.name,
    };

_UserUpdateRequest _$UserUpdateRequestFromJson(Map<String, dynamic> json) =>
    _UserUpdateRequest(
      name: json['name'] as String?,
      email: json['email'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
    );

Map<String, dynamic> _$UserUpdateRequestToJson(_UserUpdateRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'avatarUrl': instance.avatarUrl,
    };
