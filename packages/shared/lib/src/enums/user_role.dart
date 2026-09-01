import 'package:json_annotation/json_annotation.dart';


@JsonEnum(fieldRename: FieldRename.snake)
enum UserRole {
  @JsonValue('customer')
  customer,

  @JsonValue('driver')
  driver,

  @JsonValue('admin')
  admin,

  @JsonValue('super_admin')
  superAdmin,
}