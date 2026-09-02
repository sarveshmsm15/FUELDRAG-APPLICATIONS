import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../providers/auth/auth_provider.dart';
import '../../navigation/app_router.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key, required this.phone});
  final String phone;
  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isLoading = false;
  int _resendTimer = 45;
  Timer? _timer;

  static const _brown = Color(0xFF5C3A1E);
  static const _brownLight = Color(0xFF8B6342);
  static const _brownDark = Color(0xFF3E2210);
  static const _glass = Color(0x40FFFFFF);
  static const _glassBorder = Color(0x60FFFFFF);

  @override
  void initState() {
    super.initState();
    _startResendTimer();
    for (int i = 0; i < 5; i++) {
      _controllers[i].addListener(() {
        if (_controllers[i].text.length == 1) _focusNodes[i + 1].requestFocus();
      });
    }
  }

  void _startResendTimer() {
    _timer?.cancel();
    setState(() => _resendTimer = 45);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_resendTimer > 0) {
        setState(() => _resendTimer--);
      } else {
        t.cancel();
      }
    });
  }

  Future<void> _verifyOtp() async {
    final otp = _controllers.map((c) => c.text).join();
    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter the complete 6-digit OTP'), backgroundColor: _brown));
      return;
    }
    setState(() => _isLoading = true);
    try {
      final result = await ref
          .read(authStateProvider.notifier)
          .verifyOtp(widget.phone, otp);

      if (!mounted) return;

      if (result.success) {
        context.go(RouteNames.home);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message),
            backgroundColor: const Color(0xFFFF1744),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid OTP: $e'), backgroundColor: const Color(0xFFFF1744)));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resendOtp() async {
    if (_resendTimer > 0) return;
    try {
      await ref.read(authStateProvider.notifier).sendOtp(widget.phone);
      _startResendTimer();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('OTP resent!'), backgroundColor: _brown));
    } catch (_) {}
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity, height: double.infinity,
        decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFFF8F0E8), Color(0xFFEDE0D4), Color(0xFFF5EDE4), Color(0xFFE8D5C4)], stops: [0.0, 0.3, 0.7, 1.0])),
        child: Stack(
          children: [
            _bubble(top: -20, right: -30, size: 100, opacity: 0.12),
            _bubble(bottom: 100, left: -25, size: 90, opacity: 0.10),
            _bubble(bottom: -20, right: -20, size: 130, opacity: 0.11),
            Positioned(top: 0, left: 0, right: 0, bottom: 0, child: CustomPaint(painter: _OtpVeinPainter(), size: Size.infinite)),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Align(alignment: Alignment.centerLeft, child: GestureDetector(onTap: () => context.pop(), child: Icon(Icons.arrow_back_rounded, color: _brown.withValues(alpha: 0.6), size: 28))),
                    const SizedBox(height: 32),

                    // Icon
                    ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          width: 72, height: 72,
                          decoration: BoxDecoration(color: _glass, borderRadius: BorderRadius.circular(22), border: Border.all(color: _glassBorder, width: 1.5)),
                          child: const Icon(Icons.local_gas_station_rounded, color: _brown, size: 36),
                        ),
                      ),
                    ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.8, 0.8)),

                    const SizedBox(height: 24),

                    const Text('Verify your number', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: _brownDark)).animate().fadeIn(delay: 100.ms),
                    const SizedBox(height: 8),

                    RichText(
                      text: TextSpan(
                        style: TextStyle(fontSize: 14, color: _brownLight.withValues(alpha: 0.7)),
                        children: [
                          const TextSpan(text: 'Enter the 6-digit code sent to\n'),
                          TextSpan(text: '+91 ${widget.phone}', style: const TextStyle(fontWeight: FontWeight.w700, color: _brownDark)),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(delay: 200.ms),

                    const SizedBox(height: 6),

                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Text('Change', style: TextStyle(fontSize: 13, color: _brown, fontWeight: FontWeight.w600)),
                    ).animate().fadeIn(delay: 250.ms),

                    const SizedBox(height: 32),

                    // OTP boxes
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(6, (i) => _otpBox(i)),
                    ).animate().fadeIn(delay: 300.ms),

                    const SizedBox(height: 24),

                    // Resend timer
                    _resendTimer > 0
                        ? RichText(
                            text: TextSpan(
                              style: TextStyle(fontSize: 13, color: _brownLight.withValues(alpha: 0.6)),
                              children: [
                                const TextSpan(text: "Didn't receive code? Resend in "),
                                TextSpan(
                                  text: '${(_resendTimer ~/ 60).toString().padLeft(2, '0')}:${(_resendTimer % 60).toString().padLeft(2, '0')}',
                                  style: const TextStyle(fontWeight: FontWeight.w700, color: _brownDark),
                                ),
                              ],
                            ),
                          )
                        : GestureDetector(
                            onTap: _resendOtp,
                            child: Text("Didn't receive code? Resend", style: TextStyle(fontSize: 13, color: _brown, fontWeight: FontWeight.w600)),
                          ),

                    const Spacer(),

                    // Verify button
                    GestureDetector(
                      onTap: _isLoading ? null : _verifyOtp,
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
                              : const Text('VERIFY & CONTINUE', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 1.5)),
                        ),
                      ),
                    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _otpBox(int index) {
    return SizedBox(
      width: 48, height: 56,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            decoration: BoxDecoration(color: _glass, borderRadius: BorderRadius.circular(14), border: Border.all(color: _glassBorder, width: 1)),
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 1,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: _brownDark),
              decoration: const InputDecoration(border: InputBorder.none, counterText: ''),
              onChanged: (v) {
                if (v.isEmpty && index > 0) _focusNodes[index - 1].requestFocus();
                if (index == 5 && v.isNotEmpty) _verifyOtp();
              },
            ),
          ),
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

class _OtpVeinPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFFC4A882).withValues(alpha: 0.06)..strokeWidth = 1.2..style = PaintingStyle.stroke;
    canvas.drawPath(Path()..moveTo(size.width * 0.1, size.height * 0.1)..quadraticBezierTo(size.width * 0.5, size.height * 0.15, size.width * 0.9, size.height * 0.05), paint);
    canvas.drawPath(Path()..moveTo(0, size.height * 0.6)..quadraticBezierTo(size.width * 0.4, size.height * 0.55, size.width * 0.7, size.height * 0.65), paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
