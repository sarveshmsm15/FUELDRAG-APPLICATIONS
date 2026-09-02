import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../navigation/app_router.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  // Color palette
  static const _bg = Color(0xFFF5EDE4);
  static const _brown = Color(0xFF5C3A1E);
  static const _brownLight = Color(0xFF8B6342);
  static const _brownDark = Color(0xFF3E2210);
  static const _glass = Color(0x40FFFFFF);
  static const _glassBorder = Color(0x60FFFFFF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF8F0E8), Color(0xFFEDE0D4), Color(0xFFF5EDE4), Color(0xFFE8D5C4)],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Decorative glass bubbles
            _bubble(top: -30, left: -20, size: 120, opacity: 0.15),
            _bubble(top: 60, right: -30, size: 90, opacity: 0.12),
            _bubble(bottom: 200, left: -40, size: 100, opacity: 0.10),
            _bubble(bottom: 80, right: -20, size: 140, opacity: 0.13),
            _bubble(top: 300, left: 30, size: 50, opacity: 0.08),
            _bubble(bottom: 350, right: 40, size: 60, opacity: 0.09),

            // Marble vein lines (subtle)
            Positioned(
              top: 100, left: 0, right: 0, bottom: 0,
              child: CustomPaint(painter: _MarbleVeinPainter(), size: Size.infinite),
            ),

            // Main content
            SafeArea(
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // App icon
                  ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        width: 100, height: 100,
                        decoration: BoxDecoration(
                          color: _glass,
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: _glassBorder, width: 1.5),
                          boxShadow: [BoxShadow(color: _brown.withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, 8))],
                        ),
                        child: const Icon(Icons.local_gas_station_rounded, color: _brown, size: 48),
                      ),
                    ),
                  ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.8, 0.8)),

                  const SizedBox(height: 28),

                  // Title
                  const Text(
                    'FUELRUSH',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800, color: _brownDark, letterSpacing: 3),
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),

                  const SizedBox(height: 8),

                  Text(
                    'Fuel delivered to your doorstep',
                    style: TextStyle(fontSize: 16, color: _brownLight.withValues(alpha: 0.8), fontWeight: FontWeight.w400),
                  ).animate().fadeIn(delay: 300.ms),

                  const SizedBox(height: 40),

                  // Feature cards
                  _featureCard(Icons.bolt_rounded, 'Fast Delivery', 'Fuel in 30 minutes', 400),
                  const SizedBox(height: 14),
                  _featureCard(Icons.verified_user_rounded, 'Safe & Secure', 'Licensed & insured drivers', 500),
                  const SizedBox(height: 14),
                  _featureCard(Icons.account_balance_wallet_rounded, 'Best Prices', 'Same as pump price', 600),

                  const Spacer(flex: 2),

                  // Get Started button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: GestureDetector(
                      onTap: () => context.go(RouteNames.login),
                      child: Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [_brownLight, _brown, _brownDark]),
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [BoxShadow(color: _brown.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 6))],
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 22),
                            SizedBox(width: 10),
                            Text('GET STARTED', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700, letterSpacing: 1.5)),
                          ],
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.3),

                  const SizedBox(height: 20),

                  // Footer
                  RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 12, color: _brownLight.withValues(alpha: 0.6)),
                      children: [
                        const TextSpan(text: 'By continuing, you agree to our '),
                        TextSpan(text: 'Terms', style: TextStyle(color: _brown, fontWeight: FontWeight.w600)),
                        const TextSpan(text: ' & '),
                        TextSpan(text: 'Privacy Policy', style: TextStyle(color: _brown, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ).animate().fadeIn(delay: 800.ms),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _featureCard(IconData icon, String title, String subtitle, int delayMs) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: _glass,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _glassBorder, width: 1),
              boxShadow: [BoxShadow(color: _brown.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: Row(
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: _brown.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: _brown, size: 22),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: _brownDark)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: TextStyle(fontSize: 13, color: _brownLight.withValues(alpha: 0.7))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: delayMs.ms).slideX(begin: -0.1);
  }

  Widget _bubble({double? top, double? bottom, double? left, double? right, required double size, required double opacity}) {
    return Positioned(
      top: top, bottom: bottom, left: left, right: right,
      child: Container(
        width: size, height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [Colors.white.withValues(alpha: opacity + 0.1), Colors.white.withValues(alpha: opacity * 0.3)],
          ),
          border: Border.all(color: Colors.white.withValues(alpha: opacity + 0.05), width: 1),
        ),
      ),
    );
  }
}

class _MarbleVeinPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFC4A882).withValues(alpha: 0.08)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Subtle vein lines
    final path1 = Path()
      ..moveTo(size.width * 0.1, size.height * 0.15)
      ..quadraticBezierTo(size.width * 0.4, size.height * 0.2, size.width * 0.7, size.height * 0.1)
      ..quadraticBezierTo(size.width * 0.9, size.height * 0.05, size.width, size.height * 0.15);

    final path2 = Path()
      ..moveTo(0, size.height * 0.5)
      ..quadraticBezierTo(size.width * 0.3, size.height * 0.45, size.width * 0.6, size.height * 0.55)
      ..quadraticBezierTo(size.width * 0.8, size.height * 0.6, size.width, size.height * 0.5);

    final path3 = Path()
      ..moveTo(size.width * 0.2, size.height * 0.8)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.75, size.width * 0.8, size.height * 0.85);

    canvas.drawPath(path1, paint);
    canvas.drawPath(path2, paint);
    canvas.drawPath(path3, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
