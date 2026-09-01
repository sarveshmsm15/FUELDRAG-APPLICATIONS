import '../../core/errors/exceptions.dart';

AppException mapServerError(dynamic responseBody, int statusCode) {
  final message = _extractMessage(responseBody);
  final code = _extractCode(responseBody);

  switch (statusCode) {
    case 400:
      return ValidationException(message: message, details: responseBody);

    case 401:
      if (code == 'AUTH_TOKEN_EXPIRED') {
        return const TokenExpiredException();
      }
      return UnauthorizedException(message: message);

    case 403:
      return AuthException(message: message, code: 'FORBIDDEN');

    case 404:
      return NetworkException(
        code: 'NOT_FOUND',
        message: message,
        details: responseBody,
      );

    case 409:
      return NetworkException(
        code: 'CONFLICT',
        message: message,
        details: responseBody,
      );

    case 422:
      return ValidationException(message: message, details: responseBody);

    case 429:
      return NetworkException(
        code: 'RATE_LIMITED',
        message: 'Too many requests. Please wait a moment.',
        details: responseBody,
      );

    case 500:
    case 502:
    case 503:
      return ServerException(message: message, details: responseBody);

    default:
      return NetworkException(
        code: 'HTTP_$statusCode',
        message: message,
        details: responseBody,
      );
  }
}

String _extractMessage(dynamic body) {
  if (body is Map<String, dynamic>) {
    return (body['message'] as String?) ?? 'Request failed';
  }
  return 'Request failed';
}

String _extractCode(dynamic body) {
  if (body is Map<String, dynamic>) {
    return (body['error'] as String?) ?? 'UNKNOWN';
  }
  return 'UNKNOWN';
}