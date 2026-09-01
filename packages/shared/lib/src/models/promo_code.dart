import 'package:freezed_annotation/freezed_annotation.dart';

part 'promo_code.freezed.dart';
part 'promo_code.g.dart';

@freezed
abstract class PromoCode with _$PromoCode {
  const factory PromoCode({
    required String id,
    required String code,
    required String description,
    required String discountType,
    required double discountValue,
    @Default(0) double minOrderAmount,
    double? maxDiscount,
    int? usageLimit,
    @Default(0) int usageCount,
    required DateTime validFrom,
    required DateTime validUntil,
    @Default(true) bool isActive,
    required DateTime createdAt,
  }) = _PromoCode;

  factory PromoCode.fromJson(Map<String, dynamic> json) =>
      _$PromoCodeFromJson(json);
}