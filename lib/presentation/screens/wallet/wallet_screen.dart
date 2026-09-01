import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../providers/wallet/wallet_provider.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletAsync = ref.watch(walletProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back
              GestureDetector(
                onTap: () => context.pop(),
                child: Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.white.withValues(alpha: 0.6), size: 20),
              ),
              const SizedBox(height: 16),

              const Text('My Wallet',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white),
              ).animate().fadeIn(),

              const SizedBox(height: 24),

              // Balance card
              walletAsync.when(
                loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFFFF6B35))),
                error: (_, __) => Center(
                  child: Text('Failed to load wallet',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.5))),
                ),
                data: (wallet) {
                  final balance = (wallet?['balance'] as num?)?.toDouble() ?? 0;
                  final transactions = (wallet?['transactions'] as List?)?.cast<Map<String, dynamic>>() ?? [];

                  return Expanded(
                    child: Column(
                      children: [
                        // Balance
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFFFF6B35).withValues(alpha: 0.3),
                                    const Color(0xFFFF6B35).withValues(alpha: 0.1),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: const Color(0xFFFF6B35).withValues(alpha: 0.3)),
                              ),
                              child: Column(
                                children: [
                                  Text('Available Balance',
                                      style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 14)),
                                  const SizedBox(height: 8),
                                  Text('₹${balance.toStringAsFixed(2)}',
                                      style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w700, color: Color(0xFF00C853))),
                                  const SizedBox(height: 16),
                                  GestureDetector(
                                    onTap: () async {
                                      final repo = ref.read(walletRepositoryProvider);
                                      await repo.addMoney(1000);
                                      ref.invalidate(walletProvider);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFF6B35).withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: const Color(0xFFFF6B35).withValues(alpha: 0.4)),
                                      ),
                                      child: const Text('+ Add ₹1,000',
                                          style: TextStyle(color: Color(0xFFFF6B35), fontWeight: FontWeight.w600)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ).animate().fadeIn(delay: 100.ms).scale(begin: const Offset(0.95, 0.95)),

                        const SizedBox(height: 24),

                        // Transactions
                        Text('Recent Transactions',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                        const SizedBox(height: 12),

                        Expanded(
                          child: transactions.isEmpty
                              ? Center(
                                  child: Text('No transactions yet',
                                      style: TextStyle(color: Colors.white.withValues(alpha: 0.3))))
                              : ListView.builder(
                                  itemCount: transactions.length,
                                  itemBuilder: (context, index) {
                                    final tx = transactions[index];
                                    final isDebit = tx['type'] == 'debit';
                                    final amount = (tx['amount'] as num).toDouble();

                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                                        child: Container(
                                          margin: const EdgeInsets.only(bottom: 8),
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                          decoration: BoxDecoration(
                                            color: const Color(0x14FFFFFF),
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(color: const Color(0x1AFFFFFF)),
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 36, height: 36,
                                                decoration: BoxDecoration(
                                                  color: (isDebit ? const Color(0xFFFF1744) : const Color(0xFF00C853))
                                                      .withValues(alpha: 0.15),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Icon(
                                                  isDebit ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                                                  color: isDebit ? const Color(0xFFFF1744) : const Color(0xFF00C853),
                                                  size: 18,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(tx['description'] ?? 'Transaction',
                                                        style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                                                        maxLines: 1, overflow: TextOverflow.ellipsis),
                                                    Text('Balance: ₹${(tx['balanceAfter'] as num).toStringAsFixed(2)}',
                                                        style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 11)),
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                '${isDebit ? "-" : "+"}₹${amount.toStringAsFixed(2)}',
                                                style: TextStyle(
                                                  color: isDebit ? const Color(0xFFFF1744) : const Color(0xFF00C853),
                                                  fontWeight: FontWeight.w600, fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ).animate().fadeIn(delay: (200 + index * 50).ms);
                                  },
                                ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              Center(
                child: Text('Phase 7 — Payments & Wallet ✓',
                    style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.2))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}