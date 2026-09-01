abstract class AppException implements Exception {
  const AppException({
    required this.code,
    required this.message,
    this.details,
    this.stackTrace,
  });

  final String code;
  final String message;
  final dynamic details;
  final StackTrace? stackTrace;

  @override
  String toString() => '$runtimeType($code): $message';
}

// ── Network Exceptions ──
class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.code = 'NETWORK_ERROR',
    super.details,
  });
}

class TimeoutException extends AppException {
  const TimeoutException({
    super.message = 'Request timed out',
    super.code = 'NETWORK_TIMEOUT',
  });
}

class NoInternetException extends AppException {
  const NoInternetException({
    super.message = 'No internet connection',
    super.code = 'NO_INTERNET',
  });
}

// ── Auth Exceptions ──
class AuthException extends AppException {
  const AuthException({
    required super.message,
    super.code = 'AUTH_ERROR',
    super.details,
  });
}

class TokenExpiredException extends AuthException {
  const TokenExpiredException({
    super.message = 'Session expired. Please login again.',
    super.code = 'AUTH_TOKEN_EXPIRED',
  });
}

class UnauthorizedException extends AuthException {
  const UnauthorizedException({
    super.message = 'Unauthorized access',
    super.code = 'AUTH_UNAUTHORIZED',
  });
}

// ── Validation Exceptions ──
class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    super.code = 'VALIDATION_ERROR',
    super.details,
  });
}

// ── Server Exceptions ──
class ServerException extends AppException {
  const ServerException({
    super.message = 'Server error. Please try again later.',
    super.code = 'SERVER_ERROR',
    super.details,
  });
}

// ── Storage Exceptions ──
class StorageException extends AppException {
  const StorageException({
    required super.message,
    super.code = 'STORAGE_ERROR',
    super.details,
  });
}

// ── Location Exceptions ──
class LocationException extends AppException {
  const LocationException({
    required super.message,
    super.code = 'LOCATION_ERROR',
    super.details,
  });
}

class LocationPermissionDeniedException extends LocationException {
  const LocationPermissionDeniedException({
    super.message = 'Location permission denied',
  });
}