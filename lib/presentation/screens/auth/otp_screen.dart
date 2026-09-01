import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  String? _error;
  int _countdown = 30;

  @override
  void initState() {
    super.initState();
    _startCountdown();
    _focusNodes[0].requestFocus();
  }

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    super.dispose();
  }

  void _startCountdown() {
    _countdown = 30;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() => _countdown--);
      return _countdown > 0;
    });
  }

  String get _otp => _controllers.map((c) => c.text).join();

  Future<void> _verify() async {
    if (_otp.length != 6) {
      setState(() => _error = 'Please enter the complete 6-digit OTP');
      return;
    }

    setState(() { _isLoading = true; _error = null; });

    final result = await ref.read(authStateProvider.notifier).verifyOtp(widget.phone, _otp);

    if (mounted) {
      setState(() => _isLoading = false);
      if (result.success) {
        // Check if new user → profile setup, else → pin setup or home
        final authState = ref.read(authStateProvider);
        if (authState is AuthAuthenticated && authState.isNew) {
          context.go(RouteNames.profileSetup);
        } else if (authState is AuthAuthenticated) {
          context.go(RouteNames.pinSetup);
        }
      } else {
        setState(() => _error = result.message);
      }
    }
  }

  void _onOtpChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    if (_otp.length == 6) {
      _verify();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final maskedPhone = '+91 ${widget.phone.substring(0, 5)} ${widget.phone.substring(5)}';

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),

                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () => context.pop(),
                    child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white.withValues(alpha: 0.6), size: 20),
                  ),
                ),

                const SizedBox(height: 40),

                Container(
                  width: 72, height: 72,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B35).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFFF6B35).withValues(alpha: 0.3)),
                  ),
                  child: const Icon(Icons.lock_clock_rounded, color: Color(0xFFFF6B35), size: 32),
                ).animate().fadeIn(duration: 400.ms),

                const SizedBox(height: 24),

                const Text('Enter OTP', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white))
                  .animate().fadeIn(delay: 100.ms),

                const SizedBox(height: 8),

                Text('Sent to $maskedPhone', style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.5)))
                  .animate().fadeIn(delay: 200.ms),

                const SizedBox(height: 40),

                // OTP Input Boxes
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(6, (index) {
                    return SizedBox(
                      width: 48, height: 56,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0x14FFFFFF),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _error != null ? const Color(0xFFFF1744) : const Color(0x1AFFFFFF),
                              ),
                            ),
                            child: TextField(
                              controller: _controllers[index],
                              focusNode: _focusNodes[index],
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
                              decoration: const InputDecoration(border: InputBorder.none, counterText: ''),
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              onChanged: (v) => _onOtpChanged(index, v),
                            ),
                          ),
                        ),
                      ),
                    ).animate().fadeIn(delay: (300 + index * 50).ms).slideY(begin: 0.1);
                  }),
                ),

                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(_error!, style: const TextStyle(color: Color(0xFFFF1744), fontSize: 12)),
                  ),

                const SizedBox(height: 32),

                // Verify button
                GestureDetector(
                  onTap: _isLoading ? null : _verify,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Container(
                        width: double.infinity, height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF6B35).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFFF6B35).withValues(alpha: 0.4)),
                        ),
                        child: Center(
                          child: _isLoading
                            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2.5, color: Color(0xFFFF6B35)))
                            : const Text('VERIFY OTP', style: TextStyle(color: Color(0xFFFF6B35), fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 1)),
                        ),
                      ),
                    ),
                  ),
                ).animate().fadeIn(delay: 600.ms),

                const SizedBox(height: 24),

                // Resend
                Text(
                  _countdown > 0 ? 'Resend OTP in ${_countdown}s' : 'Resend OTP',
                  style: TextStyle(
                    color: _countdown > 0 ? Colors.white.withValues(alpha: 0.3) : const Color(0xFFFF6B35),
                    fontSize: 14, fontWeight: FontWeight.w500,
                  ),
                ),

                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}