import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../providers/auth/auth_provider.dart';
import '../../navigation/app_router.dart';

class BiometricSetupScreen extends ConsumerStatefulWidget {
  const BiometricSetupScreen({super.key});
  @override
  ConsumerState<BiometricSetupScreen> createState() => _BiometricSetupScreenState();
}

class _BiometricSetupScreenState extends ConsumerState<BiometricSetupScreen> {
  bool _isLoading = false;

  Future<void> _enable() async {
    setState(() => _isLoading = true);
    await ref.read(authStateProvider.notifier).enableBiometric();
    if (mounted) { setState(() => _isLoading = false); context.go(RouteNames.home); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B35).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFFF6B35).withValues(alpha: 0.3)),
                ),
                child: const Icon(Icons.fingerprint_rounded, color: Color(0xFFFF6B35), size: 40),
              ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.8, 0.8)),
              const SizedBox(height: 24),
              const Text('Enable Biometric Lock', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white)).animate().fadeIn(delay: 100.ms),
              const SizedBox(height: 8),
              Text(
  'Use Face ID or Fingerprint for quick access',
  textAlign: TextAlign.center,
  style: TextStyle(
    fontSize: 14,
    color: Colors.white.withValues(alpha: 0.5),
  ),
).animate().fadeIn(delay: 200.ms),
              const SizedBox(height: 48),
              GestureDetector(
                onTap: _isLoading ? null : _enable,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      width: double.infinity, height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFF00C853).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF00C853).withValues(alpha: 0.4)),
                      ),
                      child: Center(
                        child: _isLoading
                          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2.5, color: Color(0xFF00C853)))
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.fingerprint_rounded, color: Color(0xFF00C853)),
                                SizedBox(width: 8),
                                Text('ENABLE BIOMETRIC', style: TextStyle(color: Color(0xFF00C853), fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 1)),
                              ],
                            ),
                      ),
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => context.go(RouteNames.home),
                child: Text('Skip for now', style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 14)),
              ).animate().fadeIn(delay: 500.ms),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}