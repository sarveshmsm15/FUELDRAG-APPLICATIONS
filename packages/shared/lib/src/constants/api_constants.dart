/// API endpoint path constants for FUELRUSH.
/// These are path segments only — base URL comes from dart_defines.
abstract class ApiConstants {
  const ApiConstants._();

  /// API version prefix.
  static const String apiVersion = 'v1';

  // Auth endpoints
  static const String authSendOtp = '/auth/send-otp';
  static const String authVerifyOtp = '/auth/verify-otp';
  static const String authRefresh = '/auth/refresh';
  static const String authLogout = '/auth/logout';
  static const String authBiometricSetup = '/auth/biometric/setup';
  static const String authBiometricVerify = '/auth/biometric/verify';
  static const String authPinSetup = '/auth/pin/setup';
  static const String authPinVerify = '/auth/pin/verify';

  // User endpoints
  static const String userProfile = '/user/profile';
  static const String userUpdateProfile = '/user/profile/update';

  // Address endpoints
  static const String addresses = '/addresses';

  // Vehicle endpoints
  static const String vehicles = '/vehicles';

  // Fuel rate endpoints
  static const String fuelRates = '/fuel-rates';
  static const String fuelRatesCurrent = '/fuel-rates/current';

  // Order endpoints
  static const String orders = '/orders';
  static const String ordersActive = '/orders/active';
  static const String ordersHistory = '/orders/history';

  // Pricing endpoints
  static const String pricingCalculate = '/pricing/calculate';
  static const String pricingSnapshot = '/pricing/snapshot';

  // Payment endpoints
  static const String paymentsInitiate = '/payments/initiate';
  static const String paymentsVerify = '/payments/verify';
  static const String paymentsStripeIntent = '/payments/stripe/intent';
  static const String paymentsRazorpayOrder = '/payments/razorpay/order';

  // Wallet endpoints
  static const String walletBalance = '/wallet/balance';
  static const String walletTransactions = '/wallet/transactions';
  static const String walletAddMoney = '/wallet/add-money';

  // Tracking endpoints
  static const String trackingOrder = '/tracking';

  // Maps proxy endpoints
  static const String mapsGeocode = '/maps/geocode';
  static const String mapsReverseGeocode = '/maps/reverse-geocode';
  static const String mapsPlaces = '/maps/places';
  static const String mapsDirections = '/maps/directions';

  // Support endpoints
  static const String supportFaqs = '/support/faqs';
  static const String supportChat = '/support/chat';

  // Health
  static const String health = '/health';
}