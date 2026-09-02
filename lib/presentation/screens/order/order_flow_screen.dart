import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../providers/fuel/fuel_provider.dart';
import '../../../providers/order/order_provider.dart';
import '../../../services/api/dio_client.dart';
import '../../navigation/app_router.dart';

class OrderFlowScreen extends ConsumerStatefulWidget {
  const OrderFlowScreen({super.key});
  @override
  ConsumerState<OrderFlowScreen> createState() => _OrderFlowScreenState();
}

class _OrderFlowScreenState extends ConsumerState<OrderFlowScreen> {
  double _quantity = 1;
  bool _isPlacing = false;
  bool _showAddressForm = false;
  String _addressType = 'Home';
  bool _isLoadingAddress = true;
  Map<String, dynamic>? _savedAddress;

  final _houseCtrl = TextEditingController();
  final _areaCtrl = TextEditingController();
  final _landmarkCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _pincodeCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  static const _brown = Color(0xFF5C3A1E);
  static const _brownLight = Color(0xFF8B6342);
  static const _brownDark = Color(0xFF3E2210);
  static const _glass = Color(0x40FFFFFF);
  static const _glassBorder = Color(0x60FFFFFF);

  @override
  void initState() {
    super.initState();
    _loadAddress();
  }

  Future<void> _loadAddress() async {
    try {
      final res = await DioClient.instance.get('/addresses');
      final list = (res.data as Map<String, dynamic>)['data'] as List;
      if (list.isNotEmpty) {
        final addr = list.first as Map<String, dynamic>;
        setState(() {
          _savedAddress = addr;
          _addressType = addr['label'] as String? ?? 'Home';
          _houseCtrl.text = addr['line1'] as String? ?? '';
          _areaCtrl.text = addr['line2'] as String? ?? '';
          _cityCtrl.text = addr['city'] as String? ?? '';
          _pincodeCtrl.text = addr['pincode'] as String? ?? '';
          _isLoadingAddress = false;
        });
        // Load user phone
        try {
          final me = await DioClient.instance.get('/auth/me');
          final phone = (me.data as Map<String, dynamic>)['data']['phone'] as String? ?? '';
          _phoneCtrl.text = '+91 $phone';
        } catch (_) {}
      } else {
        // Pre-fill with seed data
        _houseCtrl.text = 'Flat 101, Tower A, Green Heights';
        _areaCtrl.text = '5th Cross Street, Anna Nagar West';
        _landmarkCtrl.text = 'Near Anna Nagar Tower Park';
        _cityCtrl.text = 'Chennai';
        _pincodeCtrl.text = '600040';
        _phoneCtrl.text = '+91 98765 43210';
        setState(() => _isLoadingAddress = false);
      }
    } catch (_) {
      _houseCtrl.text = 'Flat 101, Tower A, Green Heights';
      _areaCtrl.text = '5th Cross Street, Anna Nagar West';
      _landmarkCtrl.text = 'Near Anna Nagar Tower Park';
      _cityCtrl.text = 'Chennai';
      _pincodeCtrl.text = '600040';
      _phoneCtrl.text = '+91 98765 43210';
      setState(() => _isLoadingAddress = false);
    }
  }

  Future<void> _saveAddress() async {
    try {
      final data = {
        'label': _addressType,
        'line1': _houseCtrl.text,
        'line2': _areaCtrl.text,
        'city': _cityCtrl.text,
        'state': 'Tamil Nadu',
        'pincode': _pincodeCtrl.text,
        'latitude': 13.0827,
        'longitude': 80.2707,
        'isDefault': true,
      };
      if (_savedAddress != null) {
        await DioClient.instance.put('/addresses/${_savedAddress!['id']}', data: data);
      } else {
        final res = await DioClient.instance.post('/addresses', data: data);
        _savedAddress = (res.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Address saved!'), backgroundColor: _brown));
        setState(() => _showAddressForm = false);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: const Color(0xFFFF1744)));
    }
  }

  double _maxQty(String ft) {
    switch (ft) { case 'petrol': return 10; case 'diesel': return 20; case 'cng': return 15; case 'ev_charge': return 50; default: return 10; }
  }

