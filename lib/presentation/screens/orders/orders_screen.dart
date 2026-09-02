import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../services/api/dio_client.dart';
import '../../navigation/app_router.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  static const _brown = Color(0xFF5C3A1E);
  static const _brownLight = Color(0xFF8B6342);
  static const _brownDark = Color(0xFF3E2210);
  static const _glass = Color(0x40FFFFFF);
  static const _glassBorder = Color(0x60FFFFFF);

  bool _loading = true;
  List<Map<String, dynamic>> _orders = [];
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _loadOrders();
    // Auto-refresh active orders every 10 seconds
    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (_) => _loadOrders(silent: true));
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadOrders({bool silent = false}) async {
    if (!silent && mounted) setState(() => _loading = true);
    try {
      final res = await DioClient.instance.get('/orders');
      final body = res.data as Map<String, dynamic>;
      final data = body['data'];
      final list = data is List
          ? data
          : data is Map<String, dynamic> && data['orders'] is List
              ? data['orders']
              : [];

      if (mounted) {
        setState(() {
          _orders = list.cast<Map<String, dynamic>>();
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  int _step(String status) {
    switch (status) {
      case 'confirmed':
      case 'waiting':
      case 'pending':
        return 0;
      case 'driver_arriving':
      case 'picked_up':
        return 1;
      case 'out_for_delivery':
      case 'delivering':
        return 2;
      case 'delivered':
      case 'completed':
        return 3;
      case 'cancelled':
        return -1;
      default:
        return 0;
    }
  }

  String _statusTitle(String status) {
    switch (status) {
      case 'pending':
      case 'waiting':
        return 'Order Received';
      case 'confirmed':
        return 'Order Confirmed';
      case 'driver_arriving':
      case 'picked_up':
        return 'Driver Assigned';
      case 'out_for_delivery':
      case 'delivering':
        return 'Out for Delivery';
      case 'delivered':
      case 'completed':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status.replaceAll('_', ' ').toUpperCase();
    }
  }

  String _fuelLabel(dynamic fuelType) {
    final ft = (fuelType ?? 'petrol').toString();
    switch (ft) {
      case 'petrol':
        return 'Petrol';
      case 'diesel':
        return 'Diesel';
      case 'puncture':
        return 'Tyre Puncture';
      default:
        return ft.replaceAll('_', ' ').toUpperCase();
    }
  }

  bool _isLive(String status) {
    return !['delivered', 'completed', 'cancelled'].contains(status);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [Color(0xFFF8F0E8), Color(0xFFEDE0D4), Color(0xFFF5EDE4), Color(0xFFE8D5C4)],
          stops: [0.0, 0.3, 0.7, 1.0],
        ),
      ),
      child: Stack(
        children: [
          _bubble(top: -40, right: -30, size: 140, opacity: 0.10),
          _bubble(bottom: 180, left: -40, size: 110, opacity: 0.08),
          SafeArea(
            child: RefreshIndicator(
              color: _brown,
              onRefresh: _loadOrders,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('My Orders', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: _brownDark, decoration: TextDecoration.none)),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                  child: GestureDetector(
                                    onTap: () => _loadOrders(),
                                    child: Container(
                                      width: 44, height: 44,
                                      decoration: BoxDecoration(color: _glass, borderRadius: BorderRadius.circular(14), border: Border.all(color: _glassBorder)),
                                      child: const Icon(Icons.refresh_rounded, color: _brown, size: 22),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text('Track your fuel delivery in real-time', style: TextStyle(fontSize: 14, color: _brownLight.withValues(alpha: 0.7), decoration: TextDecoration.none)),
                        ],
                      ),
                    ),
                  ),

                  if (_loading)
                    const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator(color: _brown)),
                    )
                  else if (_orders.isEmpty)
                    SliverFillRemaining(child: _emptyState())
                  else
                    SliverList.builder(
                      itemCount: _orders.length,
                      itemBuilder: (context, index) {
                        final order = _orders[index];
                        return Padding(
                          padding: EdgeInsets.fromLTRB(20, index == 0 ? 4 : 0, 20, 14),
                          child: _orderCard(context, order, index).animate().fadeIn(delay: (100 + index * 80).ms).slideY(begin: 0.15),
                        );
                      },
                    ),

                  const SliverToBoxAdapter(child: SizedBox(height: 90)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _orderCard(BuildContext context, Map<String, dynamic> order, int index) {
    final id = (order['id'] ?? '').toString();
    final status = (order['status'] ?? 'waiting').toString();
    final currentStep = _step(status);
    final fuel = _fuelLabel(order['fuelType']);
    final qty = (order['quantityLiters'] ?? order['quantity'] ?? 1).toString();
    final total = order['totalAmount'] ?? order['total'] ?? order['amount'] ?? '0';
    final createdAt = _formatDate(order['createdAt']);
    final active = _isLive(status);

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: _glass,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: active ? _brown.withValues(alpha: 0.28) : _glassBorder, width: active ? 1.4 : 1),
            boxShadow: [BoxShadow(color: _brown.withValues(alpha: 0.06), blurRadius: 18, offset: const Offset(0, 8))],
          ),
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: Row(
                  children: [
                    Container(
                      width: 52, height: 52,
                      decoration: BoxDecoration(
                        gradient: active ? const LinearGradient(colors: [_brownLight, _brown, _brownDark]) : null,
                        color: active ? null : _brown.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        fuel.toLowerCase().contains('puncture') ? Icons.build_circle_rounded : Icons.local_gas_station_rounded,
                        color: active ? Colors.white : _brown,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          Expanded(child: Text('$qty L $fuel', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: _brownDark, decoration: TextDecoration.none))),
                          _statusBadge(status),
                        ]),
                        const SizedBox(height: 5),
                        Row(children: [
                          Icon(Icons.receipt_long_rounded, size: 14, color: _brownLight.withValues(alpha: 0.55)),
                          const SizedBox(width: 4),
                          Expanded(child: Text('Order #${id.length > 8 ? id.substring(0, 8).toUpperCase() : id}', style: TextStyle(fontSize: 12, color: _brownLight.withValues(alpha: 0.65), decoration: TextDecoration.none))),
                        ]),
                        const SizedBox(height: 3),
                        Row(children: [
                          Icon(Icons.schedule_rounded, size: 14, color: _brownLight.withValues(alpha: 0.55)),
                          const SizedBox(width: 4),
                          Text(createdAt, style: TextStyle(fontSize: 12, color: _brownLight.withValues(alpha: 0.65), decoration: TextDecoration.none)),
                        ]),
                      ]),
                    ),
                  ],
                ),
              ),

              // Timeline like sample
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.fromLTRB(14, 16, 14, 12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.45)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        _timelineStep(0, currentStep, Icons.check_circle_rounded, 'Order\nPlaced'),
                        _line(currentStep >= 1),
                        _timelineStep(1, currentStep, Icons.person_pin_circle_rounded, 'Driver\nAssigned'),
                        _line(currentStep >= 2),
                        _timelineStep(2, currentStep, Icons.local_shipping_rounded, 'Out for\nDelivery'),
                        _line(currentStep >= 3),
                        _timelineStep(3, currentStep, Icons.flag_rounded, 'Delivered'),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (active)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF6B35).withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(children: [
                          Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFFFF6B35), shape: BoxShape.circle)),
                          const SizedBox(width: 8),
                          Expanded(child: Text(_statusTitle(status), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _brownDark, decoration: TextDecoration.none))),
                          Text('ETA 29 min', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _brownLight.withValues(alpha: 0.8), decoration: TextDecoration.none)),
                        ]),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E7D32).withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Row(children: [
                          Icon(Icons.check_circle_rounded, color: Color(0xFF2E7D32), size: 16),
                          SizedBox(width: 8),
                          Expanded(child: Text('Order completed successfully', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _brownDark, decoration: TextDecoration.none))),
                        ]),
                      ),
                  ],
                ),
              ),

              // Address + price
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(children: [
                        Container(width: 34, height: 34, decoration: BoxDecoration(color: _brown.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.location_on_rounded, color: _brown, size: 17)),
                        const SizedBox(width: 9),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Text('Delivery Address', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _brownDark, decoration: TextDecoration.none)),
                          Text(_addressText(order), maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11, color: _brownLight.withValues(alpha: 0.65), decoration: TextDecoration.none)),
                        ])),
                      ]),
                    ),
                    const SizedBox(width: 10),
                    Text('\u20b9$total', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: _brownDark, decoration: TextDecoration.none)),
                  ],
                ),
              ),

              // Buttons
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  children: [
                    if (active)
                      Expanded(
                        child: GestureDetector(
                          onTap: () => context.push('${RouteNames.mapTracking}/$id'),
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [_brownLight, _brown, _brownDark]),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [BoxShadow(color: _brown.withValues(alpha: 0.25), blurRadius: 12, offset: const Offset(0, 5))],
                            ),
                            child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                              Icon(Icons.near_me_rounded, color: Colors.white, size: 18),
                              SizedBox(width: 8),
                              Text('Live Tracking', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800, decoration: TextDecoration.none)),
                            ]),
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: _brown.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: _brown.withValues(alpha: 0.12)),
                            ),
                            child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                              Icon(Icons.receipt_long_rounded, color: _brown, size: 18),
                              SizedBox(width: 8),
                              Text('View Invoice', style: TextStyle(color: _brown, fontSize: 15, fontWeight: FontWeight.w800, decoration: TextDecoration.none)),
                            ]),
                          ),
                        ),
                      ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 48, height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.45),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: _glassBorder),
                        ),
                        child: Icon(active ? Icons.call_rounded : Icons.refresh_rounded, color: _brown, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusBadge(String status) {
    final active = _isLive(status);
    final cancelled = status == 'cancelled';
    final color = cancelled ? const Color(0xFFFF1744) : active ? const Color(0xFFFF6B35) : const Color(0xFF2E7D32);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
      child: Text(
        cancelled ? 'Cancelled' : active ? 'Live' : 'Done',
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: color, decoration: TextDecoration.none),
      ),
    );
  }

  Widget _timelineStep(int index, int current, IconData icon, String label) {
    final active = current >= index;
    final cancelled = current == -1;
    return SizedBox(
      width: 58,
      child: Column(children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 38, height: 38,
          decoration: BoxDecoration(
            color: cancelled ? Colors.grey.withValues(alpha: 0.12) : active ? _brown.withValues(alpha: 0.12) : Colors.grey.withValues(alpha: 0.10),
            shape: BoxShape.circle,
            border: Border.all(color: cancelled ? Colors.grey.withValues(alpha: 0.3) : active ? _brown : Colors.grey.withValues(alpha: 0.25), width: active ? 2 : 1),
          ),
          child: Icon(icon, color: cancelled ? Colors.grey : active ? _brown : Colors.grey.withValues(alpha: 0.45), size: 17),
        ),
        const SizedBox(height: 6),
        Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: active ? _brownDark : _brownLight.withValues(alpha: 0.45), decoration: TextDecoration.none, height: 1.15)),
      ]),
    );
  }

  Widget _line(bool active) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 27),
        decoration: BoxDecoration(
          color: active ? _brown : _brownLight.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: _glass, borderRadius: BorderRadius.circular(24), border: Border.all(color: _glassBorder)),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(width: 70, height: 70, decoration: BoxDecoration(color: _brown.withValues(alpha: 0.1), shape: BoxShape.circle), child: const Icon(Icons.receipt_long_rounded, color: _brown, size: 34)),
                const SizedBox(height: 16),
                const Text('No orders yet', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: _brownDark, decoration: TextDecoration.none)),
                const SizedBox(height: 6),
                Text('Your orders will appear here once you place them.', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: _brownLight.withValues(alpha: 0.7), decoration: TextDecoration.none)),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(dynamic value) {
    if (value == null) return 'Today';
    try {
      final dt = DateTime.parse(value.toString()).toLocal();
      final h = dt.hour > 12 ? dt.hour - 12 : dt.hour == 0 ? 12 : dt.hour;
      final ampm = dt.hour >= 12 ? 'PM' : 'AM';
      final mm = dt.minute.toString().padLeft(2, '0');
      return '${dt.day}/${dt.month}/${dt.year} • $h:$mm $ampm';
    } catch (_) {
      return value.toString();
    }
  }

  String _addressText(Map<String, dynamic> order) {
    final a = order['address'];
    if (a is Map<String, dynamic>) {
      final line1 = a['line1'] ?? '';
      final city = a['city'] ?? '';
      return '$line1, $city'.replaceAll(RegExp(r'^, |, $'), '');
    }
    return 'Anna Nagar, Chennai';
  }

  Widget _bubble({double? top, double? bottom, double? left, double? right, required double size, required double opacity}) {
    return Positioned(
      top: top, bottom: bottom, left: left, right: right,
      child: Container(
        width: size, height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [Colors.white.withValues(alpha: opacity + 0.1), Colors.white.withValues(alpha: opacity * 0.3)]),
          border: Border.all(color: Colors.white.withValues(alpha: opacity + 0.05)),
        ),
      ),
    );
  }
}
