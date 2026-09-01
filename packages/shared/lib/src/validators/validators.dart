/// Centralized validation functions for FUELRUSH.
/// Used across mobile forms and server-side validation.
abstract class Validators {
  const Validators._();

  /// Validates an Indian phone number (10 digits, starts with 6-9).
  static bool isValidPhone(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'[\s\-\+]'), '');
    final digits = cleaned.startsWith('91') ? cleaned.substring(2) : cleaned;
    return RegExp(r'^[6-9]\d{9}$').hasMatch(digits);
  }

  /// Validates a 6-digit OTP.
  static bool isValidOtp(String otp) {
    return RegExp(r'^\d{6}$').hasMatch(otp);
  }

  /// Validates a 6-digit PIN.
  static bool isValidPin(String pin) {
    return RegExp(r'^\d{6}$').hasMatch(pin);
  }

  /// Validates an email address.
  static bool isValidEmail(String email) {
    return RegExp(
      r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(email.trim());
  }

  /// Validates a name (2-50 characters, letters and spaces only).
  static bool isValidName(String name) {
    return RegExp(r'^[a-zA-Z\s]{2,50}$').hasMatch(name.trim());
  }

  /// Validates a non-empty string with minimum length.
  static bool isNotEmpty(String value, {int minLength = 1}) {
    return value.trim().length >= minLength;
  }

  /// Validates latitude range.
  static bool isValidLatitude(double lat) {
    return lat >= -90.0 && lat <= 90.0;
  }

  /// Validates longitude range.
  static bool isValidLongitude(double lng) {
    return lng >= -180.0 && lng <= 180.0;
  }

  /// Validates fuel quantity (1-100 liters).
  static bool isValidFuelQuantity(double quantity) {
    return quantity >= 1.0 && quantity <= 100.0;
  }

  /// Validates vehicle registration number (Indian format).
  static bool isValidVehicleRegistration(String reg) {
    return RegExp(
      r'^[A-Z]{2}\d{1,2}[A-Z]{1,3}\d{4}$',
    ).hasMatch(reg.toUpperCase().replaceAll(' ', ''));
  }

  /// Returns a human-readable error message for phone validation.
  static String? phoneError(String? value) {
    if (value == null || value.isEmpty) return 'Phone number is required';
    if (!isValidPhone(value)) return 'Enter a valid 10-digit phone number';
    return null;
  }

  /// Returns a human-readable error message for OTP validation.
  static String? otpError(String? value) {
    if (value == null || value.isEmpty) return 'OTP is required';
    if (!isValidOtp(value)) return 'Enter a valid 6-digit OTP';
    return null;
  }

  /// Returns a human-readable error message for PIN validation.
  static String? pinError(String? value) {
    if (value == null || value.isEmpty) return 'PIN is required';
    if (!isValidPin(value)) return 'Enter a valid 6-digit PIN';
    return null;
  }

  /// Returns a human-readable error message for email validation.
  static String? emailError(String? value) {
    if (value == null || value.isEmpty) return null; // Email is optional
    if (!isValidEmail(value)) return 'Enter a valid email address';
    return null;
  }

  /// Returns a human-readable error message for name validation.
  static String? nameError(String? value) {
    if (value == null || value.isEmpty) return 'Name is required';
    if (!isValidName(value)) return 'Enter a valid name (2-50 characters)';
    return null;
  }
}