import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HelpSupportScreen extends ConsumerWidget {
  const HelpSupportScreen({super.key});

  static const _brown = Color(0xFF5C3A1E);
  static const _brownLight = Color(0xFF8B6342);
  static const _brownDark = Color(0xFF3E2210);
  static const _glass = Color(0x40FFFFFF);
  static const _glassBorder = Color(0x60FFFFFF);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                    // Top bar
                    Row(
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
                    const SizedBox(height: 20),

                    // Title
                    const Text('Need Help?', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: _brownDark, decoration: TextDecoration.none)),
                    const SizedBox(height: 6),
                    Text("We're here to assist you, 24×7", style: TextStyle(fontSize: 15, color: _brownLight.withValues(alpha: 0.7), decoration: TextDecoration.none)),
                    const SizedBox(height: 28),

                    // Call Support
                    _supportCard(
                      context,
                      icon: Icons.phone_rounded,
                      title: 'Call Support',
                      subtitle: 'Talk to our support team',
                      onTap: () {},
                    ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.1),
                    const SizedBox(height: 12),

                    // Live Chat
                    _supportCard(
                      context,
                      icon: Icons.chat_rounded,
                      title: 'Live Chat',
                      subtitle: 'Chat with our support team',
                      onTap: () {},
                    ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1),
                    const SizedBox(height: 12),

                    // Cancel Order
                    _supportCard(
                      context,
                      icon: Icons.cancel_rounded,
                      title: 'Cancel Order',
                      subtitle: 'Cancel your current order',
                      onTap: () {},
                    ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.1),
                    const SizedBox(height: 12),

                    // FAQ
                    _supportCard(
                      context,
                      icon: Icons.help_outline_rounded,
                      title: 'FAQ',
                      subtitle: 'Find answers to common questions',
                      onTap: () {},
                    ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.1),
                    const SizedBox(height: 28),

                    // Your Order is Safe section
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(color: _glass, borderRadius: BorderRadius.circular(24), border: Border.all(color: _glassBorder)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    const Text('Your Order is Safe', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: _brownDark, decoration: TextDecoration.none)),
                                    const SizedBox(height: 4),
                                    Text('We take your safety seriously', style: TextStyle(fontSize: 13, color: _brownLight.withValues(alpha: 0.7), decoration: TextDecoration.none)),
                                  ])),
                                  // Shield icon
                                  Container(
                                    width: 70, height: 70,
                                    decoration: BoxDecoration(
                                      gradient: RadialGradient(colors: [_brown.withValues(alpha: 0.15), _brown.withValues(alpha: 0.05)]),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.verified_user_rounded, color: _brown, size: 36),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),

                              // Safety features grid
                              Row(
                                children: [
                                  Expanded(child: _safetyCard(Icons.person_pin_circle_rounded, 'Driver Verified', 'All our drivers are background verified')),
                                  const SizedBox(width: 10),
                                  Expanded(child: _safetyCard(Icons.location_on_rounded, 'GPS Tracking', 'Track your order in real-time')),
                                  const SizedBox(width: 10),
                                  Expanded(child: _safetyCard(Icons.headset_mic_rounded, 'Support Available', "We're available for you 24×7")),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Data security banner
                              ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  decoration: BoxDecoration(color: _brown.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: _brown.withValues(alpha: 0.1))),
                                  child: Row(children: [
                                    const Icon(Icons.lock_rounded, color: _brown, size: 18),
                                    const SizedBox(width: 10),
                                    Expanded(child: Text('Your data is secure and encrypted', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _brownDark, decoration: TextDecoration.none))),
                                  ]),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.15),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _supportCard(BuildContext context, {required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(color: _glass, borderRadius: BorderRadius.circular(20), border: Border.all(color: _glassBorder)),
            child: Row(children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(color: _brown.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(14)),
                child: Icon(icon, color: _brown, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _brownDark, decoration: TextDecoration.none)),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(fontSize: 13, color: _brownLight.withValues(alpha: 0.7), decoration: TextDecoration.none)),
              ])),
              Icon(Icons.chevron_right_rounded, color: _brownLight.withValues(alpha: 0.4), size: 24),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _safetyCard(IconData icon, String title, String subtitle) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(16), border: Border.all(color: _glassBorder)),
          child: Column(children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(color: _brown.withValues(alpha: 0.08), shape: BoxShape.circle),
              child: Icon(icon, color: _brown, size: 20),
            ),
            const SizedBox(height: 8),
            Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _brownDark, decoration: TextDecoration.none)),
            const SizedBox(height: 3),
            Text(subtitle, textAlign: TextAlign.center, style: TextStyle(fontSize: 9, color: _brownLight.withValues(alpha: 0.6), decoration: TextDecoration.none, height: 1.2)),
          ]),
        ),
      ),
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
