import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../services/notifications/notification_service.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(appNotificationsProvider);
    final unreadCount = notifications.where((n) => !n.isRead).length;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white.withValues(alpha: 0.6), size: 20),
                      ),
                      const SizedBox(width: 12),
                      const Text('Notifications', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white)),
                      if (unreadCount > 0)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(color: const Color(0xFFFF6B35), borderRadius: BorderRadius.circular(10)),
                          child: Text('$unreadCount', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                        ),
                    ],
                  ),
                  if (notifications.isNotEmpty)
                    GestureDetector(
                      onTap: () => ref.read(appNotificationsProvider.notifier).markAllRead(),
                      child: Text('Mark all read', style: TextStyle(color: const Color(0xFFFF6B35).withValues(alpha: 0.8), fontSize: 13)),
                    ),
                ],
              ).animate().fadeIn(),

              const SizedBox(height: 20),

              // Notification list
              Expanded(
                child: notifications.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.notifications_none_rounded, color: Colors.white.withValues(alpha: 0.2), size: 64),
                            const SizedBox(height: 16),
                            Text('No notifications yet', style: TextStyle(color: Colors.white.withValues(alpha: 0.3), fontSize: 16)),
                            const SizedBox(height: 8),
                            Text('Place an order to receive updates', style: TextStyle(color: Colors.white.withValues(alpha: 0.2), fontSize: 13)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          final n = notifications[index];
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: n.isRead ? const Color(0x0AFFFFFF) : const Color(0x14FFFFFF),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: n.isRead ? const Color(0x0AFFFFFF) : const Color(0xFFFF6B35).withValues(alpha: 0.2),
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Unread dot
                                    if (!n.isRead)
                                      Container(
                                        width: 8, height: 8,
                                        margin: const EdgeInsets.only(top: 6, right: 10),
                                        decoration: const BoxDecoration(color: Color(0xFFFF6B35), shape: BoxShape.circle),
                                      )
                                    else
                                      const SizedBox(width: 18),
                                    // Icon
                                    Container(
                                      width: 36, height: 36,
                                      decoration: BoxDecoration(
                                        color: _notifColor(n.type).withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(_notifIcon(n.type), color: _notifColor(n.type), size: 18),
                                    ),
                                    const SizedBox(width: 12),
                                    // Content
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(n.title, style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: n.isRead ? FontWeight.w400 : FontWeight.w600)),
                                          const SizedBox(height: 2),
                                          Text(n.body, style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
                                          const SizedBox(height: 4),
                                          Text(_timeAgo(n.timestamp), style: TextStyle(color: Colors.white.withValues(alpha: 0.3), fontSize: 11)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ).animate().fadeIn(delay: (index * 50).ms).slideX(begin: -0.1);
                        },
                      ),
              ),

              // Clear button
              if (notifications.isNotEmpty)
                GestureDetector(
                  onTap: () => ref.read(appNotificationsProvider.notifier).clear(),
                  child: Center(
                    child: Text('Clear all', style: TextStyle(color: Colors.white.withValues(alpha: 0.3), fontSize: 13)),
                  ),
                ),

              const SizedBox(height: 8),
              Center(child: Text('Phase 11 \u2014 Notifications \u2713', style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.2)))),
            ],
          ),
        ),
      ),
    );
  }

  Color _notifColor(String? type) {
    switch (type) {
      case 'order': return const Color(0xFF448AFF);
      case 'delivery': return const Color(0xFF00C853);
      case 'promo': return const Color(0xFFFF6B35);
      default: return const Color(0xFFFFD600);
    }
  }

  IconData _notifIcon(String? type) {
    switch (type) {
      case 'order': return Icons.receipt_long_rounded;
      case 'delivery': return Icons.local_shipping_rounded;
      case 'promo': return Icons.local_offer_rounded;
      default: return Icons.notifications_rounded;
    }
  }

  String _timeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
