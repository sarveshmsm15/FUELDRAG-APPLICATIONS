import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

/// Error interceptor — maps DioExceptions to typed app exceptions.
class ErrorInterceptor extends Interceptor {
  final _logger = Logger(
    printer: PrettyPrinter(methodCount: 0, printTime: true),
  );

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final appException = _mapToAppException(err);

    _logger.e(
      'API Error: ${appException.code}',
      error: appException.message,
    );

    // Pass the mapped exception forward
    handler.next(DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: appException,
      message: appException.message,
    ));
  }

  AppException _mapToAppException(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const AppException(
          code: 'NETWORK_TIMEOUT',
          message: 'Connection timed out. Please check your internet.',
        );

      case DioExceptionType.connectionError:
        return const AppException(
          code: 'NETWORK_ERROR',
          message: 'Unable to connect. Please check your internet connection.',
        );

      case DioExceptionType.badResponse:
        return _mapStatusCode(err.response?.statusCode, err.response?.data);

      case DioExceptionType.cancel:
        return const AppException(
          code: 'REQUEST_CANCELLED',
          message: 'Request was cancelled',
        );

      default:
        return AppException(
          code: 'UNKNOWN_ERROR',
          message: err.message ?? 'An unexpected error occurred',
        );
    }
  }

  AppException _mapStatusCode(int? statusCode, dynamic data) {
    final message = _extractMessage(data);

    switch (statusCode) {
      case 400:
        return AppException(code: 'BAD_REQUEST', message: message);
      case 401:
        return AppException(code: 'UNAUTHORIZED', message: message);
      case 403:
        return AppException(code: 'FORBIDDEN', message: message);
      case 404:
        return AppException(code: 'NOT_FOUND', message: message);
      case 409:
        return AppException(code: 'CONFLICT', message: message);
      case 422:
        return AppException(
          code: 'VALIDATION_ERROR',
          message: message,
          details: data,
        );
      case 429:
        return AppException(
          code: 'RATE_LIMITED',
          message: 'Too many requests. Please wait a moment.',
        );
      case 500:
      case 502:
      case 503:
        return const AppException(
          code: 'SERVER_ERROR',
          message: 'Server error. Please try again later.',
        );
      default:
        return AppException(
          code: 'HTTP_$statusCode',
          message: message,
        );
    }
  }

  String _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return (data['message'] as String?) ?? 'Request failed';
    }
    return 'Request failed';
  }
}

/// Typed application exception.
class AppException implements Exception {
  const AppException({
    required this.code,
    required this.message,
    this.details,
  });

  final String code;
  final String message;
  final dynamic details;

  bool get isNetworkError =>
      code == 'NETWORK_TIMEOUT' || code == 'NETWORK_ERROR';

  bool get isAuthError =>
      code == 'UNAUTHORIZED' || code == 'AUTH_TOKEN_EXPIRED';

  bool get isServerError => code == 'SERVER_ERROR';

  @override
  String toString() => 'AppException($code): $message';
}