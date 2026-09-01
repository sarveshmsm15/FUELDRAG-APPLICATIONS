import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import '../../core/constants/env_config.dart';
import 'auth_interceptor.dart';
import 'error_interceptor.dart';
import 'logging_interceptor.dart';
class DioClient {
  const DioClient._();

  static Dio? _instance;

  /// Get the configured Dio instance.
  /// Call [initialize] first at app startup.
  static Dio get instance {
    if (_instance == null) {
      throw StateError(
        'DioClient not initialized. Call DioClient.initialize() first.',
      );
    }
    return _instance!;
  }

  /// Initialize Dio with all interceptors.
  /// Call once at app startup.
  static void initialize({
    required TokenRefreshCallback onTokenRefresh,
    required VoidCallback onAuthFailure,
  }) {
    _instance = Dio(
      BaseOptions(
        baseUrl: EnvConfig.apiFullBaseUrl,
        connectTimeout: Duration(milliseconds: EnvConfig.apiTimeoutMs),
        receiveTimeout: Duration(milliseconds: EnvConfig.apiTimeoutMs),
        sendTimeout: Duration(milliseconds: EnvConfig.apiTimeoutMs),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-App-Version': EnvConfig.appVersion,
          'X-Environment': EnvConfig.environment,
        },
        responseType: ResponseType.json,
      ),
    );

    // Add interceptors in order:
    // 1. Logging (first to capture original request)
    // 2. Auth (attach token, handle refresh)
    // 3. Error (handle failures, map exceptions)
    _instance!.interceptors.addAll([
      LoggingInterceptor(),
      AuthInterceptor(
        dio: _instance!,
        onTokenRefresh: onTokenRefresh,
        onAuthFailure: onAuthFailure,
      ),
      ErrorInterceptor(),
    ]);
  }

  /// Dispose the Dio instance.
  static void dispose() {
    _instance?.close();
    _instance = null;
  }
}