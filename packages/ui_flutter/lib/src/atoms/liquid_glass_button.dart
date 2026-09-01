import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fuelrush_ui/src/atoms/app_colors.dart';
import 'package:fuelrush_ui/src/atoms/app_spacing.dart';

/// Liquid Glass Button — FUELRUSH primary CTA component.
/// Frosted glass with subtle light refraction, 1px semi-transparent border,
/// BackdropFilter blur, inner glow on press, smooth 300ms transitions.
class LiquidGlassButton extends StatefulWidget {
  const LiquidGlassButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon,
    this.isLoading = false,
    this.isDanger = false,
    this.isSuccess = false,
    this.width,
    this.height = 56.0,
    this.isDarkMode = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isDanger;
  final bool isSuccess;
  final double? width;
  final double height;
  final bool isDarkMode;

  @override
  State<LiquidGlassButton> createState() => _LiquidGlassButtonState();
}

class _LiquidGlassButtonState extends State<LiquidGlassButton>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;

  Color get _backgroundColor {
    if (widget.isDanger) return AppColors.errorRed.withValues(alpha: 0.25);
    if (widget.isSuccess) return AppColors.deliveryGreen.withValues(alpha: 0.25);
    return AppColors.fuelOrange.withValues(alpha: 0.25);
  }

  Color get _borderColor {
    if (widget.isDanger) return AppColors.errorRed.withValues(alpha: 0.4);
    if (widget.isSuccess) return AppColors.deliveryGreen.withValues(alpha: 0.4);
    return AppColors.fuelOrange.withValues(alpha: 0.4);
  }

  Color get _textColor {
    if (widget.isDanger) return AppColors.errorRed;
    if (widget.isSuccess) return AppColors.deliveryGreen;
    return AppColors.fuelOrange;
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.onPressed != null && !widget.isLoading;

    return GestureDetector(
      onTapDown: isEnabled ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: isEnabled
          ? (_) {
              setState(() => _isPressed = false);
              widget.onPressed?.call();
            }
          : null,
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: AppSpacing.fastAnimation,
        curve: Curves.easeInOut,
        child: AnimatedContainer(
          duration: AppSpacing.normalAnimation,
          curve: Curves.easeInOut,
          width: widget.width ?? double.infinity,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(
              color: isEnabled
                  ? _borderColor
                  : (widget.isDarkMode
                      ? AppColors.disabledDark
                      : AppColors.disabledLight),
              width: 1.0,
            ),
            boxShadow: _isPressed
                ? [
                    BoxShadow(
                      color: _backgroundColor.withValues(alpha: 0.5),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: AppSpacing.glassBlurSigma,
                sigmaY: AppSpacing.glassBlurSigma,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: isEnabled
                      ? _backgroundColor
                      : (widget.isDarkMode
                          ? AppColors.disabledDark.withValues(alpha: 0.1)
                          : AppColors.disabledLight.withValues(alpha: 0.1)),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                ),
                child: Center(
                  child: widget.isLoading
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: _textColor,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.icon != null) ...[
                              Icon(widget.icon, color: _textColor, size: 20),
                              const SizedBox(width: AppSpacing.xs),
                            ],
                            Text(
                              widget.label,
                              style: TextStyle(
                                color: isEnabled
                                    ? _textColor
                                    : (widget.isDarkMode
                                        ? AppColors.disabledDark
                                        : AppColors.disabledLight),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}