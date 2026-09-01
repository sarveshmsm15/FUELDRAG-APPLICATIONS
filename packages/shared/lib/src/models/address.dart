import 'package:freezed_annotation/freezed_annotation.dart';

part 'address.freezed.dart';
part 'address.g.dart';

@freezed
abstract class Address with _$Address {
  const factory Address({
    required String id,
    required String userId,
    required String label,
    required String line1,
    String? line2,
    required String city,
    required String state,
    required String pincode,
    required double latitude,
    required double longitude,
    @Default(false) bool isDefault,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Address;

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);
}

@freezed
abstract class AddressCreateRequest with _$AddressCreateRequest {
  const factory AddressCreateRequest({
    required String label,
    required String line1,
    String? line2,
    required String city,
    required String state,
    required String pincode,
    required double latitude,
    required double longitude,
    @Default(false) bool isDefault,
  }) = _AddressCreateRequest;

  factory AddressCreateRequest.fromJson(Map<String, dynamic> json) =>
      _$AddressCreateRequestFromJson(json);
}