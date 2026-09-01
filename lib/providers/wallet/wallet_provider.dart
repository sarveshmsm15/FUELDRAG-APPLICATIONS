import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/wallet_repository.dart';

final walletRepositoryProvider = Provider<WalletRepository>((ref) => WalletRepository());

final walletProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final repo = ref.watch(walletRepositoryProvider);
  return repo.getWallet();
});