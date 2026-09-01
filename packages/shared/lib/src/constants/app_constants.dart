abstract class AppConstants {
  const AppConstants._();

  static const String appName = 'FUELRUSH';
  static const String appVersion = '1.0.0';
  static const int appBuildNumber = 100;
  static const String minSupportedVersion = '1.0.0';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // OTP
  static const int otpLength = 6;
  static const Duration otpExpiry = Duration(minutes: 10);
  static const int otpMaxAttemptsPerHour = 3;

  // PIN
  static const int pinLength = 6;
  static const int pinMaxAttempts = 5;
  static const Duration pinLockoutDuration = Duration(minutes: 15);

  // Wallet
  static const double walletPinThreshold = 2000.0;

  // Pricing
  static const double surgeCapMultiplier = 2.0;
  static const Duration priceLockDuration = Duration(minutes: 10);
  static const double deliveryFeeBase = 49.0;
  static const double taxRate = 0.18; // 18% GST

  // Session
  static const Duration accessTokenExpiry = Duration(minutes: 15);
  static const Duration refreshTokenExpiry = Duration(days: 30);
  static const Duration adminSessionTimeout = Duration(minutes: 30);

  // Location
  static const double geofenceOuterRadiusMeters = 500.0;
  static const double geofenceInnerRadiusMeters = 100.0;
  static const int driverLocationUpdateIntervalSeconds = 5;
  static const Duration locationDataRetention = Duration(hours: 24);

  // Rate limiting
  static const int apiRateLimitPerMinute = 60;
  static const int authRateLimitPerMinute = 10;

  // Hive box names
  static const String hiveUserBox = 'user_box';
  static const String hiveSettingsBox = 'settings_box';
  static const String hiveCacheBox = 'cache_box';
  static const String hiveFuelRatesBox = 'fuel_rates_box';

  // Secure storage keys
  static const String secureAccessToken = 'access_token';
  static const String secureRefreshToken = 'refresh_token';
  static const String securePinHash = 'pin_hash';
  static const String secureThemePref = 'theme_preference';
  static const String secureDeviceId = 'device_id';
  static const String secureBiometricEnabled = 'biometric_enabled';
}