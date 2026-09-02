import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../providers/auth/auth_provider.dart';
import '../../navigation/app_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneController = TextEditingController();
  bool _isSignUp = false;
  bool _isLoading = false;

  static const _bg = Color(0xFFF5EDE4);
  static const _brown = Color(0xFF5C3A1E);
  static const _brownLight = Color(0xFF8B6342);
  static const _brownDark = Color(0xFF3E2210);
  static const _glass = Color(0x40FFFFFF);
  static const _glassBorder = Color(0x60FFFFFF);

  Future<void> _sendOtp() async {
    final phone = _phoneController.text.trim();
    if (phone.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid 10-digit phone number'), backgroundColor: _brown),
      );
      return;
    }
    setState(() => _isLoading = true);
    try {
      final result = await ref.read(authStateProvider.notifier).sendOtp(phone);
      if (result.success && mounted) context.push(RouteNames.otp, extra: phone);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: const Color(0xFFFF1744)));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() { _phoneController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity, height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFFF8F0E8), Color(0xFFEDE0D4), Color(0xFFF5EDE4), Color(0xFFE8D5C4)], stops: [0.0, 0.3, 0.7, 1.0]),
        ),
        child: Stack(
          children: [
            // Bubbles
            _bubble(top: -20, left: -30, size: 110, opacity: 0.12),
            _bubble(top: 80, right: -20, size: 80, opacity: 0.10),
            _bubble(bottom: 150, left: -30, size: 100, opacity: 0.08),
            _bubble(bottom: 50, right: -25, size: 120, opacity: 0.11),

            // Marble veins
            Positioned(top: 0, left: 0, right: 0, bottom: 0, child: CustomPaint(painter: _VeinPainter(), size: Size.infinite)),

            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  children: [
                    const SizedBox(height: 16),

                    // Back button
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () => context.go(RouteNames.onboarding),
                        child: Icon(Icons.arrow_back_rounded, color: _brown.withValues(alpha: 0.6), size: 28),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // App icon
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          width: 80, height: 80,
                          decoration: BoxDecoration(color: _glass, borderRadius: BorderRadius.circular(24), border: Border.all(color: _glassBorder, width: 1.5)),
                          child: const Icon(Icons.local_gas_station_rounded, color: _brown, size: 40),
                        ),
                      ),
                    ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.8, 0.8)),

                    const SizedBox(height: 24),

                    // Title
                    Text(
                      _isSignUp ? 'Create your account' : 'Welcome back!',
                      style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: _brownDark),
                    ).animate().fadeIn(delay: 100.ms),

                    const SizedBox(height: 6),

                    Text(
                      _isSignUp ? 'Join FUELRUSH for fast fuel delivery' : 'Sign in to continue to FUELRUSH',
                      style: TextStyle(fontSize: 14, color: _brownLight.withValues(alpha: 0.7)),
                    ).animate().fadeIn(delay: 200.ms),

                    const SizedBox(height: 32),

                    // Phone input
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(color: _glass, borderRadius: BorderRadius.circular(16), border: Border.all(color: _glassBorder, width: 1)),
                          child: Row(
                            children: [
                              Text('+91', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: _brown)),
                              Container(width: 1, height: 24, margin: const EdgeInsets.symmetric(horizontal: 12), color: _brown.withValues(alpha: 0.2)),
                              Expanded(
                                child: TextField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  maxLength: 10,
                                  style: TextStyle(fontSize: 16, color: _brownDark),
                                  decoration: InputDecoration(
                                    hintText: 'Phone number',
                                    hintStyle: TextStyle(color: _brownLight.withValues(alpha: 0.4), fontSize: 16),
                                    border: InputBorder.none,
                                    counterText: '',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ).animate().fadeIn(delay: 300.ms),

                    const SizedBox(height: 20),

                    // Send OTP button
                    GestureDetector(
                      onTap: _isLoading ? null : _sendOtp,
                      child: Container(
                        width: double.infinity, height: 52,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [_brownLight, _brown, _brownDark]),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [BoxShadow(color: _brown.withValues(alpha: 0.25), blurRadius: 12, offset: const Offset(0, 4))],
                        ),
                        child: Center(
                          child: _isLoading
                              ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                              : const Text('SEND OTP', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 1.5)),
                        ),
                      ),
                    ).animate().fadeIn(delay: 400.ms),

                    const SizedBox(height: 20),

                    // Divider
                    Row(children: [
                      Expanded(child: Divider(color: _brown.withValues(alpha: 0.15))),
                      Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text('or', style: TextStyle(color: _brownLight.withValues(alpha: 0.5), fontSize: 13))),
                      Expanded(child: Divider(color: _brown.withValues(alpha: 0.15))),
                    ]),

                    const SizedBox(height: 20),

                    // Google sign in (triggers OTP flow as fallback)
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Google Sign-In coming soon! Use phone OTP for now.'), backgroundColor: _brown),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                          child: Container(
                            width: double.infinity, height: 52,
                            decoration: BoxDecoration(color: _glass, borderRadius: BorderRadius.circular(16), border: Border.all(color: _glassBorder, width: 1)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: 20, height: 20, child: CustomPaint(painter: _GoogleIconPainter())),
                                const SizedBox(width: 12),
                                Text('Continue with Google', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: _brownDark)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ).animate().fadeIn(delay: 500.ms),

                    const SizedBox(height: 24),

                    // Toggle sign in / sign up
                    GestureDetector(
                      onTap: () => setState(() => _isSignUp = !_isSignUp),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 14, color: _brownLight.withValues(alpha: 0.7)),
                          children: [
                            TextSpan(text: _isSignUp ? 'Already have an account? ' : "Don't have an account? "),
                            TextSpan(
                              text: _isSignUp ? 'Sign In' : 'Sign Up',
                              style: const TextStyle(color: _brown, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(delay: 600.ms),

                    const SizedBox(height: 32),

                    // Security badge
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(color: _glass, borderRadius: BorderRadius.circular(14), border: Border.all(color: _glassBorder, width: 1)),
                          child: Row(
                            children: [
                              Icon(Icons.verified_user_rounded, color: _brown.withValues(alpha: 0.6), size: 20),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Your data is safe with us', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _brownDark)),
                                  Text('We never share your information', style: TextStyle(fontSize: 11, color: _brownLight.withValues(alpha: 0.5))),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ).animate().fadeIn(delay: 700.ms),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bubble({double? top, double? bottom, double? left, double? right, required double size, required double opacity}) {
    return Positioned(
      top: top, bottom: bottom, left: left, right: right,
      child: Container(
        width: size, height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [Colors.white.withValues(alpha: opacity + 0.1), Colors.white.withValues(alpha: opacity * 0.3)]),
          border: Border.all(color: Colors.white.withValues(alpha: opacity + 0.05), width: 1),
        ),
      ),
    );
  }
}

class _VeinPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFFC4A882).withValues(alpha: 0.06)..strokeWidth = 1.2..style = PaintingStyle.stroke;
    canvas.drawPath(Path()..moveTo(size.width * 0.05, size.height * 0.12)..quadraticBezierTo(size.width * 0.4, size.height * 0.18, size.width * 0.75, size.height * 0.08), paint);
    canvas.drawPath(Path()..moveTo(0, size.height * 0.55)..quadraticBezierTo(size.width * 0.35, size.height * 0.48, size.width * 0.65, size.height * 0.58), paint);
    canvas.drawPath(Path()..moveTo(size.width * 0.15, size.height * 0.85)..quadraticBezierTo(size.width * 0.5, size.height * 0.78, size.width * 0.85, size.height * 0.88), paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Simplified Google "G" using colored arcs
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 1;
    final strokeWidth = 2.5;

    // Blue
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -0.5, 1.2, false, Paint()..color = const Color(0xFF4285F4)..style = PaintingStyle.stroke..strokeWidth = strokeWidth);
    // Red
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), 0.7, 1.0, false, Paint()..color = const Color(0xFFEA4335)..style = PaintingStyle.stroke..strokeWidth = strokeWidth);
    // Yellow
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), 1.7, 1.0, false, Paint()..color = const Color(0xFFFBBC05)..style = PaintingStyle.stroke..strokeWidth = strokeWidth);
    // Green
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), 2.7, 1.2, false, Paint()..color = const Color(0xFF34A853)..style = PaintingStyle.stroke..strokeWidth = strokeWidth);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
