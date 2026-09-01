import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fuelrush_ui/src/atoms/app_colors.dart';
import 'package:fuelrush_ui/src/atoms/app_spacing.dart';

/// Glassmorphism Card — FUELRUSH content card component.
/// Color(0x14FFFFFF) dark / Color(0x08000000) light,
/// BackdropFilter blur 16, 1px border, subtle BoxShadow.
class GlassmorphismCard extends StatelessWidget {
  const GlassmorphismCard({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.margin,
    this.isDarkMode = true,
    this.borderRadius,
    this.onTap,
    this.width,
    this.height,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final bool isDarkMode;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final effectiveRadius =
        borderRadius ?? BorderRadius.circular(AppSpacing.radiusLg);

    final cardContent = ClipRRect(
      borderRadius: effectiveRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: AppSpacing.cardBlurSigma,
          sigmaY: AppSpacing.cardBlurSigma,
        ),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            color: isDarkMode
                ? AppColors.glassOverlayDark
                : AppColors.glassOverlayLight,
            borderRadius: effectiveRadius,
            border: Border.all(
              color: isDarkMode
                  ? AppColors.glassBorderDark
                  : AppColors.glassBorderLight,
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDarkMode ? 0.2 : 0.05),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );

    if (margin != null) {
      return Padding(
        padding: margin!,
        child: onTap != null
            ? GestureDetector(onTap: onTap, child: cardContent)
            : cardContent,
      );
    }

    return onTap != null
        ? GestureDetector(onTap: onTap, child: cardContent)
        : cardContent;
  }
}