import 'package:dio/dio.dart';

import '../../core/errors/exceptions.dart';
import 'dio_client.dart';
import 'api_exception.dart';

abstract class ApiClient {
  Dio get dio => DioClient.instance;

  /// Perform a GET request.
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      return await dio.get<T>(path, queryParameters: queryParameters, cancelToken: cancelToken);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  /// Perform a POST request.
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      return await dio.post<T>(path, data: data, queryParameters: queryParameters, cancelToken: cancelToken);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  /// Perform a PUT request.
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      return await dio.put<T>(path, data: data, queryParameters: queryParameters, cancelToken: cancelToken);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  /// Perform a PATCH request.
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      return await dio.patch<T>(path, data: data, queryParameters: queryParameters, cancelToken: cancelToken);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  /// Perform a DELETE request.
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      return await dio.delete<T>(path, data: data, queryParameters: queryParameters, cancelToken: cancelToken);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  /// Map DioException to typed AppException.
  AppException _mapDioException(DioException e) {
    final error = e.error;
    if (error is AppException) return error;

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException();
      case DioExceptionType.connectionError:
        return const NetworkException(message: 'Unable to connect to server');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode ?? 0;
        final data = e.response?.data;
        final message = data is Map ? (data['message'] as String? ?? 'Request failed') : 'Request failed';

        if (statusCode == 401) return UnauthorizedException(message: message);
        if (statusCode == 403) return AuthException(message: message, code: 'FORBIDDEN');
        if (statusCode == 422) return ValidationException(message: message, details: data);
        if (statusCode >= 500) return ServerException(message: message);
        return NetworkException(message: message, code: 'HTTP_$statusCode');
      default:
        return NetworkException(message: e.message ?? 'Unknown network error');
    }
  }
}