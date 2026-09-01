import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../providers/auth/auth_provider.dart';
import '../../navigation/app_router.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});
  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() { _nameController.dispose(); _emailController.dispose(); super.dispose(); }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.length < 2) return;

    setState(() => _isLoading = true);
    final result = await ref.read(authStateProvider.notifier).updateProfile(
      name: name,
      email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
    );
    if (mounted) {
      setState(() => _isLoading = false);
      if (result.success) context.go(RouteNames.pinSetup);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                Container(
                  width: 72, height: 72,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B35).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFFF6B35).withValues(alpha: 0.3)),
                  ),
                  child: const Icon(Icons.person_rounded, color: Color(0xFFFF6B35), size: 32),
                ).animate().fadeIn(duration: 400.ms),
                const SizedBox(height: 24),
                const Text('Set up your profile', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white)).animate().fadeIn(delay: 100.ms),
                const SizedBox(height: 8),
                Text('Tell us a bit about yourself', style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.5))).animate().fadeIn(delay: 200.ms),
                const SizedBox(height: 40),
                // Name field
                _glassField(controller: _nameController, hint: 'Full Name', icon: Icons.person_outline_rounded, delay: 300),
                const SizedBox(height: 16),
                // Email field
                _glassField(controller: _emailController, hint: 'Email (optional)', icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress, delay: 400),
                const SizedBox(height: 32),
                GestureDetector(
                  onTap: _isLoading ? null : _save,
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
                            : const Text('CONTINUE', style: TextStyle(color: Color(0xFFFF6B35), fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 1)),
                        ),
                      ),
                    ),
                  ),
                ).animate().fadeIn(delay: 500.ms),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => context.go(RouteNames.pinSetup),
                  child: Text('Skip for now', style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 14)),
                ).animate().fadeIn(delay: 600.ms),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _glassField({required TextEditingController controller, required String hint, required IconData icon, TextInputType? keyboardType, int delay = 0}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0x14FFFFFF),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0x1AFFFFFF)),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
              prefixIcon: Icon(icon, color: const Color(0xFFFF6B35), size: 20),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: delay.ms).slideY(begin: 0.1);
  }
}