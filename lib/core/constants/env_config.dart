/// Compile-time environment configuration.
/// Values injected via --dart-define-from-file.
/// NO SECRETS — only safe client-side config.
abstract class EnvConfig {
  const EnvConfig._();

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000',
  );

  static const String apiVersion = String.fromEnvironment(
    'API_VERSION',
    defaultValue: 'v1',
  );

  static const int apiTimeoutMs = int.fromEnvironment(
    'API_TIMEOUT',
    defaultValue: 30000,
  );

  static const String appName = String.fromEnvironment(
    'APP_NAME',
    defaultValue: 'FUELRUSH',
  );

  static const String appVersion = String.fromEnvironment(
    'APP_VERSION',
    defaultValue: '1.0.0',
  );

  static const String stripePublishableKey = String.fromEnvironment(
    'STRIPE_PUBLISHABLE_KEY',
  );

  static const String razorpayKeyId = String.fromEnvironment(
    'RAZORPAY_KEY_ID',
  );

  static const String mapsApiProxyUrl = String.fromEnvironment(
    'MAPS_API_PROXY_URL',
  );

  static const String sentryDsn = String.fromEnvironment(
    'SENTRY_DSN',
  );

  static const bool featureBiometricAuth = bool.fromEnvironment(
    'FEATURE_BIOMETRIC_AUTH',
    defaultValue: true,
  );

  static const bool featureEmergencyMode = bool.fromEnvironment(
    'FEATURE_EMERGENCY_MODE',
    defaultValue: true,
  );

  static const bool featureVoiceSearch = bool.fromEnvironment(
    'FEATURE_VOICE_SEARCH',
    defaultValue: true,
  );

  static const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'development',
  );

  static bool get isDevelopment => environment == 'development';
  static bool get isProduction => environment == 'production';

  /// Full API base URL with version.
  static String get apiFullBaseUrl => '$apiBaseUrl/$apiVersion';
}