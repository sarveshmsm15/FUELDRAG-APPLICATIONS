import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../navigation/app_router.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

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
              // Logo
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B35).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: const Color(0xFFFF6B35).withValues(alpha: 0.3)),
                ),
                child: const Icon(Icons.local_gas_station_rounded, color: Color(0xFFFF6B35), size: 50),
              ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.8, 0.8)),

              const SizedBox(height: 32),

              const Text('FUELRUSH',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.w700, color: Color(0xFFFF6B35), letterSpacing: 3),
              ).animate().fadeIn(delay: 200.ms, duration: 600.ms).slideY(begin: 0.2),

              const SizedBox(height: 8),

              Text('Fuel delivered to your doorstep',
                style: TextStyle(fontSize: 16, color: Colors.white.withValues(alpha: 0.6)),
              ).animate().fadeIn(delay: 400.ms, duration: 600.ms),

              const SizedBox(height: 48),

              // Feature cards
              _featureCard(Icons.speed_rounded, 'Fast Delivery', 'Fuel in 30 minutes'),
              const SizedBox(height: 12),
              _featureCard(Icons.security_rounded, 'Safe & Secure', 'Licensed & insured drivers'),
              const SizedBox(height: 12),
              _featureCard(Icons.account_balance_wallet_rounded, 'Best Prices', 'Same as pump price'),

              const Spacer(),

              // CTA Button
              GestureDetector(
                onTap: () => context.go(RouteNames.login),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6B35).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFFF6B35).withValues(alpha: 0.4)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_forward_rounded, color: Color(0xFFFF6B35)),
                          SizedBox(width: 8),
                          Text('GET STARTED',
                            style: TextStyle(color: Color(0xFFFF6B35), fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 1)),
                        ],
                      ),
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 600.ms, duration: 600.ms).slideY(begin: 0.3),

              const SizedBox(height: 16),

              Text('By continuing, you agree to our Terms & Privacy Policy',
                style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.3)),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 800.ms),
            ],
          ),
        ),
      ),
    );
  }

  Widget _featureCard(IconData icon, String title, String subtitle) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0x14FFFFFF),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0x1AFFFFFF)),
          ),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFFFF6B35), size: 22),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                  Text(subtitle, style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: 500.ms, duration: 400.ms).slideX(begin: -0.1);
  }
}