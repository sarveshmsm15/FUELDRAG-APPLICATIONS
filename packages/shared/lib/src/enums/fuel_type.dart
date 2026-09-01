import 'package:json_annotation/json_annotation.dart';

/// Fuel types matching PostgreSQL enum values exactly.
@JsonEnum(fieldRename: FieldRename.snake)
enum FuelType {
  @JsonValue('petrol')
  petrol,

  @JsonValue('diesel')
  diesel,

  @JsonValue('cng')
  cng,

  @JsonValue('ev_charge')
  evCharge,
}