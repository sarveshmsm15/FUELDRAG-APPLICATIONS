import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../providers/tracking/tracking_provider.dart';
import '../../../services/socket/socket_service.dart';
import '../../../data/repositories/order_repository.dart';

class TrackingScreen extends ConsumerStatefulWidget {
  const TrackingScreen({super.key, required this.orderId});
  final String orderId;

  @override
  ConsumerState<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends ConsumerState<TrackingScreen> {
  late final SocketService _socket;

  @override
  void initState() {
    super.initState();
    _socket = context.read(socketServiceProvider);
    _socket.connect();
    _socket.trackOrder(widget.orderId);

    _socket.on('driver:locationUpdate', (data) {
      if (data is Map<String, dynamic> && mounted) {
        ref.read(driverLocationProvider.notifier).state = DriverLocation(
          latitude: (data['latitude'] as num).toDouble(),
          longitude: (data['longitude'] as num).toDouble(),
          timestamp: DateTime.parse(data['timestamp'] as String),
        );
      }
    });

    _socket.on('order:statusUpdate', (data) {
      if (data is Map<String, dynamic> && mounted) {
        ref.read(orderStatusProvider.notifier).state = data['status'] as String?;
      }
    });

    _socket.on('notification:new', (data) {
      if (data is Map<String, dynamic> && mounted) {
        final notifications = List<Map<String, dynamic>>.from(ref.read(notificationsProvider));
        notifications.insert(0, data);
        ref.read(notificationsProvider.notifier).state = notifications;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['title'] ?? 'Notification'),
            backgroundColor: const Color(0xFFFF6B35),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _socket.untrackOrder(widget.orderId);
    super.dispose();
  }

  Future<void> _startSimulation() async {
    try {
      final dio = DioClient.instance;
      await dio.post('/tracking/simulate/${widget.orderId}');
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final driverLocation = ref.watch(driverLocationProvider);
    final orderStatus = ref.watch(orderStatusProvider);
    final notifications = ref.watch(notificationsProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back
              GestureDetector(
                onTap: () => context.pop(),
                child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white.withValues(alpha: 0.6), size: 20),
              ),
              const SizedBox(height: 16),

              Text('Live Tracking', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white)).animate().fadeIn(),
              const SizedBox(height: 8),
              Text('Order: ${widget.orderId.substring(0, 8)}...', style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.5))).animate().fadeIn(delay: 100.ms),

              const SizedBox(height: 24),

              // Status card
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
                    child: Row(
                      children: [
                        Container(
                          width: 12, height: 12,
                          decoration: BoxDecoration(
                            color: _statusColor(orderStatus),
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: _statusColor(orderStatus).withValues(alpha: 0.5), blurRadius: 8)],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_statusLabel(orderStatus), style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                              Text('Socket: ${_socket.state.name}', style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 200.ms),

              const SizedBox(height: 16),

              // Driver location
              if (driverLocation != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0x14FFFFFF),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF448AFF).withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.location_on_rounded, color: Color(0xFF448AFF), size: 20),
                              const SizedBox(width: 8),
                              const Text('Driver Location', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text('${driverLocation.latitude.toStringAsFixed(6)}, ${driverLocation.longitude.toStringAsFixed(6)}',
                            style: const TextStyle(color: Color(0xFF448AFF), fontSize: 14, fontFamily: 'monospace')),
                          Text('Updated: ${driverLocation.timestamp.toLocal().toString().substring(11, 19)}',
                            style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 11)),
                        ],
                      ),
                    ),
                  ),
                ).animate().fadeIn(),

              const SizedBox(height: 16),

              // Notifications
              if (notifications.isNotEmpty) ...[
                Text('Notifications (${notifications.length})', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                ...notifications.take(3).map((n) => ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(color: const Color(0xFFFF6B35).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                    child: Row(children: [
                      const Icon(Icons.notifications_active_rounded, color: Color(0xFFFF6B35), size: 14),
                      const SizedBox(width: 8),
                      Expanded(child: Text(n['title'] ?? '', style: const TextStyle(color: Colors.white, fontSize: 12))),
                    ]),
                  ),
                )),
              ],

              const Spacer(),

              // Simulate button (dev only)
              GestureDetector(
                onTap: _startSimulation,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      width: double.infinity, height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFF448AFF).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF448AFF).withValues(alpha: 0.4)),
                      ),
                      child: const Center(child: Text('🚀 START DRIVER SIMULATION', style: TextStyle(color: Color(0xFF448AFF), fontSize: 16, fontWeight: FontWeight.w600))),
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 400.ms),

              const SizedBox(height: 8),
              Center(child: Text('Phase 8 — Real-time Tracking ✓', style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.2)))),
            ],
          ),
        ),
      ),
    );
  }

  Color _statusColor(String? status) {
    switch (status) {
      case 'confirmed': return const Color(0xFF448AFF);
      case 'driver_arriving': return const Color(0xFFFF6B35);
      case 'delivered': return const Color(0xFF00C853);
      default: return const Color(0xFFFFD600);
    }
  }

  String _statusLabel(String? status) {
    switch (status) {
      case 'confirmed': return '✅ Order Confirmed — Driver Assigned';
      case 'driver_arriving': return '🚗 Driver Approaching — ETA 5 min';
      case 'delivered': return '⛽ Fuel Delivered!';
      default: return '⏳ Waiting for driver...';
    }
  }
}

// Need this import at top
import '../../../services/api/dio_client.dart';