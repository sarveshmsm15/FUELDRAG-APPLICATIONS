import 'package:freezed_annotation/freezed_annotation.dart';
import '../enums/transaction_type.dart';

part 'wallet_transaction.freezed.dart';
part 'wallet_transaction.g.dart';

@freezed
abstract class WalletTransaction with _$WalletTransaction {
  const factory WalletTransaction({
    required String id,
    required String walletId,
    required String userId,
    required TransactionType type,
    required double amount,
    required double balanceAfter,
    required String description,
    String? referenceId,
    Map<String, dynamic>? metadata,
    required DateTime createdAt,
  }) = _WalletTransaction;

  factory WalletTransaction.fromJson(Map<String, dynamic> json) =>
      _$WalletTransactionFromJson(json);
}