import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../providers/order/order_provider.dart';
import '../../../data/repositories/order_repository.dart';
import '../../../services/api/dio_client.dart';
import '../../navigation/app_router.dart';

class OrderFlowScreen extends ConsumerStatefulWidget {
  const OrderFlowScreen({super.key});
  @override
  ConsumerState<OrderFlowScreen> createState() => _OrderFlowScreenState();
}

class _OrderFlowScreenState extends ConsumerState<OrderFlowScreen> {
  double _quantity = 10;
  bool _isCalculating = false;
  Map<String, dynamic>? _pricing;
  String? _addressId;
  bool _isPlacing = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _loadDefaultAddress();
      _calculatePrice();
    });
  }

  Future<void> _loadDefaultAddress() async {
    try {
      final response = await DioClient.instance.get('/addresses');
      final data = (response.data as Map<String, dynamic>)['data'] as List;
      if (data.isNotEmpty && mounted) {
        setState(() => _addressId = data.first['id'] as String);
      }
    } catch (_) {}
  }

  Future<void> _calculatePrice() async {
    final fuelType = ref.read(selectedFuelTypeProvider);
    if (fuelType == null) return;
    setState(() => _isCalculating = true);
    try {
      final repo = ref.read(orderRepositoryProvider);
      final result = await repo.calculatePricing(
        fuelType: fuelType,
        quantityLiters: _quantity,
      );
      if (mounted) {
        setState(() {
          _pricing = result;
          _isCalculating = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isCalculating = false);
    }
  }

  Future<void> _placeOrder() async {
    if (_pricing == null || _addressId == null) return;
    setState(() => _isPlacing = true);
    try {
      final fuelType = ref.read(selectedFuelTypeProvider) ?? 'petrol';
      final repo = ref.read(orderRepositoryProvider);
      final order = await repo.createOrder(
        addressId: _addressId!,
        fuelType: fuelType,
        quantityLiters: _quantity,
      );
      if (mounted) {
        context.go('${RouteNames.mapTracking}/${order['id']}');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isPlacing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: const Color(0xFFFF1744)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final fuelType = ref.watch(selectedFuelTypeProvider) ?? 'petrol';

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => context.pop(),
                child: Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.white.withValues(alpha: 0.6), size: 20),
              ),
              const SizedBox(height: 16),
              Text('Order ${fuelType.toUpperCase()}',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white))
                .animate().fadeIn(),
              const SizedBox(height: 8),
              Text('Select quantity and confirm',
                  style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.5)))
                .animate().fadeIn(delay: 100.ms),
              const SizedBox(height: 32),

              // Quantity slider
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0x14FFFFFF),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0x1AFFFFFF)),
                    ),
                    child: Column(
                      children: [
                        Text('${_quantity.toStringAsFixed(0)} Liters',
                            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w700, color: Color(0xFFFF6B35))),
                        const SizedBox(height: 16),
                        SliderTheme(
                          data: SliderThemeData(
                            trackHeight: 4,
                            activeTrackColor: const Color(0xFFFF6B35),
                            inactiveTrackColor: const Color(0x1AFFFFFF),
                            thumbColor: const Color(0xFFFF6B35),
                            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                          ),
                          child: Slider(
                            value: _quantity, min: 1, max: 100, divisions: 99,
                            onChanged: (v) { setState(() => _quantity = v); _calculatePrice(); },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('1L', style: TextStyle(color: Colors.white.withValues(alpha: 0.3), fontSize: 12)),
                            Text('100L', style: TextStyle(color: Colors.white.withValues(alpha: 0.3), fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 200.ms),

              const SizedBox(height: 24),

              // Pricing breakdown
              if (_pricing != null)
                ClipRRect(
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
                      child: Column(
                        children: [
                          _priceRow('Fuel Cost', '\u20b9${(_pricing!['basePrice'] as num).toStringAsFixed(2)}'),
                          _priceRow('Delivery Fee', '\u20b9${(_pricing!['deliveryFee'] as num).toStringAsFixed(2)}'),
                          _priceRow('Tax (18% GST)', '\u20b9${(_pricing!['taxAmount'] as num).toStringAsFixed(2)}'),
                          Divider(color: Colors.white.withValues(alpha: 0.1), height: 24),
                          _priceRow('Total', '\u20b9${(_pricing!['totalAmount'] as num).toStringAsFixed(2)}',
                              valueStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFFFF6B35))),
                        ],
                      ),
                    ),
                  ),
                ).animate().fadeIn(delay: 300.ms),

              if (_isCalculating)
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Center(child: SizedBox(width: 20, height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFFF6B35)))),
                ),

              const Spacer(),

              // Address status
              if (_addressId != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(children: [
                    const Icon(Icons.location_on_rounded, color: Color(0xFF00C853), size: 16),
                    const SizedBox(width: 4),
                    Text('Delivery address loaded \u2713',
                        style: TextStyle(color: const Color(0xFF00C853).withValues(alpha: 0.7), fontSize: 12)),
                  ]),
                ),
              if (_addressId == null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(children: [
                    const Icon(Icons.warning_rounded, color: Color(0xFFFFD600), size: 16),
                    const SizedBox(width: 4),
                    Text('No address found',
                        style: TextStyle(color: const Color(0xFFFFD600).withValues(alpha: 0.7), fontSize: 12)),
                  ]),
                ),

              // Place order button
              GestureDetector(
                onTap: (_pricing == null || _addressId == null || _isPlacing) ? null : _placeOrder,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6B35).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFFF6B35).withValues(alpha: 0.4)),
                      ),
                      child: Center(
                        child: _isPlacing
                            ? const SizedBox(width: 24, height: 24,
                                child: CircularProgressIndicator(strokeWidth: 2.5, color: Color(0xFFFF6B35)))
                            : Text(
                                _pricing != null && _addressId != null
                                    ? 'PLACE ORDER \u2014 \u20b9${(_pricing!['totalAmount'] as num).toStringAsFixed(2)}'
                                    : 'LOADING...',
                                style: const TextStyle(color: Color(0xFFFF6B35), fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.5),
                              ),
                      ),
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _priceRow(String label, String value, {Color? color, TextStyle? valueStyle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 14)),
          Text(value, style: valueStyle ?? TextStyle(color: color ?? Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
