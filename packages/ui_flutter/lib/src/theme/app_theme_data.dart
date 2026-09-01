import 'package:flutter/material.dart';
import 'package:fuelrush_ui/src/atoms/app_colors.dart';
import 'package:fuelrush_ui/src/atoms/app_spacing.dart';

/// FUELRUSH ThemeData definitions for ONYX (dark) and PEARL (light).
abstract class AppThemeData {
  const AppThemeData._();

  /// ONYX — Dark theme.
  static ThemeData get onyx => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.onyx,
        primaryColor: AppColors.fuelOrange,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.fuelOrange,
          secondary: AppColors.deliveryGreen,
          error: AppColors.errorRed,
          surface: AppColors.surfaceDark,
          onPrimary: AppColors.textLight,
          onSecondary: AppColors.textLight,
          onError: AppColors.textLight,
          onSurface: AppColors.textLight,
        ),
        textTheme: _textTheme(AppColors.textLight),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.onyx,
          foregroundColor: AppColors.textLight,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: AppColors.textLight,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.onyx,
          selectedItemColor: AppColors.fuelOrange,
          unselectedItemColor: AppColors.disabledDark,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.glassOverlayDark,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            borderSide: BorderSide(color: AppColors.glassBorderDark),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            borderSide: BorderSide(color: AppColors.glassBorderDark),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            borderSide: const BorderSide(color: AppColors.fuelOrange, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            borderSide: const BorderSide(color: AppColors.errorRed),
          ),
          hintStyle: TextStyle(color: AppColors.textLight.withValues(alpha: 0.5)),
          labelStyle: const TextStyle(color: AppColors.textLight),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.dividerDark,
          thickness: 1,
          space: 0,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.surfaceDark,
          contentTextStyle: const TextStyle(color: AppColors.textLight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          behavior: SnackBarBehavior.floating,
        ),
        useMaterial3: true,
      );

  /// PEARL — Light theme.
  static ThemeData get pearl => ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.pearl,
        primaryColor: AppColors.fuelOrange,
        colorScheme: const ColorScheme.light(
          primary: AppColors.fuelOrange,
          secondary: AppColors.deliveryGreen,
          error: AppColors.errorRed,
          surface: AppColors.surfaceLight,
          onPrimary: AppColors.textLight,
          onSecondary: AppColors.textLight,
          onError: AppColors.textLight,
          onSurface: AppColors.textDark,
        ),
        textTheme: _textTheme(AppColors.textDark),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.pearl,
          foregroundColor: AppColors.textDark,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: AppColors.textDark,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.pearl,
          selectedItemColor: AppColors.fuelOrange,
          unselectedItemColor: AppColors.disabledLight,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.glassOverlayLight,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            borderSide: BorderSide(color: AppColors.glassBorderLight),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            borderSide: BorderSide(color: AppColors.glassBorderLight),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            borderSide: const BorderSide(color: AppColors.fuelOrange, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            borderSide: const BorderSide(color: AppColors.errorRed),
          ),
          hintStyle: TextStyle(color: AppColors.textDark.withValues(alpha: 0.5)),
          labelStyle: const TextStyle(color: AppColors.textDark),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.dividerLight,
          thickness: 1,
          space: 0,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.surfaceLight,
          contentTextStyle: const TextStyle(color: AppColors.textDark),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          behavior: SnackBarBehavior.floating,
        ),
        useMaterial3: true,
      );

  /// Typography — Inter / SF Pro Display sizing.
  static TextTheme _textTheme(Color textColor) => TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: textColor,
          letterSpacing: -0.5,
        ),
        displayMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: textColor,
          letterSpacing: -0.25,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textColor,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textColor.withValues(alpha: 0.8),
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textColor,
          letterSpacing: 0.5,
        ),
        labelSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textColor.withValues(alpha: 0.6),
          letterSpacing: 0.5,
        ),
      );
}