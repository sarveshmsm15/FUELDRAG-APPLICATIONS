import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  static const _brown = Color(0xFF5C3A1E);
  static const _brownLight = Color(0xFF8B6342);
  static const _brownDark = Color(0xFF3E2210);
  static const _glass = Color(0x40FFFFFF);
  static const _glassBorder = Color(0x60FFFFFF);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity, height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [Color(0xFFF8F0E8), Color(0xFFEDE0D4), Color(0xFFF5EDE4), Color(0xFFE8D5C4)],
          stops: [0.0, 0.3, 0.7, 1.0]),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Wallet', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: _brownDark)).animate().fadeIn(),
              const SizedBox(height: 4),
              Text('Manage your balance', style: TextStyle(fontSize: 14, color: _brownLight.withValues(alpha: 0.7))).animate().fadeIn(delay: 100.ms),
              const SizedBox(height: 24),

              // Balance card
              ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [_brown.withValues(alpha: 0.15), _brownLight.withValues(alpha: 0.1)]),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: _glassBorder, width: 1),
                    ),
                    child: Column(children: [
                      Text('Available Balance', style: TextStyle(fontSize: 14, color: _brownLight.withValues(alpha: 0.7))),
                      const SizedBox(height: 8),
                      const Text('₹5,000.00', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800, color: _brownDark)),
                      const SizedBox(height: 16),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                        _actionBtn(Icons.add_rounded, 'Add Money', _brown),
                        _actionBtn(Icons.send_rounded, 'Send', _brownLight),
                        _actionBtn(Icons.history_rounded, 'History', _brownLight),
                      ]),
                    ]),
                  ),
                ),
              ).animate().fadeIn(delay: 200.ms).scale(begin: const Offset(0.95, 0.95)),

              const SizedBox(height: 24),
              Text('Recent Transactions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _brownDark)).animate().fadeIn(delay: 300.ms),
              const SizedBox(height: 12),

              Expanded(
                child: ListView.builder(
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    final txns = [
                      {'title': 'Petrol Delivery', 'amount': '-₹1,312', 'date': 'Today', 'icon': Icons.local_gas_station_rounded, 'color': const Color(0xFFFF1744)},
                      {'title': 'Wallet Top-up', 'amount': '+₹2,000', 'date': 'Yesterday', 'icon': Icons.account_balance_wallet_rounded, 'color': const Color(0xFF00C853)},
                      {'title': 'Diesel Delivery', 'amount': '-₹2,134', 'date': '2 days ago', 'icon': Icons.local_shipping_rounded, 'color': const Color(0xFFFF1744)},
                      {'title': 'Refund', 'amount': '+₹500', 'date': '3 days ago', 'icon': Icons.replay_rounded, 'color': const Color(0xFF00C853)},
                    ];
                    final t = txns[index];
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(color: _glass, borderRadius: BorderRadius.circular(16), border: Border.all(color: _glassBorder, width: 1)),
                          child: Row(children: [
                            Container(
                              width: 40, height: 40,
                              decoration: BoxDecoration(color: (t['color'] as Color).withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                              child: Icon(t['icon'] as IconData, color: t['color'] as Color, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(t['title'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _brownDark)),
                              Text(t['date'] as String, style: TextStyle(fontSize: 11, color: _brownLight.withValues(alpha: 0.5))),
                            ])),
                            Text(t['amount'] as String, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: t['color'] as Color)),
                          ]),
                        ),
                      ),
                    ).animate().fadeIn(delay: (300 + index * 80).ms);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionBtn(IconData icon, String label, Color color) {
    return Column(children: [
      Container(
        width: 48, height: 48,
        decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(14)),
        child: Icon(icon, color: color, size: 22),
      ),
      const SizedBox(height: 6),
      Text(label, style: TextStyle(fontSize: 11, color: _brownLight.withValues(alpha: 0.7))),
    ]);
  }
}
