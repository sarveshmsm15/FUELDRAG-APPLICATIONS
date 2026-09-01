import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    final phone =
        _phoneController.text.trim().replaceAll(RegExp(r'[\s\-]'), '');

    if (phone.length != 10 || !RegExp(r'^[6-9]\d{9}$').hasMatch(phone)) {
      setState(() => _error = 'Enter a valid 10-digit phone number');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final result =
        await ref.read(authStateProvider.notifier).sendOtp(phone);

    if (mounted) {
      setState(() => _isLoading = false);
      if (result.success) {
        context.push(RouteNames.otp, extra: phone);
      } else {
        setState(() => _error = result.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints:
                      BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          const SizedBox(height: 20),

                          // Back button
                          Align(
                            alignment: Alignment.topLeft,
                            child: GestureDetector(
                              onTap: () =>
                                  context.go(RouteNames.onboarding),
                              child: Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color:
                                    Colors.white.withValues(alpha: 0.6),
                                size: 20,
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),

                          // Phone icon
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF6B35)
                                  .withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFFFF6B35)
                                    .withValues(alpha: 0.3),
                              ),
                            ),
                            child: const Icon(
                              Icons.phone_android_rounded,
                              color: Color(0xFFFF6B35),
                              size: 32,
                            ),
                          )
                              .animate()
                              .fadeIn(duration: 400.ms)
                              .scale(begin: const Offset(0.9, 0.9)),

                          const SizedBox(height: 24),

                          const Text(
                            'Welcome to FUELRUSH',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ).animate().fadeIn(delay: 100.ms),

                          const SizedBox(height: 8),

                          Text(
                            'Enter your phone number to continue',
                            style: TextStyle(
                              fontSize: 14,
                              color:
                                  Colors.white.withValues(alpha: 0.5),
                            ),
                          ).animate().fadeIn(delay: 200.ms),

                          const SizedBox(height: 40),

                          // Phone input
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                  sigmaX: 16, sigmaY: 16),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0x14FFFFFF),
                                  borderRadius:
                                      BorderRadius.circular(12),
                                  border: Border.all(
                                    color: _error != null
                                        ? const Color(0xFFFF1744)
                                        : const Color(0x1AFFFFFF),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 16),
                                      child: Text(
                                        '+91',
                                        style: TextStyle(
                                          color: Colors.white
                                              .withValues(alpha: 0.7),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 1,
                                      height: 24,
                                      margin:
                                          const EdgeInsets.symmetric(
                                              horizontal: 12),
                                      color: const Color(0x1AFFFFFF),
                                    ),
                                    Expanded(
                                      child: TextField(
                                        controller: _phoneController,
                                        keyboardType:
                                            TextInputType.phone,
                                        maxLength: 10,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          letterSpacing: 1,
                                        ),
                                        decoration:
                                            const InputDecoration(
                                          hintText: 'Phone number',
                                          hintStyle: TextStyle(
                                              color: Color(0x40FFFFFF)),
                                          border: InputBorder.none,
                                          counterText: '',
                                          contentPadding:
                                              EdgeInsets.symmetric(
                                                  vertical: 16),
                                        ),
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
                                        onChanged: (_) =>
                                            setState(() => _error = null),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                              .animate()
                              .fadeIn(delay: 300.ms)
                              .slideY(begin: 0.1),

                          if (_error != null)
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 8, left: 4),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  _error!,
                                  style: const TextStyle(
                                    color: Color(0xFFFF1744),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),

                          const SizedBox(height: 24),

                          // Send OTP button
                          GestureDetector(
                            onTap: _isLoading ? null : _sendOtp,
                            child: AnimatedScale(
                              scale: _isLoading ? 0.98 : 1.0,
                              duration: const Duration(milliseconds: 150),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                      sigmaX: 20, sigmaY: 20),
                                  child: Container(
                                    width: double.infinity,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFF6B35)
                                          .withValues(
                                              alpha: _isLoading
                                                  ? 0.1
                                                  : 0.2),
                                      borderRadius:
                                          BorderRadius.circular(16),
                                      border: Border.all(
                                        color: const Color(0xFFFF6B35)
                                            .withValues(alpha: 0.4),
                                      ),
                                    ),
                                    child: Center(
                                      child: _isLoading
                                          ? const SizedBox(
                                              width: 24,
                                              height: 24,
                                              child:
                                                  CircularProgressIndicator(
                                                strokeWidth: 2.5,
                                                color:
                                                    Color(0xFFFF6B35),
                                              ),
                                            )
                                          : const Text(
                                              'SEND OTP',
                                              style: TextStyle(
                                                color:
                                                    Color(0xFFFF6B35),
                                                fontSize: 16,
                                                fontWeight:
                                                    FontWeight.w600,
                                                letterSpacing: 1,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                              .animate()
                              .fadeIn(delay: 400.ms)
                              .slideY(begin: 0.2),

                          const Spacer(),

                          // Dev hint
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF00C853)
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFF00C853)
                                    .withValues(alpha: 0.2),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.info_outline_rounded,
                                  color: Color(0xFF00C853),
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Dev: Use any 10-digit number starting with 6-9.\nOTP will appear in server logs.',
                                    style: TextStyle(
                                      color: const Color(0xFF00C853)
                                          .withValues(alpha: 0.8),
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}