  bool get _freeDelivery => _quantity > 5;

  Map<String, double> _calc(double ppl) {
    final base = ppl * _quantity;
    final del = _freeDelivery ? 0.0 : 49.0;
    final sub = base + del;
    final tax = (sub * 0.18 * 100).round() / 100;
    final total = ((sub + tax) * 100).round() / 100;
    return {'base': (base * 100).round() / 100, 'del': del, 'tax': tax, 'total': total};
  }

  Future<void> _placeOrder() async {
    // Save address first if not saved (don't block order on failure)
    if (_savedAddress == null) {
      try { await _saveAddress(); } catch (_) {}
    }
    setState(() => _isPlacing = true);
    try {
      final ft = ref.read(selectedFuelTypeProvider) ?? 'petrol';
      final res = await DioClient.instance.post('/orders', data: {
        'fuelType': ft,
        'quantityLiters': _quantity,
        'distanceKm': 5,
        if (_savedAddress != null) 'addressId': _savedAddress!['id'],
      });
      final data = (res.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      if (mounted) context.go('${RouteNames.mapTracking}/${data['id']}');
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: const Color(0xFFFF1744)));
    } finally {
      if (mounted) setState(() => _isPlacing = false);
    }
  }

  @override
  void dispose() {
    for (final c in [_houseCtrl, _areaCtrl, _landmarkCtrl, _cityCtrl, _pincodeCtrl, _phoneCtrl]) c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ft = ref.watch(selectedFuelTypeProvider) ?? 'petrol';
    final ratesAsync = ref.watch(fuelRatesProvider);
    final maxQ = _maxQty(ft);
    if (_quantity > maxQ) _quantity = maxQ;
    final quickQty = [1, 2, 3, 4, 5];

    return Scaffold(
      body: Container(
        width: double.infinity, height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [Color(0xFFF8F0E8), Color(0xFFEDE0D4), Color(0xFFF5EDE4), Color(0xFFE8D5C4)], stops: [0.0, 0.3, 0.7, 1.0]),
        ),
        child: Stack(
          children: [
            _bubble(top: -30, right: -20, size: 130, opacity: 0.12),
            _bubble(bottom: 100, left: -30, size: 100, opacity: 0.08),
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GestureDetector(
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
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Order ${ft.toUpperCase()}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: _brownDark, decoration: TextDecoration.none)),
                        const SizedBox(height: 4),
                        Text('Select quantity and confirm', style: TextStyle(fontSize: 15, color: _brownLight.withValues(alpha: 0.7), decoration: TextDecoration.none)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          // Quantity selector
                          ClipRRect(
                            borderRadius: BorderRadius.circular(22),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(color: _glass, borderRadius: BorderRadius.circular(22), border: Border.all(color: _glassBorder)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('Select Quantity', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _brownDark, decoration: TextDecoration.none)),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(color: _brown.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
                                          child: Row(children: [
                                            Text('Custom', style: TextStyle(fontSize: 12, color: _brownLight.withValues(alpha: 0.7), decoration: TextDecoration.none)),
                                            const SizedBox(width: 4),
                                            Icon(Icons.edit_rounded, size: 14, color: _brownLight.withValues(alpha: 0.5)),
                                          ]),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    SizedBox(
                                      height: 105,
                                      child: ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: quickQty.length,
                                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                                        itemBuilder: (context, i) {
                                          final q = quickQty[i].toDouble();
                                          final sel = _quantity == q;
                                          return GestureDetector(
                                            onTap: () => setState(() => _quantity = q),
                                            child: AnimatedContainer(
                                              duration: const Duration(milliseconds: 200),
                                              width: 68,
                                              decoration: BoxDecoration(
                                                color: sel ? _brown.withValues(alpha: 0.08) : Colors.white.withValues(alpha: 0.5),
                                                borderRadius: BorderRadius.circular(16),
                                                border: Border.all(color: sel ? _brown : _glassBorder, width: sel ? 2 : 1),
                                              ),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.local_gas_station_rounded, color: sel ? _brown : _brownLight.withValues(alpha: 0.4), size: 20),
                                                  const SizedBox(height: 2),
                                                  Text('${quickQty[i]}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: sel ? _brownDark : _brownLight.withValues(alpha: 0.5), decoration: TextDecoration.none)),
                                                  Text(quickQty[i] == 1 ? 'Liter' : 'Liters', style: TextStyle(fontSize: 10, color: _brownLight.withValues(alpha: 0.5), decoration: TextDecoration.none)),
                                                  if (sel) ...[const SizedBox(height: 3), Container(width: 18, height: 18, decoration: const BoxDecoration(color: _brown, shape: BoxShape.circle), child: const Icon(Icons.check_rounded, color: Colors.white, size: 12))],
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Material(
                                      color: Colors.transparent,
                                      child: SliderTheme(
                                        data: SliderThemeData(trackHeight: 6, activeTrackColor: _brown, inactiveTrackColor: _brownLight.withValues(alpha: 0.2), thumbColor: _brown, thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14), overlayColor: _brown.withValues(alpha: 0.1)),
                                        child: Slider(value: _quantity.clamp(1, maxQ), min: 1, max: maxQ, divisions: (maxQ - 1).toInt(), onChanged: (v) => setState(() => _quantity = v)),
                                      ),
                                    ),
                                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                      Text('1L', style: TextStyle(fontSize: 13, color: _brownLight.withValues(alpha: 0.5), decoration: TextDecoration.none)),
                                      Text('${maxQ.toStringAsFixed(0)}L', style: TextStyle(fontSize: 13, color: _brownLight.withValues(alpha: 0.5), decoration: TextDecoration.none)),
                                    ]),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          // Pricing
                          ratesAsync.when(
                            loading: () => const SizedBox(height: 60, child: Center(child: CircularProgressIndicator(color: _brown))),
                            error: (_, __) => const SizedBox(),
                            data: (rates) {
                              final rate = rates.firstWhere((r) => r['fuelType'] == ft, orElse: () => rates.first);
                              final p = _calc((rate['pricePerLiter'] as num).toDouble());
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(22),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: Container(
                                    padding: const EdgeInsets.all(18),
                                    decoration: BoxDecoration(color: _glass, borderRadius: BorderRadius.circular(22), border: Border.all(color: _glassBorder)),
                                    child: Column(children: [
                                      _row('Fuel Cost', '\u20b9${p['base']!.toStringAsFixed(2)}'),
                                      const SizedBox(height: 8),
                                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                        const Text('Delivery Fee', style: TextStyle(fontSize: 15, color: _brownDark, decoration: TextDecoration.none)),
                                        _freeDelivery ? const Text('FREE', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF2E7D32), decoration: TextDecoration.none)) : Text('\u20b9${p['del']!.toStringAsFixed(2)}', style: const TextStyle(fontSize: 15, color: _brownDark, decoration: TextDecoration.none)),
                                      ]),
                                      const SizedBox(height: 8),
                                      _row('Tax (18% GST)', '\u20b9${p['tax']!.toStringAsFixed(2)}'),
                                      const SizedBox(height: 12),
                                      Divider(color: _brownLight.withValues(alpha: 0.15)),
                                      const SizedBox(height: 12),
                                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                        const Text('Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: _brownDark, decoration: TextDecoration.none)),
                                        Text('\u20b9${p['total']!.toStringAsFixed(2)}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: _brownDark, decoration: TextDecoration.none)),
                                      ]),
                                    ]),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 14),
                          // Address section
                          ClipRRect(
                            borderRadius: BorderRadius.circular(22),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(color: _glass, borderRadius: BorderRadius.circular(22), border: Border.all(color: _glassBorder)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(children: [
                                      Container(width: 36, height: 36, decoration: BoxDecoration(color: _brown.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.location_on_rounded, color: _brown, size: 18)),
                                      const SizedBox(width: 10),
                                      Expanded(child: Text(_savedAddress != null ? 'Delivery address loaded' : 'Enter delivery address', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _brownDark, decoration: TextDecoration.none))),
                                      if (_savedAddress != null) const Icon(Icons.check_circle_rounded, color: Color(0xFF2E7D32), size: 18),
                                    ]),
                                    const SizedBox(height: 14),
                                    // Address type chips
                                    Text('Address Type', style: TextStyle(fontSize: 12, color: _brownLight.withValues(alpha: 0.6), decoration: TextDecoration.none)),
                                    const SizedBox(height: 8),
                                    Row(children: [
                                      _chip('Home', Icons.home_rounded),
                                      const SizedBox(width: 8),
                                      _chip('Flat', Icons.apartment_rounded),
                                      const SizedBox(width: 8),
                                      _chip('Office', Icons.work_rounded),
                                    ]),
                                    const SizedBox(height: 14),
                                    // Form fields
                                    _field('House / Flat / Building', _houseCtrl, Icons.description_outlined),
                                    const SizedBox(height: 10),
                                    _field('Area, Street', _areaCtrl, Icons.location_on_outlined),
                                    const SizedBox(height: 10),
                                    Row(children: [
                                      Expanded(child: _field('Landmark (Optional)', _landmarkCtrl, null)),
                                      const SizedBox(width: 10),
                                      Expanded(child: _field('City', _cityCtrl, Icons.location_city_outlined)),
                                    ]),
                                    const SizedBox(height: 10),
                                    Row(children: [
                                      Expanded(child: _field('Pincode', _pincodeCtrl, null)),
                                      const SizedBox(width: 10),
                                      Expanded(child: _field('Phone Number', _phoneCtrl, Icons.phone_outlined)),
                                    ]),
                                    const SizedBox(height: 12),
                                    // Edit / Save address
                                    GestureDetector(
                                      onTap: () {
                                        if (_showAddressForm || _savedAddress == null) {
                                          _saveAddress();
                                        } else {
                                          setState(() => _showAddressForm = true);
                                        }
                                      },
                                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                        Icon(Icons.edit_rounded, size: 16, color: _brownLight.withValues(alpha: 0.7)),
                                        const SizedBox(width: 6),
                                        Text(_savedAddress != null && !_showAddressForm ? 'Edit address' : 'Save address', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _brownLight.withValues(alpha: 0.7), decoration: TextDecoration.none)),
                                      ]),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Place order
                          ratesAsync.when(
                            loading: () => const SizedBox(),
                            error: (_, __) => const SizedBox(),
                            data: (rates) {
                              final rate = rates.firstWhere((r) => r['fuelType'] == ft, orElse: () => rates.first);
                              final p = _calc((rate['pricePerLiter'] as num).toDouble());
                              return GestureDetector(
                                onTap: _isPlacing ? null : _placeOrder,
                                child: Container(
                                  width: double.infinity, height: 56,
                                  decoration: BoxDecoration(gradient: const LinearGradient(colors: [_brownLight, _brown, _brownDark]), borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: _brown.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 6))]),
                                  child: Center(
                                    child: _isPlacing ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white)) : Text('PLACE ORDER \u2014 \u20b9${p['total']!.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700, letterSpacing: 1, decoration: TextDecoration.none)),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 20),
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

  Widget _chip(String label, IconData icon) {
    final sel = _addressType == label;
    return GestureDetector(
      onTap: () => setState(() => _addressType = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: sel ? _brown.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: sel ? _brown : _glassBorder, width: sel ? 1.5 : 1),
        ),
        child: Row(children: [
          Icon(icon, size: 16, color: sel ? _brown : _brownLight.withValues(alpha: 0.5)),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: sel ? _brownDark : _brownLight.withValues(alpha: 0.6), decoration: TextDecoration.none)),
        ]),
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl, IconData? icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 11, color: _brownLight.withValues(alpha: 0.6), decoration: TextDecoration.none)),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(12), border: Border.all(color: _glassBorder)),
              child: TextField(
                controller: ctrl,
                style: const TextStyle(fontSize: 14, color: _brownDark, decoration: TextDecoration.none),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  suffixIcon: icon != null ? Icon(icon, size: 18, color: _brownLight.withValues(alpha: 0.4)) : null,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _row(String l, String v) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(l, style: const TextStyle(fontSize: 15, color: _brownDark, decoration: TextDecoration.none)),
      Text(v, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: _brownDark, decoration: TextDecoration.none)),
    ],
  );

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
