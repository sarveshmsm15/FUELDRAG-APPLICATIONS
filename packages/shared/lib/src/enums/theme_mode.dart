import 'package:json_annotation/json_annotation.dart';

/// App theme modes.
@JsonEnum(fieldRename: FieldRename.snake)
enum AppThemeMode {
  @JsonValue('onyx')
  onyx,

  @JsonValue('pearl')
  pearl,

  @JsonValue('system')
  system,
}