import 'package:intl/intl.dart';

/// Formatting utilities for FUELRUSH.
abstract class Formatters {
  const Formatters._();

  /// Formats a phone number as +91 XXXXX XXXXX.
  static String formatPhone(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'[\s\-\+]'), '');
    final digits = cleaned.startsWith('91') ? cleaned.substring(2) : cleaned;
    if (digits.length == 10) {
      return '+91 ${digits.substring(0, 5)} ${digits.substring(5)}';
    }
    return phone;
  }

  /// Masks a phone number as +91 XXXXX XX345.
  static String maskPhone(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'[\s\-\+]'), '');
    final digits = cleaned.startsWith('91') ? cleaned.substring(2) : cleaned;
    if (digits.length == 10) {
      return '+91 XXXXX ${digits.substring(7)}';
    }
    return phone;
  }

  /// Masks an email as s***@gmail.com.
  static String maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;
    final name = parts[0];
    if (name.length <= 1) return email;
    return '${name[0]}***@${parts[1]}';
  }

  /// Formats currency in INR.
  static String formatCurrency(double amount, {bool showSymbol = true}) {
    final formatter = NumberFormat('#,##,##0.00', 'en_IN');
    final formatted = formatter.format(amount);
    return showSymbol ? '₹$formatted' : formatted;
  }

  /// Formats currency without decimals for whole numbers.
  static String formatCurrencyCompact(double amount) {
    if (amount == amount.roundToDouble()) {
      final formatter = NumberFormat('#,##,##0', 'en_IN');
      return '₹${formatter.format(amount)}';
    }
    return formatCurrency(amount);
  }

  /// Formats fuel quantity with unit.
  static String formatFuelQuantity(double liters) {
    return '${liters.toStringAsFixed(1)} L';
  }

  /// Formats fuel price per liter.
  static String formatFuelPrice(double pricePerLiter) {
    return '₹${pricePerLiter.toStringAsFixed(2)}/L';
  }

  /// Formats a DateTime to a readable string.
  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  /// Formats a DateTime to a readable time string.
  static String formatTime(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }

  /// Formats a DateTime to date + time.
  static String formatDateTime(DateTime date) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(date);
  }

  /// Formats duration as ETA string.
  static String formatEta(Duration duration) {
    if (duration.inHours > 0) {
      final hours = duration.inHours;
      final minutes = duration.inMinutes.remainder(60);
      return '$hours hr $minutes min';
    }
    if (duration.inMinutes > 0) {
      return '${duration.inMinutes} min';
    }
    return '< 1 min';
  }

  /// Formats distance in km or m.
  static String formatDistance(double meters) {
    if (meters >= 1000) {
      return '${(meters / 1000).toStringAsFixed(1)} km';
    }
    return '${meters.round()} m';
  }
}