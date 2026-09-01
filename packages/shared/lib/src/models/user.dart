import 'package:freezed_annotation/freezed_annotation.dart';
import '../enums/user_role.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    required String phone,
    String? email,
    String? name,
    String? avatarUrl,
    @Default(UserRole.customer) UserRole role,
    @Default(false) bool isVerified,
    @Default(true) bool isActive,
    @Default(false) bool isSuspended,
    @Default(false) bool mfaEnabled,
    @Default(false) bool biometricEnabled,
    String? deviceFingerprint,
    DateTime? lastLoginAt,
    DateTime? suspendedUntil,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

@freezed
abstract class UserCreateRequest with _$UserCreateRequest {
  const factory UserCreateRequest({
    required String phone,
    String? email,
    String? name,
  }) = _UserCreateRequest;

  factory UserCreateRequest.fromJson(Map<String, dynamic> json) =>
      _$UserCreateRequestFromJson(json);
}

@freezed
abstract class UserUpdateRequest with _$UserUpdateRequest {
  const factory UserUpdateRequest({
    String? name,
    String? email,
    String? avatarUrl,
  }) = _UserUpdateRequest;

  factory UserUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$UserUpdateRequestFromJson(json);
}