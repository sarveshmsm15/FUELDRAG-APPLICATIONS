import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../providers/admin/admin_provider.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashAsync = ref.watch(adminDashboardProvider);
    final revAsync = ref.watch(adminRevenueProvider);
    final statusAsync = ref.watch(adminOrdersByStatusProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Admin Dashboard', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white)).animate().fadeIn(),
                      Text('Business Overview', style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.5))).animate().fadeIn(delay: 100.ms),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(color: const Color(0xFFFF6B35).withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.close_rounded, color: Color(0xFFFF6B35), size: 18),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Stats cards
              dashAsync.when(
                loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFFFF6B35))),
                error: (e, _) => Text('Error: $e', style: const TextStyle(color: Color(0xFFFF1744))),
                data: (dash) {
                  final orders = dash['orders'] as Map<String, dynamic>;
                  final revenue = dash['revenue'] as Map<String, dynamic>;
                  final users = dash['users'] as Map<String, dynamic>;
                  final drivers = dash['drivers'] as Map<String, dynamic>;

                  return Column(children: [
                    Row(children: [
                      Expanded(child: _statCard('Total Orders', '${orders['total']}', Icons.receipt_long_rounded, const Color(0xFFFF6B35))),
                      const SizedBox(width: 10),
                      Expanded(child: _statCard('Today', '${orders['today']}', Icons.today_rounded, const Color(0xFF448AFF))),
                    ]),
                    const SizedBox(height: 10),
                    Row(children: [
                      Expanded(child: _statCard('Revenue Today', '\u20b9${(revenue['today'] as num).toStringAsFixed(0)}', Icons.currency_rupee_rounded, const Color(0xFF00C853))),
                      const SizedBox(width: 10),
                      Expanded(child: _statCard('Active', '${orders['active']}', Icons.local_shipping_rounded, const Color(0xFFFFD600))),
                    ]),
                    const SizedBox(height: 10),
                    Row(children: [
                      Expanded(child: _statCard('Users', '${users['total']}', Icons.people_rounded, const Color(0xFFAB47BC))),
                      const SizedBox(width: 10),
                      Expanded(child: _statCard('Drivers', '${drivers['active']}/${drivers['total']}', Icons.directions_car_rounded, const Color(0xFF00BCD4))),
                    ]),
                  ]);
                },
              ),

              const SizedBox(height: 24),

              // Revenue chart
              const Text('Revenue (Last 30 Days)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)).animate().fadeIn(delay: 300.ms),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                  child: Container(
                    height: 200,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: const Color(0x14FFFFFF), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0x1AFFFFFF))),
                    child: revAsync.when(
                      loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFFF6B35))),
                      error: (_, __) => const Center(child: Text('No data', style: TextStyle(color: Colors.white54))),
                      data: (data) {
                        if (data.isEmpty) return const Center(child: Text('No completed orders yet', style: TextStyle(color: Colors.white54)));
                        final spots = data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), (e.value['revenue'] as num).toDouble())).toList();
                        final maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b) * 1.2;
                        return LineChart(LineChartData(
                          gridData: const FlGridData(show: false),
                          titlesData: const FlTitlesData(show: false),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [LineChartBarData(
                            spots: spots, isCurved: true, color: const Color(0xFFFF6B35), barWidth: 3,
                            dotData: const FlDotData(show: false),
                            belowBarData: BarAreaData(show: true, color: const Color(0xFFFF6B35).withValues(alpha: 0.15)),
                          )],
                          minY: 0, maxY: maxY > 0 ? maxY : 100,
                        ));
                      },
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 400.ms),

              const SizedBox(height: 24),

              // Orders by status pie
              const Text('Orders by Status', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)).animate().fadeIn(delay: 500.ms),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                  child: Container(
                    height: 200,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: const Color(0x14FFFFFF), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0x1AFFFFFF))),
                    child: statusAsync.when(
                      loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFFF6B35))),
                      error: (_, __) => const Center(child: Text('No data', style: TextStyle(color: Colors.white54))),
                      data: (data) {
                        if (data.isEmpty) return const Center(child: Text('No orders yet', style: TextStyle(color: Colors.white54)));
                        final colors = [const Color(0xFFFF6B35), const Color(0xFF448AFF), const Color(0xFF00C853), const Color(0xFFFFD600), const Color(0xFFFF1744), const Color(0xFFAB47BC)];
                        return Row(children: [
                          SizedBox(width: 120, height: 120, child: PieChart(PieChartData(
                            sections: data.asMap().entries.map((e) => PieChartSectionData(
                              value: (e.value['count'] as num).toDouble(),
                              color: colors[e.key % colors.length],
                              title: '${e.value['status']}',
                              titleStyle: const TextStyle(fontSize: 8, color: Colors.white),
                              radius: 50,
                            )).toList(),
                            centerSpaceRadius: 30,
                            sectionsSpace: 2,
                          ))),
                          const SizedBox(width: 16),
                          Expanded(child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: data.asMap().entries.map((e) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(children: [
                                Container(width: 10, height: 10, decoration: BoxDecoration(color: colors[e.key % colors.length], shape: BoxShape.circle)),
                                const SizedBox(width: 6),
                                Text('${e.value['status']}: ${e.value['count']}', style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 11)),
                              ]),
                            )).toList(),
                          )),
                        ]);
                      },
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 600.ms),

              const SizedBox(height: 16),
              Center(child: Text('Phase 9 \u2014 Admin Dashboard \u2713', style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.2)))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: const Color(0x14FFFFFF), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0x1AFFFFFF))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: color)),
            Text(label, style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.5))),
          ]),
        ),
      ),
    ).animate().fadeIn(delay: 200.ms).scale(begin: const Offset(0.95, 0.95));
  }
}
