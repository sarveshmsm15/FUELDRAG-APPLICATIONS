import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../providers/order/order_provider.dart';
import '../../../providers/tracking/tracking_provider.dart';
import '../../../services/api/dio_client.dart';
import '../../../services/notifications/notification_service.dart';
import '../../navigation/app_router.dart';

class MapTrackingScreen extends ConsumerStatefulWidget {
  final String orderId;
  const MapTrackingScreen({super.key, required this.orderId});
  @override
  ConsumerState<MapTrackingScreen> createState() => _MapTrackingScreenState();
}

class _MapTrackingScreenState extends ConsumerState<MapTrackingScreen> {
  GoogleMapController? _mapController;
  String _status = 'waiting';
  int _etaMinutes = 29;
  double _driverLat = 13.0827;
  double _driverLng = 80.2707;
  final double _destLat = 13.0878;
  final double _destLng = 80.2785;
  Timer? _timer;

  static const _brown = Color(0xFF5C3A1E);
  static const _brownLight = Color(0xFF8B6342);
  static const _brownDark = Color(0xFF3E2210);
  static const _glass = Color(0x60FFFFFF);
  static const _glassBorder = Color(0x80FFFFFF);

  @override
  void initState() {
    super.initState();
    _fetchStatus();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => _fetchStatus());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _fetchStatus() async {
    try {
      final res = await DioClient.instance.get('/tracking/order/${widget.orderId}');
      final data = res.data as Map<String, dynamic>;
      final details = data['details'] as Map<String, dynamic>?;
      setState(() {
        _status = data['status'] as String? ?? _status;
        if (details != null) {
          _etaMinutes = (details['etaMinutes'] as num?)?.toInt() ?? _etaMinutes;
          _driverLat = (details['driverLatitude'] as num?)?.toDouble() ?? _driverLat;
          _driverLng = (details['driverLongitude'] as num?)?.toDouble() ?? _driverLng;
        }
      });
      ref.read(orderStatusProvider.notifier).set(_status);
      NotificationService.show(title: _statusLabel(_status), body: 'Your fuel delivery status has been updated.');
      ref.read(appNotificationsProvider.notifier).add(AppNotification(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _statusLabel(_status),
        body: 'Your fuel delivery status has been updated.',
        timestamp: DateTime.now(),
        type: 'delivery',
      ));
    } catch (_) {}
  }

  String _statusLabel(String s) {
    switch (s) {
      case 'driver_arriving': return 'Driver Approaching';
      case 'delivered': return 'Fuel Delivered!';
      default: return 'Waiting for driver...';
    }
  }

