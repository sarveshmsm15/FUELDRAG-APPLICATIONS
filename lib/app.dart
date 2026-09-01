import 'package:flutter/material.dart';
import 'package:fuelrush_ui/fuelrush_ui.dart';

/// FUELRUSH Root Application Widget.
/// Phase 1: Minimal shell to verify the app runs on simulator.
/// Later phases will add GoRouter, theme switching, auth gates.
class FuelRushApp extends StatelessWidget {
  const FuelRushApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FUELRUSH',
      debugShowCheckedModeBanner: false,
      theme: AppThemeData.pearl,
      darkTheme: AppThemeData.onyx,
      themeMode: ThemeMode.dark, // Default to ONYX
      home: const _Phase1SplashScreen(),
    );
  }
}

/// Temporary splash screen to verify Phase 1 setup.
/// Will be replaced with proper onboarding in Phase 5.
class _Phase1SplashScreen extends StatelessWidget {
  const _Phase1SplashScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Fuel icon placeholder
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.fuelOrange.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                border: Border.all(
                  color: AppColors.fuelOrange.withValues(alpha: 0.4),
                ),
              ),
              child: const Icon(
                Icons.local_gas_station_rounded,
                color: AppColors.fuelOrange,
                size: 40,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'FUELRUSH',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: AppColors.fuelOrange,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Phase 1 — Foundation Loaded ✓',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.deliveryGreen,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            // Liquid glass button preview
            SizedBox(
              width: 280,
              child: LiquidGlassButton(
                label: 'GOD MODE ACTIVATED',
                icon: Icons.bolt_rounded,
                onPressed: () {},
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            // Glassmorphism card preview
            SizedBox(
              width: 280,
              child: GlassmorphismCard(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.deliveryGreen,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        const Text(
                          'All systems operational',
                          style: TextStyle(
                            color: AppColors.textLight,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Flutter',
                          style: TextStyle(
                            color: AppColors.disabledDark,
                            fontSize: 12,
                          ),
                        ),
                        const Text(
                          '3.47.2',
                          style: TextStyle(
                            color: AppColors.fuelOrange,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Dart',
                          style: TextStyle(
                            color: AppColors.disabledDark,
                            fontSize: 12,
                          ),
                        ),
                        const Text(
                          '3.13.2',
                          style: TextStyle(
                            color: AppColors.fuelOrange,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Riverpod',
                          style: TextStyle(
                            color: AppColors.disabledDark,
                            fontSize: 12,
                          ),
                        ),
                        const Text(
                          '3.3.1',
                          style: TextStyle(
                            color: AppColors.fuelOrange,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}