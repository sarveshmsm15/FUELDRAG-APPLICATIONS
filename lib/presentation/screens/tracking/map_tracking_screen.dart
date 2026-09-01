import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../providers/tracking/tracking_provider.dart';
import '../../../services/socket/socket_service.dart';
import '../../../services/api/dio_client.dart';
import '../../../services/notifications/notification_service.dart';
import '../../navigation/app_router.dart';

class MapTrackingScreen extends ConsumerStatefulWidget {
  const MapTrackingScreen({super.key, required this.orderId});
  final String orderId;

  @override
  ConsumerState<MapTrackingScreen> createState() => _MapTrackingScreenState();
}

class _MapTrackingScreenState extends ConsumerState<MapTrackingScreen> {
  late final SocketService _socket;
  final MapController _mapController = MapController();
  LatLng _deliveryLocation = const LatLng(19.0760, 72.8777);
  LatLng _driverLocation = const LatLng(19.0960, 72.8977);
  final List<LatLng> _driverPath = [];
  String _status = 'Waiting for driver...';
  double _etaMinutes = 30;
  Timer? _etaTimer;

  @override
  void initState() {
    super.initState();
    _socket = ref.read(socketServiceProvider);
    _socket.connect();
    _socket.trackOrder(widget.orderId);
    _loadOrderDetails();

    _socket.on('driver:locationUpdate', (data) {
      if (data is Map<String, dynamic> && mounted) {
        final lat = (data['latitude'] as num).toDouble();
        final lng = (data['longitude'] as num).toDouble();
        setState(() {
          _driverLocation = LatLng(lat, lng);
          _driverPath.add(LatLng(lat, lng));
        });
        _mapController.move(LatLng(lat, lng), 15);
      }
    });

    _socket.on('order:statusUpdate', (data) {
      if (data is Map<String, dynamic> && mounted) {
        final status = data['status'] as String?;
        final details = data['details'] as Map<String, dynamic>?;
        setState(() {
          _status = _statusLabel(status);
          if (details != null && details['etaMinutes'] != null) {
            _etaMinutes = (details['etaMinutes'] as num).toDouble();
          }
        });
        ref.read(orderStatusProvider.notifier).set(status);

        // Local push notification
        NotificationService.show(title: _status, body: 'Order ${widget.orderId.substring(0, 8)}...');

        // In-app notification
        ref.read(appNotificationsProvider.notifier).add(AppNotification(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: _status,
          body: 'Your fuel delivery status has been updated.',
          timestamp: DateTime.now(),
          type: 'delivery',
        ));
      }
    });

    _socket.on('notification:new', (data) {
      if (data is Map<String, dynamic> && mounted) {
        final title = (data['title'] ?? 'Notification').toString();
        final body = (data['body'] ?? '').toString();

        NotificationService.show(title: title, body: body);

        ref.read(appNotificationsProvider.notifier).add(AppNotification(
          id: (data['id'] ?? DateTime.now().millisecondsSinceEpoch).toString(),
          title: title,
          body: body,
          timestamp: DateTime.now(),
          type: 'order',
        ));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(title), backgroundColor: const Color(0xFFFF6B35)),
        );
      }
    });

    _etaTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (_etaMinutes > 0 && mounted) setState(() => _etaMinutes -= 1);
    });
  }

  Future<void> _loadOrderDetails() async {
    try {
      final response = await DioClient.instance.get('/tracking/order/${widget.orderId}');
      final data = (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      if (data['address'] != null && mounted) {
        final addr = data['address'] as Map<String, dynamic>;
        setState(() {
          _deliveryLocation = LatLng(
            (addr['latitude'] as num).toDouble(),
            (addr['longitude'] as num).toDouble(),
          );
          _driverLocation = LatLng(_deliveryLocation.latitude + 0.02, _deliveryLocation.longitude + 0.02);
        });
        _mapController.move(_deliveryLocation, 14);
      }
      if (data['status'] != null) {
        setState(() => _status = _statusLabel(data['status'] as String?));
      }
    } catch (_) {}
  }

  Future<void> _startSimulation() async {
    try {
      await DioClient.instance.post('/tracking/simulate/${widget.orderId}');
    } catch (_) {}
  }

  @override
  void dispose() {
    _socket.untrackOrder(widget.orderId);
    _etaTimer?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _deliveryLocation,
              initialZoom: 14,
              interactionOptions: const InteractionOptions(flags: InteractiveFlag.all & ~InteractiveFlag.rotate),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.fuelrush.mobile',
              ),
              PolylineLayer(
                polylines: [
                  if (_driverPath.length > 1)
                    Polyline(points: _driverPath, color: const Color(0xFF448AFF), strokeWidth: 4),
                  Polyline(
                    points: [_driverLocation, _deliveryLocation],
                    color: const Color(0xFFFF6B35).withValues(alpha: 0.5),
                    strokeWidth: 2,
                    strokeCap: StrokeCap.round,
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  Marker(point: _deliveryLocation, width: 40, height: 40, child: const Icon(Icons.location_on_rounded, color: Color(0xFFFF6B35), size: 40)),
                  Marker(point: _driverLocation, width: 40, height: 40, child: const Icon(Icons.local_shipping_rounded, color: Color(0xFF448AFF), size: 36)),
                ],
              ),
            ],
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.go(RouteNames.home),
                    child: Container(width: 40, height: 40, decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(12)),
                      child: Row(children: [
                        Container(width: 10, height: 10, decoration: BoxDecoration(color: _statusColor(), shape: BoxShape.circle, boxShadow: [BoxShadow(color: _statusColor().withValues(alpha: 0.5), blurRadius: 6)])),
                        const SizedBox(width: 8),
                        Expanded(child: Text(_status, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600))),
                        Text('${_etaMinutes.toStringAsFixed(0)} min', style: const TextStyle(color: Color(0xFFFF6B35), fontSize: 14, fontWeight: FontWeight.w700)),
                      ]),
                    ),
                  ),
                ],
              ).animate().fadeIn(duration: 400.ms),
            ),
          ),

          Positioned(
            left: 16, right: 16, bottom: 40,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.75), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0x1AFFFFFF))),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Row(children: [
                  Container(width: 44, height: 44, decoration: BoxDecoration(color: const Color(0xFF448AFF).withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.local_shipping_rounded, color: Color(0xFF448AFF), size: 22)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Fuel Delivery', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                    Text('Order: ${widget.orderId.substring(0, 8)}...', style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12)),
                  ])),
                  Text('${_etaMinutes.toStringAsFixed(0)} min', style: const TextStyle(color: Color(0xFFFF6B35), fontSize: 20, fontWeight: FontWeight.w700)),
                ]),
                const SizedBox(height: 12),
                Row(children: [
                  _infoChip(Icons.location_on_rounded, 'Delivery', const Color(0xFFFF6B35)),
                  const SizedBox(width: 8),
                  _infoChip(Icons.directions_car_rounded, 'Driver', const Color(0xFF448AFF)),
                  const Spacer(),
                  GestureDetector(onTap: _startSimulation, child: Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8), decoration: BoxDecoration(color: const Color(0xFF448AFF).withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFF448AFF).withValues(alpha: 0.3))), child: const Text('Simulate', style: TextStyle(color: Color(0xFF448AFF), fontSize: 12, fontWeight: FontWeight.w600)))),
                ]),
              ]),
            ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.3),
          ),

          Positioned(
            right: 16, bottom: 160,
            child: GestureDetector(
              onTap: () => _mapController.move(_driverLocation, 15),
              child: Container(width: 44, height: 44, decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.my_location_rounded, color: Colors.white, size: 20)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, color: color, size: 14), const SizedBox(width: 4), Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w500))]),
    );
  }

  Color _statusColor() {
    switch (_status) {
      case 'confirmed': return const Color(0xFF448AFF);
      case 'driver_arriving': return const Color(0xFFFF6B35);
      case 'delivered': return const Color(0xFF00C853);
      default: return const Color(0xFFFFD600);
    }
  }

  String _statusLabel(String? status) {
    switch (status) {
      case 'confirmed': return 'Order Confirmed';
      case 'driver_arriving': return 'Driver Approaching';
      case 'delivered': return 'Fuel Delivered!';
      default: return 'Waiting for driver...';
    }
  }
}
