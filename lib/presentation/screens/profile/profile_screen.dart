import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../providers/auth/auth_provider.dart';
import '../../navigation/app_router.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  static const _brown = Color(0xFF5C3A1E);
  static const _brownLight = Color(0xFF8B6342);
  static const _brownDark = Color(0xFF3E2210);
  static const _glass = Color(0x40FFFFFF);
  static const _glassBorder = Color(0x60FFFFFF);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final name = authState is AuthAuthenticated ? (authState.name ?? 'User') : 'User';
    final phone = authState is AuthAuthenticated ? authState.phone : '';
    final role = authState is AuthAuthenticated ? authState.role : 'customer';

    return Container(
      width: double.infinity, height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [Color(0xFFF8F0E8), Color(0xFFEDE0D4), Color(0xFFF5EDE4), Color(0xFFE8D5C4)],
          stops: [0.0, 0.3, 0.7, 1.0]),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Profile', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: _brownDark)).animate().fadeIn(),
              const SizedBox(height: 24),

              // Avatar + Name
              Center(
                child: Column(children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        width: 80, height: 80,
                        decoration: BoxDecoration(color: _glass, borderRadius: BorderRadius.circular(24), border: Border.all(color: _glassBorder, width: 1.5)),
                        child: const Icon(Icons.person_rounded, color: _brown, size: 40),
                      ),
                    ),
                  ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.8, 0.8)),
                  const SizedBox(height: 12),
                  Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: _brownDark)),
                  Text('+91 $phone', style: TextStyle(fontSize: 14, color: _brownLight.withValues(alpha: 0.7))),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(color: _brown.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                    child: Text(role.toUpperCase(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _brown, letterSpacing: 1)),
                  ),
                ]),
              ),

              const SizedBox(height: 32),

              // Menu items
              _menuItem(Icons.person_outline_rounded, 'Edit Profile', () {}),
              _menuItem(Icons.location_on_outlined, 'Saved Addresses', () {}),
              _menuItem(Icons.directions_car_outlined, 'My Vehicles', () {}),
              _menuItem(Icons.lock_outline_rounded, 'Security & PIN', () => context.push(RouteNames.securityPin)),
              _menuItem(Icons.notifications_outlined, 'Notifications', () {}),
              _menuItem(Icons.help_outline_rounded, 'Help & Support', () => context.push(RouteNames.helpSupport)),

              const SizedBox(height: 24),

              // Logout
              GestureDetector(
                onTap: () async {
                  await ref.read(authStateProvider.notifier).logout();
                  if (context.mounted) context.go(RouteNames.login);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(color: const Color(0xFFFF1744).withValues(alpha: 0.08), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFFF1744).withValues(alpha: 0.2))),
                      child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Icon(Icons.logout_rounded, color: Color(0xFFFF1744), size: 20),
                        SizedBox(width: 8),
                        Text('Logout', style: TextStyle(color: Color(0xFFFF1744), fontSize: 15, fontWeight: FontWeight.w700)),
                      ]),
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 400.ms),

              const SizedBox(height: 16),
              Center(child: Text('FuelRush v1.0.0', style: TextStyle(fontSize: 11, color: _brownLight.withValues(alpha: 0.4)))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuItem(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(color: _glass, borderRadius: BorderRadius.circular(16), border: Border.all(color: _glassBorder, width: 1)),
            child: Row(children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(color: _brown.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: _brown, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(child: Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: _brownDark))),
              Icon(Icons.chevron_right_rounded, color: _brownLight.withValues(alpha: 0.4), size: 22),
            ]),
          ),
        ),
      ),
    );
  }
}
