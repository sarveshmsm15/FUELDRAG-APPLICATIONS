import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../providers/auth/auth_provider.dart';
import '../../../providers/fuel/fuel_provider.dart';
import '../../../providers/order/order_provider.dart';
import '../../../services/notifications/notification_service.dart';
import '../../navigation/app_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final userName =
        authState is AuthAuthenticated ? (authState.name ?? 'User') : 'User';
    final fuelRatesAsync = ref.watch(fuelRatesProvider);
    final unreadCount = ref.watch(appNotificationsProvider).where((n) => !n.isRead).length;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, $userName \u{1F44B}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ).animate().fadeIn(duration: 400.ms),
                      Text(
                        'What fuel do you need today?',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                      ).animate().fadeIn(delay: 100.ms),
                    ],
                  ),
                  Row(
                    children: [
                      // Admin button
                      GestureDetector(
                        onTap: () => context.push(RouteNames.admin),
                        child: Container(
                          width: 36,
                          height: 36,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFAB47BC).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.admin_panel_settings_rounded,
                            color: Color(0xFFAB47BC),
                            size: 18,
                          ),
                        ),
                      ),
                      // Notification bell with badge
                      GestureDetector(
                        onTap: () => context.push(RouteNames.notifications),
                        child: Stack(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF6B35).withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.notifications_outlined,
                                color: Color(0xFFFF6B35),
                                size: 18,
                              ),
                            ),
                            if (unreadCount > 0)
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFF1744),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),

              const Text(
                'Select Fuel Type',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ).animate().fadeIn(delay: 200.ms),

              const SizedBox(height: 12),

              // Fuel cards
              SizedBox(
                height: 280,
                child: fuelRatesAsync.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: Color(0xFFFF6B35)),
                  ),
                  error: (_, __) => Center(
                    child: Text(
                      'Failed to load rates',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                    ),
                  ),
                  data: (rates) => GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: rates.map((rate) {
                      final type = rate['fuelType'] as String;
                      final price = (rate['pricePerLiter'] as num).toDouble();
                      return _fuelCard(context, ref, type, price);
                    }).toList(),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Wallet Card
              InkWell(
                onTap: () {
                  debugPrint('Wallet tapped!');
                  context.push(RouteNames.wallet);
                },
                borderRadius: BorderRadius.circular(16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0x14FFFFFF),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0x1AFFFFFF)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Wallet Balance',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withValues(alpha: 0.5),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                '\u20b95,000.00',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF00C853),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF6B35).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFFF6B35).withValues(alpha: 0.3),
                              ),
                            ),
                            child: const Text(
                              '+ Add Money',
                              style: TextStyle(
                                color: Color(0xFFFF6B35),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.2),

              const SizedBox(height: 8),

              Center(
                child: Text(
                  'Phase 11 \u2014 Notifications \u2713',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fuelCard(
    BuildContext context,
    WidgetRef ref,
    String type,
    double price,
  ) {
    final config = _fuelConfig(type);

    return GestureDetector(
      onTap: () {
        ref.read(selectedFuelTypeProvider.notifier).set(type);
        context.push(RouteNames.orderFlow);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0x14FFFFFF),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0x1AFFFFFF)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: config.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(config.icon, color: config.color, size: 24),
                ),
                const SizedBox(height: 10),
                Text(
                  config.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\u20b9${price.toStringAsFixed(2)}/L',
                  style: TextStyle(
                    color: config.color.withValues(alpha: 0.8),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: 300.ms).scale(begin: const Offset(0.9, 0.9));
  }

  _FuelConfig _fuelConfig(String type) {
    switch (type) {
      case 'petrol':
        return _FuelConfig(
          'Petrol',
          Icons.local_gas_station_rounded,
          const Color(0xFFFF6B35),
        );
      case 'diesel':
        return _FuelConfig(
          'Diesel',
          Icons.local_shipping_rounded,
          const Color(0xFFFFD600),
        );
      case 'cng':
        return _FuelConfig(
          'CNG',
          Icons.ac_unit_rounded,
          const Color(0xFF00C853),
        );
      case 'ev_charge':
        return _FuelConfig(
          'EV Charge',
          Icons.electric_car_rounded,
          const Color(0xFF448AFF),
        );
      default:
        return _FuelConfig(type, Icons.help_outline, Colors.grey);
    }
  }
}

class _FuelConfig {
  final String label;
  final IconData icon;
  final Color color;

  const _FuelConfig(this.label, this.icon, this.color);
}
