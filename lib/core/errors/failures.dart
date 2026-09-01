import 'package:equatable/equatable.dart';


abstract class Failure extends Equatable {
  const Failure({
    required this.code,
    required this.message,
  });

  final String code;
  final String message;

  @override
  List<Object?> get props => [code, message];

  @override
  String toString() => '$runtimeType($code): $message';
}

// ── Network Failures ──
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.code = 'NETWORK_FAILURE',
    super.message = 'Network error occurred',
  });
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({
    super.code = 'TIMEOUT_FAILURE',
    super.message = 'Request timed out',
  });
}

// ── Auth Failures ──
class AuthFailure extends Failure {
  const AuthFailure({
    super.code = 'AUTH_FAILURE',
    super.message = 'Authentication failed',
  });
}

class SessionExpiredFailure extends AuthFailure {
  const SessionExpiredFailure({
    super.code = 'SESSION_EXPIRED',
    super.message = 'Session expired',
  });
}

// ── Server Failures ──
class ServerFailure extends Failure {
  const ServerFailure({
    super.code = 'SERVER_FAILURE',
    super.message = 'Server error',
  });
}

// ── Validation Failures ──
class ValidationFailure extends Failure {
  const ValidationFailure({
    super.code = 'VALIDATION_FAILURE',
    super.message = 'Validation failed',
    this.fieldErrors = const {},
  });

  final Map<String, String> fieldErrors;

  @override
  List<Object?> get props => [code, message, fieldErrors];
}

// ── Cache Failures ──
class CacheFailure extends Failure {
  const CacheFailure({
    super.code = 'CACHE_FAILURE',
    super.message = 'Cache operation failed',
  });
}

// ── Location Failures ──
class LocationFailure extends Failure {
  const LocationFailure({
    super.code = 'LOCATION_FAILURE',
    super.message = 'Location error',
  });
}

// ── Unknown Failures ──
class UnknownFailure extends Failure {
  const UnknownFailure({
    super.code = 'UNKNOWN_FAILURE',
    super.message = 'An unexpected error occurred',
  });
}