  int _statusStep(String s) {
    switch (s) {
      case 'confirmed': case 'waiting': return 0;
      case 'driver_arriving': case 'picked_up': return 1;
      case 'out_for_delivery': case 'delivering': return 2;
      case 'delivered': return 3;
      default: return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final step = _statusStep(_status);
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: Stack(
        children: [
          // Full screen map
          GoogleMap(
            initialCameraPosition: CameraPosition(target: LatLng(_driverLat, _driverLng), zoom: 14),
            onMapCreated: (c) => _mapController = c,
            markers: {
              Marker(markerId: const MarkerId('driver'), position: LatLng(_driverLat, _driverLng), icon: BitmapDescriptor.defaultMarkerWithHue(25)),
              Marker(markerId: const MarkerId('dest'), position: LatLng(_destLat, _destLng), icon: BitmapDescriptor.defaultMarkerWithHue(0)),
            },
            mapType: MapType.normal,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
          ),

          // Top bar with back button
          Positioned(
            top: topPad + 8,
            left: 16,
            right: 16,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => context.go(RouteNames.home),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(color: _glass, borderRadius: BorderRadius.circular(14), border: Border.all(color: _glassBorder)),
                        child: const Icon(Icons.arrow_back_ios_new_rounded, color: _brown, size: 18),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(color: _glass, borderRadius: BorderRadius.circular(14), border: Border.all(color: _glassBorder)),
                        child: Row(children: [
                          Container(width: 10, height: 10, decoration: BoxDecoration(color: _status == 'delivered' ? const Color(0xFF2E7D32) : const Color(0xFFFFAB00), shape: BoxShape.circle)),
                          const SizedBox(width: 8),
                          Expanded(child: Text(_statusLabel(_status), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _brownDark, decoration: TextDecoration.none))),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(color: const Color(0xFFFF6B35).withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                            child: Text('$_etaMinutes min', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFFFF6B35), decoration: TextDecoration.none)),
                          ),
                        ]),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {},
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(color: _glass, borderRadius: BorderRadius.circular(14), border: Border.all(color: _glassBorder)),
                        child: const Icon(Icons.more_horiz_rounded, color: _brown, size: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Status card
          Positioned(
            top: topPad + 62,
            left: 16,
            right: 16,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(color: _glass, borderRadius: BorderRadius.circular(18), border: Border.all(color: _glassBorder)),
                  child: Row(children: [
                    Container(width: 36, height: 36, decoration: BoxDecoration(color: _brown.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.local_shipping_rounded, color: _brown, size: 18)),
                    const SizedBox(width: 10),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(_statusLabel(_status), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _brownDark, decoration: TextDecoration.none)),
                      Text('Arriving in $_etaMinutes min (2.4 km away)', style: TextStyle(fontSize: 11, color: _brownLight.withValues(alpha: 0.7), decoration: TextDecoration.none)),
                    ])),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFF2E7D32).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                      child: const Row(children: [Icon(Icons.wifi_tethering_rounded, color: Color(0xFF2E7D32), size: 12), SizedBox(width: 3), Text('Live', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF2E7D32), decoration: TextDecoration.none))]),
                    ),
                  ]),
                ),
              ),
            ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: -0.2),

          // Map controls
          Positioned(
            right: 16,
            bottom: 340,
            child: Column(children: [
              _mapBtn(Icons.my_location_rounded, () => _mapController?.animateCamera(CameraUpdate.newLatLngZoom(LatLng(_driverLat, _driverLng), 15))),
              const SizedBox(height: 8),
              _mapBtn(Icons.add_rounded, () => _mapController?.animateCamera(CameraUpdate.zoomIn())),
              const SizedBox(height: 8),
              _mapBtn(Icons.remove_rounded, () => _mapController?.animateCamera(CameraUpdate.zoomOut())),
            ]),
          ),

          // Bottom sheet
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  decoration: BoxDecoration(color: const Color(0xF5F5EDE4), borderRadius: const BorderRadius.vertical(top: Radius.circular(28)), border: Border.all(color: _glassBorder)),
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: _brownLight.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2)))),
                      const SizedBox(height: 16),
                      Row(children: [
                        ClipRRect(borderRadius: BorderRadius.circular(16), child: Container(width: 56, height: 56, color: _brown.withValues(alpha: 0.1), child: const Icon(Icons.person_rounded, color: _brown, size: 30))),
                        const SizedBox(width: 14),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Text('Suresh Kumar', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: _brownDark, decoration: TextDecoration.none)),
                          Text('Your delivery partner', style: TextStyle(fontSize: 13, color: _brownLight.withValues(alpha: 0.7), decoration: TextDecoration.none)),
                        ])),
                        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: _brown.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)), child: const Text('KA 05 JP 1234', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _brownDark, decoration: TextDecoration.none))),
                          const SizedBox(height: 4),
                          Text('Honda Activa 6G', style: TextStyle(fontSize: 11, color: _brownLight.withValues(alpha: 0.6), decoration: TextDecoration.none)),
                        ]),
                      ]),
                      const SizedBox(height: 12),
                      Row(children: [const SizedBox(width: 70), _actionCircle(Icons.phone_rounded), const SizedBox(width: 12), _actionCircle(Icons.chat_rounded)]),
                      const SizedBox(height: 20),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        _step(0, 'Order\nAccepted', Icons.check_circle_rounded, step),
                        _connector(step >= 1),
                        _step(1, 'On the\nWay', Icons.delivery_dining_rounded, step),
                        _connector(step >= 2),
                        _step(2, 'Out for\nDelivery', Icons.local_shipping_rounded, step),
                        _connector(step >= 3),
                        _step(3, 'Delivered', Icons.flag_rounded, step),
                      ]),
                      const SizedBox(height: 6),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        SizedBox(width: 60, child: Center(child: Text(step >= 0 ? '07:12 PM' : '\u2014', style: TextStyle(fontSize: 10, color: _brownLight.withValues(alpha: 0.5), decoration: TextDecoration.none)))),
                        const Spacer(),
                        SizedBox(width: 60, child: Center(child: Text(step >= 1 ? '07:18 PM' : '\u2014', style: TextStyle(fontSize: 10, color: _brownLight.withValues(alpha: 0.5), decoration: TextDecoration.none)))),
                        const Spacer(),
                        SizedBox(width: 60, child: Center(child: Text(step >= 2 ? '07:25 PM' : '\u2014', style: TextStyle(fontSize: 10, color: _brownLight.withValues(alpha: 0.5), decoration: TextDecoration.none)))),
                        const Spacer(),
                        SizedBox(width: 60, child: Center(child: Text(step >= 3 ? '07:30 PM' : '\u2014', style: TextStyle(fontSize: 10, color: _brownLight.withValues(alpha: 0.5), decoration: TextDecoration.none)))),
                      ]),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {},
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(color: _brown.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(16), border: Border.all(color: _brown.withValues(alpha: 0.1))),
                            child: Row(children: [
                              Container(width: 36, height: 36, decoration: BoxDecoration(color: _brown.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.shopping_bag_rounded, color: _brown, size: 18)),
                              const SizedBox(width: 12),
                              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                const Text('Order Details', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _brownDark, decoration: TextDecoration.none)),
                                Text('View items and order summary', style: TextStyle(fontSize: 12, color: _brownLight.withValues(alpha: 0.6), decoration: TextDecoration.none)),
                              ])),
                              Icon(Icons.chevron_right_rounded, color: _brownLight.withValues(alpha: 0.4), size: 22),
                            ]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3),
        ],
      ),
    );
  }

  Widget _mapBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(width: 44, height: 44, decoration: BoxDecoration(color: _glass, borderRadius: BorderRadius.circular(14), border: Border.all(color: _glassBorder)), child: Icon(icon, color: _brown, size: 20)),
        ),
      ),
    );
  }

  Widget _actionCircle(IconData icon) {
    return Container(width: 44, height: 44, decoration: BoxDecoration(color: _brown.withValues(alpha: 0.1), shape: BoxShape.circle), child: Icon(icon, color: _brown, size: 20));
  }

  Widget _step(int index, String label, IconData icon, int currentStep) {
    final active = currentStep >= index;
    return SizedBox(
      width: 60,
      child: Column(children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(color: active ? _brown.withValues(alpha: 0.12) : Colors.grey.withValues(alpha: 0.1), shape: BoxShape.circle, border: Border.all(color: active ? _brown : Colors.grey.withValues(alpha: 0.3), width: active ? 2 : 1)),
          child: Icon(icon, color: active ? _brown : Colors.grey.withValues(alpha: 0.4), size: 18),
        ),
        const SizedBox(height: 6),
        Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: active ? _brownDark : Colors.grey.withValues(alpha: 0.5), decoration: TextDecoration.none, height: 1.2)),
      ]),
    );
  }

  Widget _connector(bool active) {
    return Expanded(child: Container(height: 2, margin: const EdgeInsets.only(bottom: 20), color: active ? _brown : Colors.grey.withValues(alpha: 0.2)));
  }
}
