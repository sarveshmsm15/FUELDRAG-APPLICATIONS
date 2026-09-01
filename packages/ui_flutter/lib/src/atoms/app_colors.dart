import 'package:flutter/material.dart';

/// FUELRUSH Design System Color Palette.
/// Strict enforcement — all colors must come from here.
abstract class AppColors {
  const AppColors._();

  // Primary backgrounds
  static const Color onyx = Color(0xFF353935);
  static const Color pearl = Color(0xFFF0EAD6);

  // Action colors
  static const Color fuelOrange = Color(0xFFFF6B35);
  static const Color deliveryGreen = Color(0xFF00C853);
  static const Color errorRed = Color(0xFFFF1744);
  static const Color cautionYellow = Color(0xFFFFD600);

  // Text colors
  static const Color textDark = Color(0xFF1A1A1A);
  static const Color textLight = Color(0xFFFFFFFF);

  // Glass overlays
  static const Color glassOverlayDark = Color(0x14FFFFFF);
  static const Color glassOverlayLight = Color(0x08000000);

  // Glass borders
  static const Color glassBorderDark = Color(0x1AFFFFFF);
  static const Color glassBorderLight = Color(0x1A000000);

  // Surface colors
  static const Color surfaceDark = Color(0xFF2A2D2A);
  static const Color surfaceLight = Color(0xFFE8E2CE);

  // Divider colors
  static const Color dividerDark = Color(0x1AFFFFFF);
  static const Color dividerLight = Color(0x1A000000);

  // Disabled
  static const Color disabledDark = Color(0x40FFFFFF);
  static const Color disabledLight = Color(0x40000000);

  // Transparent
  static const Color transparent = Color(0x00000000);
}