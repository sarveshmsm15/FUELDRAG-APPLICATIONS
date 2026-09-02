import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../providers/auth/auth_provider.dart';
import '../../../providers/fuel/fuel_provider.dart';
import '../../../providers/order/order_provider.dart';
import '../../../services/api/dio_client.dart';
import '../../navigation/app_router.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  static const _brown = Color(0xFF5C3A1E);
  static const _brownLight = Color(0xFF8B6342);
  static const _brownDark = Color(0xFF3E2210);
  static const _glass = Color(0x40FFFFFF);
  static const _glassBorder = Color(0x60FFFFFF);

  String _greeting = 'Good Evening';
  List<Map<String, dynamic>> _recentOrders = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _setGreeting();
    _loadData();
  }

  void _setGreeting() {
    final h = DateTime.now().hour;
    if (h < 12) _greeting = 'Good Morning';
    else if (h < 17) _greeting = 'Good Afternoon';
    else _greeting = 'Good Evening';
  }

  Future<void> _loadData() async {
    try {
      final res = await DioClient.instance.get('/orders');
      final data = (res.data as Map<String, dynamic>)['data'];
      if (data is List) {
        setState(() { _recentOrders = data.cast<Map<String, dynamic>>().take(3).toList(); });
      }
    } catch (_) {}
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final userName = authState is AuthAuthenticated ? (authState.name ?? 'User') : 'User';
    final fuelRatesAsync = ref.watch(fuelRatesProvider);

    return Scaffold(
      body: Container(
        width: double.infinity, height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [Color(0xFFF8F0E8), Color(0xFFEDE0D4), Color(0xFFF5EDE4), Color(0xFFE8D5C4)], stops: [0.0, 0.3, 0.7, 1.0]),
        ),
        child: Stack(
          children: [
            _bubble(top: -40, right: -30, size: 140, opacity: 0.10),
            _bubble(bottom: 200, left: -40, size: 120, opacity: 0.08),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    // Top bar: hamburger + notification bell
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _iconBtn(Icons.menu_rounded, () {}),
                        Stack(children: [
                          _iconBtn(Icons.notifications_outlined, () => context.go(RouteNames.notifications)),
                          Positioned(right: 2, top: 2, child: Container(width: 18, height: 18, decoration: const BoxDecoration(color: Color(0xFFFF6B35), shape: BoxShape.circle), child: const Center(child: Text('2', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700, decoration: TextDecoration.none))))),
                        ]),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Greeting + Wallet
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('$_greeting,', style: TextStyle(fontSize: 16, color: _brownLight.withValues(alpha: 0.7), decoration: TextDecoration.none)),
                          const SizedBox(height: 2),
                          Text(userName, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: _brownDark, decoration: TextDecoration.none)),
                        ])),
                        const SizedBox(width: 12),
                        // Wallet card
                        ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(colors: [_brownLight, _brown, _brownDark]),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Row(children: [
                                const Icon(Icons.account_balance_wallet_rounded, color: Colors.white70, size: 22),
                                const SizedBox(width: 10),
                                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text('Wallet Balance', style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.7), decoration: TextDecoration.none)),
                                  const Text('\u20b9500.00', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white, decoration: TextDecoration.none)),
                                ]),
                                const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () => context.go(RouteNames.wallet),
                                  child: Container(width: 28, height: 28, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle), child: const Icon(Icons.add_rounded, color: Colors.white, size: 18)),
                                ),
                              ]),
                            ),
                          ),
                        ),
                      ],
                    ).animate().fadeIn(delay: 100.ms),
                    const SizedBox(height: 20),

                    // Delivery address card
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(color: _glass, borderRadius: BorderRadius.circular(18), border: Border.all(color: _glassBorder)),
                          child: Row(children: [
                            Container(width: 40, height: 40, decoration: BoxDecoration(color: _brown.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.location_on_rounded, color: _brown, size: 20)),
                            const SizedBox(width: 12),
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text('Delivering to', style: TextStyle(fontSize: 12, color: _brownLight.withValues(alpha: 0.6), decoration: TextDecoration.none)),
                              const Text('Home', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _brownDark, decoration: TextDecoration.none)),
                              Row(children: [
                                Text('Anna Nagar, Chennai', style: TextStyle(fontSize: 13, color: _brownLight.withValues(alpha: 0.7), decoration: TextDecoration.none)),
                                const SizedBox(width: 4),
                                Icon(Icons.expand_more_rounded, size: 16, color: _brownLight.withValues(alpha: 0.5)),
                              ]),
                            ])),
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(color: _brown.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
                                child: Row(children: [
                                  Text('Change', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _brown, decoration: TextDecoration.none)),
                                  const SizedBox(width: 4),
                                  Icon(Icons.chevron_right_rounded, size: 16, color: _brown),
                                ]),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ).animate().fadeIn(delay: 200.ms),
                    const SizedBox(height: 24),

                    // Need Fuel in Minutes?
                    const Text('Need Fuel in Minutes?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: _brownDark, decoration: TextDecoration.none)),
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 100,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, i) {
                          final fuels = [
                            ('Petrol', Icons.local_gas_station_rounded, 'petrol'),
                            ('Diesel', Icons.local_gas_station_rounded, 'diesel'),
                            ('Puncture\nfor Tyre', Icons.build_circle_rounded, 'puncture'),
                          ];
                          final f = fuels[i];
                          return GestureDetector(
                            onTap: () {
                              if (f.$3 == 'puncture') {
                                context.push(RouteNames.puncture);
                              } else {
                                ref.read(selectedFuelTypeProvider.notifier).set(f.$3);
                                context.push(RouteNames.orderFlow);
                              }
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 90,
                              decoration: BoxDecoration(
                                color: i == 0 ? _brown.withValues(alpha: 0.08) : Colors.white.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: i == 0 ? _brown : _glassBorder, width: i == 0 ? 2 : 1),
                              ),
                              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                Icon(f.$2, color: i == 0 ? _brown : _brownLight.withValues(alpha: 0.5), size: 28),
                                const SizedBox(height: 6),
                                Text(f.$1, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: i == 0 ? _brownDark : _brownLight.withValues(alpha: 0.6), decoration: TextDecoration.none, height: 1.1)),
                              ]),
                            ),
                          );
                        },
                      ),
                    ).animate().fadeIn(delay: 300.ms),
                    const SizedBox(height: 24),

                    // Order Again
                    const Text('Order Again', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: _brownDark, decoration: TextDecoration.none)),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(color: _glass, borderRadius: BorderRadius.circular(18), border: Border.all(color: _glassBorder)),
                          child: Row(children: [
                            Container(width: 44, height: 44, decoration: BoxDecoration(color: _brown.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.local_gas_station_rounded, color: _brown, size: 22)),
                            const SizedBox(width: 12),
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              const Text('10L Petrol', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: _brownDark, decoration: TextDecoration.none)),
                              Text('Yesterday', style: TextStyle(fontSize: 12, color: _brownLight.withValues(alpha: 0.6), decoration: TextDecoration.none)),
                            ])),
                            GestureDetector(
                              onTap: () {
                                ref.read(selectedFuelTypeProvider.notifier).set('petrol');
                                context.push(RouteNames.orderFlow);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                decoration: BoxDecoration(gradient: const LinearGradient(colors: [_brownLight, _brown, _brownDark]), borderRadius: BorderRadius.circular(14)),
                                child: Row(children: [
                                  const Icon(Icons.refresh_rounded, color: Colors.white, size: 16),
                                  const SizedBox(width: 6),
                                  const Text('Order Again', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700, decoration: TextDecoration.none)),
                                ]),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ).animate().fadeIn(delay: 400.ms),
                    const SizedBox(height: 24),

                    // Offers
                    const Text('Offers', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: _brownDark, decoration: TextDecoration.none)),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 90,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (context, i) {
                          final offers = [
                            ('\u20b9100 OFF', 'On your first order', 'WELCOME100', Icons.local_offer_rounded),
                            ('Free Delivery', 'On orders above \u20b9199', '', Icons.local_shipping_rounded),
                            ('Cashback', 'Upto \u20b950 on wallet', '', Icons.card_giftcard_rounded),
                          ];
                          final o = offers[i];
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                              child: Container(
                                width: 120,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(color: _glass, borderRadius: BorderRadius.circular(16), border: Border.all(color: _glassBorder)),
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                                  Container(width: 30, height: 30, decoration: BoxDecoration(color: _brown.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: Icon(o.$4, color: _brown, size: 16)),
                                  const SizedBox(height: 6),
                                  Text(o.$1, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _brownDark, decoration: TextDecoration.none)),
                                  Text(o.$2, style: TextStyle(fontSize: 9, color: _brownLight.withValues(alpha: 0.6), decoration: TextDecoration.none, height: 1.2)),
                                  if (o.$3.isNotEmpty) ...[const SizedBox(height: 2), Text(o.$3, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: _brown, decoration: TextDecoration.none))],
                                ]),
                              ),
                            ),
                          );
                        },
                      ),
                    ).animate().fadeIn(delay: 500.ms),
                    const SizedBox(height: 24),

                    // Promotional Banners
                    SizedBox(
                      height: 180,
                      child: PageView(
                        children: [
                          // Welcome Offer Banner
                          ClipRRect(
                            borderRadius: BorderRadius.circular(22),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [Colors.white.withValues(alpha: 0.6), _glass]),
                                  borderRadius: BorderRadius.circular(22),
                                  border: Border.all(color: _glassBorder),
                                ),
                                padding: const EdgeInsets.all(18),
                                child: Row(children: [
                                  // Gift icon
                                  Container(
                                    width: 80, height: 80,
                                    decoration: BoxDecoration(color: _brown.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(20)),
                                    child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                      Text('\ud83c\udf81', style: TextStyle(fontSize: 36)),
                                    ]),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                                    Row(children: [const Text('\ud83c\udf89', style: TextStyle(fontSize: 16)), const SizedBox(width: 4), const Text('Welcome Offer', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _brownDark, decoration: TextDecoration.none))]),
                                    const SizedBox(height: 4),
                                    const Text('\u20b9100 OFF', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: _brownDark, decoration: TextDecoration.none)),
                                    Text('First Order', style: TextStyle(fontSize: 13, color: _brownLight.withValues(alpha: 0.7), decoration: TextDecoration.none)),
                                    const SizedBox(height: 8),
                                    Wrap(direction: Axis.horizontal, children: [
                                      Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: _brown.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(8)), child: const Text('WELCOME100', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: _brown, decoration: TextDecoration.none))),
                                      const SizedBox(width: 6),
                                      GestureDetector(onTap: () {}, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(gradient: const LinearGradient(colors: [_brownLight, _brown, _brownDark]), borderRadius: BorderRadius.circular(8)), child: const Text('Claim \u2192', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white, decoration: TextDecoration.none)))),
                                    ]),
                                  ])),
                                ]),
                              ),
                            ),
                          ),
                          // FuelRush Prime Banner
                          ClipRRect(
                            borderRadius: BorderRadius.circular(22),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [Colors.white.withValues(alpha: 0.6), _glass]),
                                  borderRadius: BorderRadius.circular(22),
                                  border: Border.all(color: _glassBorder),
                                ),
                                padding: const EdgeInsets.all(18),
                                child: Row(children: [
                                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                                    Row(children: [const Text('\ud83d\udc51', style: TextStyle(fontSize: 18)), const SizedBox(width: 4), const Text('FuelRush', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: _brownDark, decoration: TextDecoration.none))]),
                                    const Text('Prime \u2b50', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: _brown, decoration: TextDecoration.none)),
                                    Text('Premium membership', style: TextStyle(fontSize: 11, color: _brownLight.withValues(alpha: 0.7), decoration: TextDecoration.none)),
                                    const SizedBox(height: 8),
                                    Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(gradient: const LinearGradient(colors: [_brownLight, _brown, _brownDark]), borderRadius: BorderRadius.circular(10)), child: const Text('\u20b9199/month', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white, decoration: TextDecoration.none))),
                                  ])),
                                  const SizedBox(width: 10),
                                  Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    _benefitRow(Icons.delivery_dining_rounded, 'Free Delivery'),
                                    const SizedBox(height: 6),
                                    _benefitRow(Icons.bolt_rounded, 'Priority Drivers'),
                                    const SizedBox(height: 6),
                                    _benefitRow(Icons.account_balance_wallet_rounded, '5% Cashback'),
                                  ]),
                                ]),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Page indicator dots
                    Center(child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Container(width: 20, height: 6, decoration: BoxDecoration(color: _brown, borderRadius: BorderRadius.all(Radius.circular(3)))),
                      SizedBox(width: 6),
                      Container(width: 6, height: 6, decoration: BoxDecoration(color: Color(0xFFD4C4B0), shape: BoxShape.circle)),
                    ])),

                    const SizedBox(height: 24),

                    // Scheduled Orders
                    Row(children: [
                      const Icon(Icons.calendar_month_rounded, color: _brown, size: 20),
                      const SizedBox(width: 8),
                      const Text('Scheduled Orders', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: _brownDark, decoration: TextDecoration.none)),
                    ]),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 70,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (context, i) {
                          final items = [('Today', '0 Orders'), ('Tomorrow', '0 Orders'), ('Pick Date', 'Schedule')];
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                              child: Container(
                                width: 120,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                decoration: BoxDecoration(color: _glass, borderRadius: BorderRadius.circular(14), border: Border.all(color: _glassBorder)),
                                child: Row(children: [
                                  Icon(Icons.event_rounded, color: _brown.withValues(alpha: 0.5), size: 20),
                                  const SizedBox(width: 8),
                                  Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                                    Text(items[i].$1, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _brownDark, decoration: TextDecoration.none)),
                                    Text(items[i].$2, style: TextStyle(fontSize: 11, color: _brownLight.withValues(alpha: 0.6), decoration: TextDecoration.none)),
                                  ]),
                                  const Spacer(),
                                  Icon(Icons.chevron_right_rounded, size: 16, color: _brownLight.withValues(alpha: 0.4)),
                                ]),
                              ),
                            ),
                          );
                        },
                      ),
                    ).animate().fadeIn(delay: 600.ms),
                    const SizedBox(height: 24),

                    // Your Vehicles
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Row(children: [
                        const Icon(Icons.directions_car_rounded, color: _brown, size: 20),
                        const SizedBox(width: 8),
                        const Text('Your Vehicles', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: _brownDark, decoration: TextDecoration.none)),
                      ]),
                      GestureDetector(onTap: () {}, child: Row(children: [Text('View All', style: TextStyle(fontSize: 13, color: _brownLight.withValues(alpha: 0.7), decoration: TextDecoration.none)), Icon(Icons.chevron_right_rounded, size: 16, color: _brownLight.withValues(alpha: 0.5))])),
                    ]),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 100,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (context, i) {
                          if (i == 2) {
                            return GestureDetector(
                              onTap: () {},
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  width: 130,
                                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(16), border: Border.all(color: _brownLight.withValues(alpha: 0.3), style: BorderStyle.solid)),
                                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                    Icon(Icons.add_circle_outline_rounded, color: _brownLight.withValues(alpha: 0.5), size: 28),
                                    const SizedBox(height: 4),
                                    Text('Add Vehicle', style: TextStyle(fontSize: 12, color: _brownLight.withValues(alpha: 0.6), decoration: TextDecoration.none)),
                                  ]),
                                ),
                              ),
                            );
                          }
                          final vehicles = [('Honda City', 'TN 09 AB 1234', true), ('Yamaha R15', 'TN 09 CD 5678', false)];
                          final v = vehicles[i];
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                              child: Container(
                                width: 150,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(color: _glass, borderRadius: BorderRadius.circular(16), border: Border.all(color: _glassBorder)),
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                                  Row(children: [
                                    Icon(Icons.directions_car_rounded, color: _brown.withValues(alpha: 0.5), size: 20),
                                    const SizedBox(width: 6),
                                    Expanded(child: Text(v.$1, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _brownDark, decoration: TextDecoration.none))),
                                  ]),
                                  const SizedBox(height: 4),
                                  Text(v.$2, style: TextStyle(fontSize: 11, color: _brownLight.withValues(alpha: 0.6), decoration: TextDecoration.none)),
                                  if (v.$3) ...[const SizedBox(height: 4), Row(children: [const Icon(Icons.star_rounded, color: Color(0xFFFFAB00), size: 12), const SizedBox(width: 2), const Text('Default', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFFFFAB00), decoration: TextDecoration.none))])],
                                ]),
                              ),
                            ),
                          );
                        },
                      ),
                    ).animate().fadeIn(delay: 700.ms),
                    const SizedBox(height: 24),

                    // Recent Orders
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Row(children: [
                        const Icon(Icons.receipt_long_rounded, color: _brown, size: 20),
                        const SizedBox(width: 8),
                        const Text('Recent Orders', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: _brownDark, decoration: TextDecoration.none)),
                      ]),
                      GestureDetector(onTap: () {}, child: Row(children: [Text('View All', style: TextStyle(fontSize: 13, color: _brownLight.withValues(alpha: 0.7), decoration: TextDecoration.none)), Icon(Icons.chevron_right_rounded, size: 16, color: _brownLight.withValues(alpha: 0.5))])),
                    ]),
                    const SizedBox(height: 12),
                    if (_recentOrders.isEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(color: _glass, borderRadius: BorderRadius.circular(16), border: Border.all(color: _glassBorder)),
                          child: Row(children: [
                            Container(width: 40, height: 40, decoration: BoxDecoration(color: _brown.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.local_gas_station_rounded, color: _brown, size: 20)),
                            const SizedBox(width: 12),
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              const Text('10L Petrol', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _brownDark, decoration: TextDecoration.none)),
                              Text('Anna Nagar, Chennai', style: TextStyle(fontSize: 12, color: _brownLight.withValues(alpha: 0.6), decoration: TextDecoration.none)),
                            ])),
                            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                              const Text('\u20b9752.67', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _brownDark, decoration: TextDecoration.none)),
                              Text('01 Sep, 7:45 PM', style: TextStyle(fontSize: 11, color: _brownLight.withValues(alpha: 0.5), decoration: TextDecoration.none)),
                            ]),
                          ]),
                        ),
                      )
                    else
                      ..._recentOrders.map((o) => ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(color: _glass, borderRadius: BorderRadius.circular(16), border: Border.all(color: _glassBorder)),
                          child: Row(children: [
                            Container(width: 40, height: 40, decoration: BoxDecoration(color: _brown.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.local_gas_station_rounded, color: _brown, size: 20)),
                            const SizedBox(width: 12),
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text('${o['quantityLiters'] ?? 10}L ${((o['fuelType'] as String?) ?? 'petrol').toUpperCase()}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _brownDark, decoration: TextDecoration.none)),
                              Text(o['status'] as String? ?? 'delivered', style: TextStyle(fontSize: 12, color: _brownLight.withValues(alpha: 0.6), decoration: TextDecoration.none)),
                            ])),
                            Text('\u20b9${o['totalAmount'] ?? '0'}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _brownDark, decoration: TextDecoration.none)),
                          ]),
                        ),
                      )),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),

            // Quick Order FAB
            Positioned(
              bottom: 30, right: 20,
              child: GestureDetector(
                onTap: () {
                  ref.read(selectedFuelTypeProvider.notifier).set('petrol');
                  context.push(RouteNames.orderFlow);
                },
                child: Container(
                  width: 64, height: 64,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [_brownLight, _brown, _brownDark]),
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: _brown.withValues(alpha: 0.4), blurRadius: 16, offset: const Offset(0, 6))],
                  ),
                  child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.local_gas_station_rounded, color: Colors.white, size: 24),
                    Text('Quick\nOrder', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w700, decoration: TextDecoration.none, height: 1.1)),
                  ]),
                ),
              ),
            ).animate().fadeIn(delay: 800.ms).scale(begin: const Offset(0.5, 0.5)),
          ],
        ),
      ),
    );
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: _glass, borderRadius: BorderRadius.circular(14), border: Border.all(color: _glassBorder)),
            child: Icon(icon, color: _brown, size: 22),
          ),
        ),
      ),
    );
  }

  Widget _benefitRow(IconData icon, String text) {
    return Row(children: [
      Container(width: 24, height: 24, decoration: BoxDecoration(color: _brown.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)), child: Icon(icon, color: _brown, size: 14)),
      const SizedBox(width: 6),
      Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _brownDark, decoration: TextDecoration.none)),
    ]);
  }

  Widget _locationChip(IconData icon, String label, String area) {
    return Container(
      width: 80, height: 60,
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(12), border: Border.all(color: _glassBorder)),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon, color: _brown, size: 18),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: _brownDark, decoration: TextDecoration.none)),
        Text(area, style: TextStyle(fontSize: 8, color: _brownLight.withValues(alpha: 0.6), decoration: TextDecoration.none)),
      ]),
    );
  }

  Widget _bubble({double? top, double? bottom, double? left, double? right, required double size, required double opacity}) {
    return Positioned(
      top: top, bottom: bottom, left: left, right: right,
      child: Container(
        width: size, height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [Colors.white.withValues(alpha: opacity + 0.1), Colors.white.withValues(alpha: opacity * 0.3)]), border: Border.all(color: Colors.white.withValues(alpha: opacity + 0.05))),
      ),
    );
  }
}
