import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  static const _brown = Color(0xFF5C3A1E);
  static const _brownLight = Color(0xFF8B6342);
  static const _brownDark = Color(0xFF3E2210);
  static const _glass = Color(0x40FFFFFF);
  static const _glassBorder = Color(0x60FFFFFF);

  @override
  Widget build(BuildContext context) {
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
              const Text('History', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: _brownDark)).animate().fadeIn(),
              const SizedBox(height: 4),
              Text('Your delivery history', style: TextStyle(fontSize: 14, color: _brownLight.withValues(alpha: 0.7))).animate().fadeIn(delay: 100.ms),
              const SizedBox(height: 24),

              // Stats row
              Row(children: [
                _statCard('Total Orders', '12', Icons.receipt_long_rounded, const Color(0xFF448AFF)),
                const SizedBox(width: 12),
                _statCard('Total Spent', '₹15.2K', Icons.currency_rupee_rounded, const Color(0xFF00C853)),
                const SizedBox(width: 12),
                _statCard('Saved', '₹1.8K', Icons.savings_rounded, const Color(0xFFFF6B35)),
              ]).animate().fadeIn(delay: 200.ms),

              const SizedBox(height: 24),
              Text('Past Deliveries', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _brownDark)).animate().fadeIn(delay: 300.ms),
              const SizedBox(height: 12),

              Expanded(
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    final items = [
                      {'fuel': 'Petrol', 'qty': '10L', 'total': '₹1,312', 'date': 'Sep 1, 2026'},
                      {'fuel': 'Diesel', 'qty': '20L', 'total': '₹2,134', 'date': 'Aug 30, 2026'},
                      {'fuel': 'CNG', 'qty': '15L', 'total': '₹1,293', 'date': 'Aug 28, 2026'},
                      {'fuel': 'Petrol', 'qty': '5L', 'total': '₹681', 'date': 'Aug 25, 2026'},
                      {'fuel': 'EV Charge', 'qty': '30U', 'total': '₹255', 'date': 'Aug 22, 2026'},
                    ];
                    final item = items[index];
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
                              decoration: BoxDecoration(color: _brown.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                              child: const Icon(Icons.check_circle_rounded, color: Color(0xFF00C853), size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text('${item['fuel']} • ${item['qty']}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _brownDark)),
                              Text(item['date'] as String, style: TextStyle(fontSize: 11, color: _brownLight.withValues(alpha: 0.5))),
                            ])),
                            Text(item['total'] as String, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: _brownDark)),
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

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: _glass, borderRadius: BorderRadius.circular(16), border: Border.all(color: _glassBorder, width: 1)),
            child: Column(children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(height: 6),
              Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: _brownDark)),
              Text(label, style: TextStyle(fontSize: 10, color: _brownLight.withValues(alpha: 0.6))),
            ]),
          ),
        ),
      ),
    );
  }
}
