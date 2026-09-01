import 'package:json_annotation/json_annotation.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum TransactionType {
  @JsonValue('credit')
  credit,

  @JsonValue('debit')
  debit,

  @JsonValue('refund')
  refund,

  @JsonValue('bonus')
  bonus,

  @JsonValue('penalty')
  penalty,
}