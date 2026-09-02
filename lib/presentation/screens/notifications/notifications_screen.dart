import 'package:go_router/go_router.dart';
import '../../navigation/app_router.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});
  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  int _selectedTab = 0;

  static const _brown = Color(0xFF5C3A1E);
  static const _brownLight = Color(0xFF8B6342);
  static const _brownDark = Color(0xFF3E2210);
  static const _glass = Color(0x40FFFFFF);
  static const _glassBorder = Color(0x60FFFFFF);

  final List<_NotifItem> _allNotifs = const [
    _NotifItem('Order Delivered', 'Your fuel order #FR123456 has been delivered successfully.', '2m ago', Icons.local_gas_station_rounded, Color(0xFF5C3A1E), false, 'order'),
    _NotifItem('Driver Approaching', 'Your driver is on the way and will reach you in 5 minutes.', '10m ago', Icons.delivery_dining_rounded, Color(0xFF8B6342), false, 'order'),
    _NotifItem('Special Offer', 'Get 5% OFF on your next order. Use code: FUEL5', '1h ago', Icons.local_offer_rounded, Color(0xFF7B1FA2), true, 'offer'),
    _NotifItem('Wallet Credited', '\u20b9300 has been added to your wallet.', '3h ago', Icons.account_balance_wallet_rounded, Color(0xFF1565C0), true, 'order'),
    _NotifItem('Reminder', "Don't forget! You have a scheduled order today at 06:00 PM.", '1d ago', Icons.notifications_active_rounded, Color(0xFF2E7D32), true, 'order'),
    _NotifItem('Security Alert', 'New login detected on your account.', '2d ago', Icons.shield_rounded, Color(0xFF616161), true, 'order'),
  ];

  List<_NotifItem> get _filtered {
    if (_selectedTab == 0) return _allNotifs;
    if (_selectedTab == 1) return _allNotifs.where((n) => n.category == 'order').toList();
    return _allNotifs.where((n) => n.category == 'offer').toList();
  }

  @override
  Widget build(BuildContext context) {
    final notifs = _filtered;
    return Container(
      width: double.infinity, height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [Color(0xFFF8F0E8), Color(0xFFEDE0D4), Color(0xFFF5EDE4), Color(0xFFE8D5C4)],
          stops: [0.0, 0.3, 0.7, 1.0]),
      ),
      child: Stack(
        children: [
          _bubble(top: -30, right: -20, size: 120, opacity: 0.12),
          _bubble(bottom: 100, left: -30, size: 100, opacity: 0.10),
          _bubble(bottom: -20, right: -25, size: 140, opacity: 0.11),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () { final shell = StatefulNavigationShell.maybeOf(context); if (shell != null) { shell.goBranch(0); } else { context.go(RouteNames.home); } },
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
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Notifications', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: _brownDark, decoration: TextDecoration.none)),
                            Text('Stay updated with your orders\nand important alerts', style: TextStyle(fontSize: 13, color: _brownLight.withValues(alpha: 0.7), height: 1.3, decoration: TextDecoration.none)),
                          ],
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                          child: Container(
                            width: 44, height: 44,
                            decoration: BoxDecoration(color: _glass, borderRadius: BorderRadius.circular(14), border: Border.all(color: _glassBorder)),
                            child: const Icon(Icons.settings_rounded, color: _brown, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 400.ms),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(color: _glass, borderRadius: BorderRadius.circular(16), border: Border.all(color: _glassBorder)),
                        child: Row(children: [_tab(0, 'All'), _tab(1, 'Orders'), _tab(2, 'Offers')]),
                      ),
                    ),
                  ),
                ).animate().fadeIn(delay: 100.ms),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: notifs.length,
                    itemBuilder: (context, index) => _notifCard(notifs[index], index),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tab(int index, String label) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            gradient: isSelected ? const LinearGradient(colors: [_brownLight, _brown, _brownDark]) : null,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: [
            Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: isSelected ? Colors.white : _brownLight.withValues(alpha: 0.6), decoration: TextDecoration.none)),
            if (isSelected) ...[const SizedBox(height: 4), Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle))],
          ]),
        ),
      ),
    );
  }

  Widget _notifCard(_NotifItem n, int index) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: _glass, borderRadius: BorderRadius.circular(18), border: Border.all(color: _glassBorder)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(color: n.iconColor.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(14)),
                child: Icon(n.icon, color: n.iconColor, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(n.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: _brownDark, decoration: TextDecoration.none)),
                        Text(n.time, style: TextStyle(fontSize: 12, color: _brownLight.withValues(alpha: 0.5), decoration: TextDecoration.none)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(n.body, style: TextStyle(fontSize: 13, color: _brownLight.withValues(alpha: 0.7), height: 1.4, decoration: TextDecoration.none)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 10, height: 10,
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(color: n.isRead ? _brownLight.withValues(alpha: 0.2) : _brownDark, shape: BoxShape.circle),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: (index * 80).ms).slideX(begin: -0.1);
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

class _NotifItem {
  final String title;
  final String body;
  final String time;
  final IconData icon;
  final Color iconColor;
  final bool isRead;
  final String category;
  const _NotifItem(this.title, this.body, this.time, this.icon, this.iconColor, this.isRead, this.category);
}
