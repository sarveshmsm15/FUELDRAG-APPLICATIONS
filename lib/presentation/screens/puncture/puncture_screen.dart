import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../services/api/dio_client.dart';
import '../../navigation/app_router.dart';

class PunctureScreen extends ConsumerStatefulWidget {
  const PunctureScreen({super.key});
  @override
  ConsumerState<PunctureScreen> createState() => _PunctureScreenState();
}

class _PunctureScreenState extends ConsumerState<PunctureScreen> {
  static const _brown = Color(0xFF5C3A1E);
  static const _brownLight = Color(0xFF8B6342);
  static const _brownDark = Color(0xFF3E2210);
  static const _glass = Color(0x40FFFFFF);
  static const _glassBorder = Color(0x60FFFFFF);

  int _selectedVehicle = 0;
  bool _isBooking = false;

  final List<Map<String, String>> _vehicles = [
    {'name': 'Honda City', 'plate': 'TN 09 AB 1234', 'type': 'car'},
    {'name': 'Yamaha R15', 'plate': 'TN 09 CD 5678', 'type': 'bike'},
  ];

  Future<void> _bookService() async {
    setState(() => _isBooking = true);
    try {
      final res = await DioClient.instance.post('/orders', data: {
        'fuelType': 'puncture',
        'quantityLiters': 1,
        'distanceKm': 5,
        'notes': 'Tyre puncture repair - ${_vehicles[_selectedVehicle]['name']} (${_vehicles[_selectedVehicle]['plate']})',
      });
      final data = (res.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      if (mounted) context.go('${RouteNames.mapTracking}/${data['id']}');
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: const Color(0xFFFF1744)));
    } finally {
      if (mounted) setState(() => _isBooking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
              child: Column(
                children: [
                  // Top bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => context.pop(),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                              child: Container(
                                width: 44, height: 44,
                                decoration: BoxDecoration(color: _glass, borderRadius: BorderRadius.circular(14), border: Border.all(color: _glassBorder)),
                                child: const Icon(Icons.arrow_back_ios_new_rounded, color: _brown, size: 18),
                              ),
                            ),
                          ),
                        ),
                        Stack(children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                              child: Container(
                                width: 44, height: 44,
                                decoration: BoxDecoration(color: _glass, borderRadius: BorderRadius.circular(14), border: Border.all(color: _glassBorder)),
                                child: const Icon(Icons.notifications_outlined, color: _brown, size: 22),
                              ),
                            ),
                          ),
                          Positioned(right: 2, top: 2, child: Container(width: 18, height: 18, decoration: const BoxDecoration(color: Color(0xFFFF6B35), shape: BoxShape.circle), child: const Center(child: Text('2', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700, decoration: TextDecoration.none))))),
                        ]),
                      ],
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),

                          // Hero section with tyre image
                          SizedBox(
                            height: 240,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                // Tyre hero image
                                Positioned(
                                  right: -20, top: -10,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.asset(
                                      'assets/images/tyre_hero.png',
                                      width: 220, height: 220,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                // Title overlay
                                Positioned(
                                  left: 0, bottom: 10,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Puncture', style: TextStyle(fontSize: 38, fontWeight: FontWeight.w900, color: _brownDark, decoration: TextDecoration.none, height: 1.0)),
                                      Text('for Tyres', style: TextStyle(fontSize: 38, fontWeight: FontWeight.w900, color: _brown.withValues(alpha: 0.55), decoration: TextDecoration.none, height: 1.0)),
                                      const SizedBox(height: 8),
                                      Text('We fix it. You ride worry-free.', style: TextStyle(fontSize: 14, color: _brownLight.withValues(alpha: 0.7), decoration: TextDecoration.none)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ).animate().fadeIn(delay: 100.ms),
                          const SizedBox(height: 20),

                          // Stats row
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(color: _glass, borderRadius: BorderRadius.circular(20), border: Border.all(color: _glassBorder)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _statItem(Icons.access_time_rounded, '24×7', 'Service'),
                                    _divider(),
                                    _statItem(Icons.timer_rounded, '15-20', 'min Arrival'),
                                    _divider(),
                                    _statItem(Icons.verified_user_rounded, 'Professional', 'Tyre Repair'),
                                    _divider(),
                                    _statItem(Icons.location_on_rounded, 'At Your', 'Location'),
                                  ],
                                ),
                              ),
                            ),
                          ).animate().fadeIn(delay: 200.ms),
                          const SizedBox(height: 24),

                          // How It Works
                          const Text('How It Works', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: _brownDark, decoration: TextDecoration.none)),
                          const SizedBox(height: 16),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                                decoration: BoxDecoration(color: _glass, borderRadius: BorderRadius.circular(20), border: Border.all(color: _glassBorder)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    _howStep('01', Icons.description_rounded, 'Request\nService'),
                                    _dashLine(),
                                    _howStep('02', Icons.person_pin_rounded, 'Driver\nAssigned'),
                                    _dashLine(),
                                    _howStep('03', Icons.delivery_dining_rounded, 'On the\nWay'),
                                    _dashLine(),
                                    _howStep('04', Icons.build_rounded, 'Repair\nin Progress'),
                                    _dashLine(),
                                    _howStep('05', Icons.check_circle_rounded, 'All Set!\nDrive Safe'),
                                  ],
                                ),
                              ),
                            ),
                          ).animate().fadeIn(delay: 300.ms),
                          const SizedBox(height: 24),

                          // Service at Your Doorstep
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(color: _glass, borderRadius: BorderRadius.circular(20), border: Border.all(color: _glassBorder)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(children: [
                                      Container(width: 36, height: 36, decoration: BoxDecoration(color: _brown.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.verified_user_rounded, color: _brown, size: 18)),
                                      const SizedBox(width: 10),
                                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        const Text('Service at Your Doorstep', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _brownDark, decoration: TextDecoration.none)),
                                        Text('We come to you and fix it on the spot.', style: TextStyle(fontSize: 12, color: _brownLight.withValues(alpha: 0.7), decoration: TextDecoration.none)),
                                      ])),
                                    ]),
                                    const SizedBox(height: 14),
                                    Wrap(
                                      spacing: 8, runSpacing: 8,
                                      children: [
                                        _serviceChip('Tyre Puncture Repair'),
                                        _serviceChip('Air Top-Up'),
                                        _serviceChip('Valve Replacement'),
                                        _serviceChip('Wheel Balancing'),
                                        _serviceChip('Safety Check'),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ).animate().fadeIn(delay: 400.ms),
                          const SizedBox(height: 24),

                          // Choose Your Vehicle
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Row(children: [
                              const Icon(Icons.directions_car_rounded, color: _brown, size: 20),
                              const SizedBox(width: 8),
                              const Text('Choose Your Vehicle', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: _brownDark, decoration: TextDecoration.none)),
                            ]),
                            GestureDetector(
                              onTap: () {},
                              child: Row(children: [
                                const Icon(Icons.add_rounded, color: _brown, size: 16),
                                const SizedBox(width: 4),
                                Text('Add New', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _brown, decoration: TextDecoration.none)),
                              ]),
                            ),
                          ]),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 110,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: _vehicles.length + 1,
                              separatorBuilder: (_, __) => const SizedBox(width: 10),
                              itemBuilder: (context, i) {
                                if (i == _vehicles.length) {
                                  return GestureDetector(
                                    onTap: () {},
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Container(
                                        width: 130,
                                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(16), border: Border.all(color: _brownLight.withValues(alpha: 0.3))),
                                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                          Icon(Icons.add_circle_outline_rounded, color: _brownLight.withValues(alpha: 0.5), size: 28),
                                          const SizedBox(height: 4),
                                          Text('Add Vehicle', style: TextStyle(fontSize: 12, color: _brownLight.withValues(alpha: 0.6), decoration: TextDecoration.none)),
                                        ]),
                                      ),
                                    ),
                                  );
                                }
                                final v = _vehicles[i];
                                final selected = _selectedVehicle == i;
                                return GestureDetector(
                                  onTap: () => setState(() => _selectedVehicle = i),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: 150,
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: selected ? _brown.withValues(alpha: 0.08) : Colors.white.withValues(alpha: 0.5),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: selected ? _brown : _glassBorder, width: selected ? 2 : 1),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                          Icon(v['type'] == 'car' ? Icons.directions_car_rounded : Icons.two_wheeler_rounded, color: _brown, size: 24),
                                          if (selected) Container(width: 22, height: 22, decoration: const BoxDecoration(color: _brown, shape: BoxShape.circle), child: const Icon(Icons.check_rounded, color: Colors.white, size: 14)),
                                          if (!selected) Container(width: 22, height: 22, decoration: BoxDecoration(border: Border.all(color: _brownLight.withValues(alpha: 0.3)), shape: BoxShape.circle)),
                                        ]),
                                        const SizedBox(height: 8),
                                        Text(v['name']!, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _brownDark, decoration: TextDecoration.none)),
                                        Text(v['plate']!, style: TextStyle(fontSize: 11, color: _brownLight.withValues(alpha: 0.6), decoration: TextDecoration.none)),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ).animate().fadeIn(delay: 500.ms),
                          const SizedBox(height: 24),

                          // Service Details
                          Row(children: [
                            const Icon(Icons.receipt_long_rounded, color: _brown, size: 20),
                            const SizedBox(width: 8),
                            const Text('Service Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: _brownDark, decoration: TextDecoration.none)),
                          ]),
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(color: _glass, borderRadius: BorderRadius.circular(18), border: Border.all(color: _glassBorder)),
                                child: Row(children: [
                                  Container(width: 48, height: 48, decoration: BoxDecoration(color: _brown.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.tire_repair_rounded, color: _brown, size: 24)),
                                  const SizedBox(width: 12),
                                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    const Text('Puncture Repair', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: _brownDark, decoration: TextDecoration.none)),
                                    Text("Flat tyre or slow leak? We'll fix it quickly.", style: TextStyle(fontSize: 12, color: _brownLight.withValues(alpha: 0.7), decoration: TextDecoration.none)),
                                  ])),
                                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                                    const Text('\u20b999', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: _brownDark, decoration: TextDecoration.none)),
                                    Text('Starting From', style: TextStyle(fontSize: 10, color: _brownLight.withValues(alpha: 0.6), decoration: TextDecoration.none)),
                                  ]),
                                ]),
                              ),
                            ),
                          ).animate().fadeIn(delay: 600.ms),
                          const SizedBox(height: 24),

                          // Book Now button
                          GestureDetector(
                            onTap: _isBooking ? null : _bookService,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                  decoration: BoxDecoration(color: _glass, borderRadius: BorderRadius.circular(20), border: Border.all(color: _glassBorder)),
                                  child: Row(children: [
                                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      const Text('\u20b999', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: _brownDark, decoration: TextDecoration.none)),
                                      Text('Starting From', style: TextStyle(fontSize: 11, color: _brownLight.withValues(alpha: 0.6), decoration: TextDecoration.none)),
                                    ]),
                                    const SizedBox(width: 16),
                                    Container(width: 1, height: 40, color: _brownLight.withValues(alpha: 0.2)),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(colors: [_brownLight, _brown, _brownDark]),
                                          borderRadius: BorderRadius.circular(16),
                                          boxShadow: [BoxShadow(color: _brown.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 5))],
                                        ),
                                        child: Center(
                                          child: _isBooking
                                            ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                                            : const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                Text('Book Now', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800, decoration: TextDecoration.none)),
                                                SizedBox(width: 8),
                                                Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                                              ]),
                                        ),
                                      ),
                                    ),
                                  ]),
                                ),
                              ),
                            ),
                          ).animate().fadeIn(delay: 700.ms),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statItem(IconData icon, String value, String label) {
    return Column(children: [
      Icon(icon, color: _brown, size: 22),
      const SizedBox(height: 6),
      Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: _brownDark, decoration: TextDecoration.none)),
      Text(label, style: TextStyle(fontSize: 10, color: _brownLight.withValues(alpha: 0.6), decoration: TextDecoration.none)),
    ]);
  }

  Widget _divider() => Container(width: 1, height: 36, color: _brownLight.withValues(alpha: 0.15));

  Widget _howStep(String num, IconData icon, String label) {
    return SizedBox(
      width: 56,
      child: Column(children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(color: _brown.withValues(alpha: 0.08), shape: BoxShape.circle, border: Border.all(color: _brown.withValues(alpha: 0.15))),
          child: Icon(icon, color: _brown, size: 18),
        ),
        const SizedBox(height: 6),
        Text(num, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: _brownDark, decoration: TextDecoration.none)),
        const SizedBox(height: 2),
        Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 9, color: _brownLight.withValues(alpha: 0.6), decoration: TextDecoration.none, height: 1.15)),
      ]),
    );
  }

  Widget _dashLine() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(bottom: 28),
        height: 1.5,
        decoration: BoxDecoration(
          color: _brownLight.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(1),
        ),
      ),
    );
  }

  Widget _serviceChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(10), border: Border.all(color: _glassBorder)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.check_rounded, color: _brown, size: 14),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _brownDark, decoration: TextDecoration.none)),
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
