import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../core/utils/device_fingerprint.dart';
import '../local/secure_storage.dart';

/// Callback for refreshing tokens.
typedef TokenRefreshCallback = Future<({String accessToken, String refreshToken})?> Function(
  String refreshToken,
);

/// Auth interceptor — attaches JWT to every request,
/// handles 401 with silent token refresh and request queuing.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this.dio,
    required this.onTokenRefresh,
    required this.onAuthFailure,
  });

  final Dio dio;
  final TokenRefreshCallback onTokenRefresh;
  final VoidCallback onAuthFailure;

  /// Lock to prevent concurrent refresh attempts.
  bool _isRefreshing = false;

  /// Queue of requests waiting for token refresh.
  final List<_QueuedRequest> _pendingRequests = [];

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip auth for public endpoints
    if (_isPublicEndpoint(options.path)) {
      // Still attach device headers
      final deviceHeaders = await DeviceFingerprint.getDeviceHeaders();
      options.headers.addAll(deviceHeaders);
      handler.next(options);
      return;
    }

    // Attach access token
    final accessToken = await SecureStorage.getAccessToken();
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    // Attach device fingerprint headers
    final deviceHeaders = await DeviceFingerprint.getDeviceHeaders();
    options.headers.addAll(deviceHeaders);

    handler.next(options);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Only handle 401 errors for token refresh
    if (err.response?.statusCode != 401) {
      handler.next(err);
      return;
    }

    // Don't refresh if this IS the refresh endpoint
    if (err.requestOptions.path.contains('/auth/refresh')) {
      onAuthFailure();
      handler.next(err);
      return;
    }

    // If already refreshing, queue this request
    if (_isRefreshing) {
      _pendingRequests.add(_QueuedRequest(
        options: err.requestOptions,
        handler: handler,
        error: err,
      ));
      return;
    }

    _isRefreshing = true;

    try {
      // Attempt token refresh
      final refreshToken = await SecureStorage.getRefreshToken();
      if (refreshToken == null) {
        onAuthFailure();
        handler.next(err);
        return;
      }

      final newTokens = await onTokenRefresh(refreshToken);
      if (newTokens == null) {
        onAuthFailure();
        handler.next(err);
        return;
      }

      // Save new tokens
      await SecureStorage.saveTokens(
        accessToken: newTokens.accessToken,
        refreshToken: newTokens.refreshToken,
      );

      // Retry the original request with new token
      err.requestOptions.headers['Authorization'] =
          'Bearer ${newTokens.accessToken}';

      final retryResponse = await dio.fetch(err.requestOptions);
      handler.resolve(retryResponse);

      // Retry all queued requests
      for (final pending in _pendingRequests) {
        pending.options.headers['Authorization'] =
            'Bearer ${newTokens.accessToken}';
        try {
          final response = await dio.fetch(pending.options);
          pending.handler.resolve(response);
        } catch (e) {
          pending.handler.next(pending.error);
        }
      }
    } catch (e) {
      onAuthFailure();
      handler.next(err);

      // Reject all queued requests
      for (final pending in _pendingRequests) {
        pending.handler.next(pending.error);
      }
    } finally {
      _isRefreshing = false;
      _pendingRequests.clear();
    }
  }

  bool _isPublicEndpoint(String path) {
    const publicPaths = [
      '/auth/send-otp',
      '/auth/verify-otp',
      '/auth/refresh',
      '/health',
      '/fuel-rates/current',
    ];
    return publicPaths.any((p) => path.contains(p));
  }
}

class _QueuedRequest {
  const _QueuedRequest({
    required this.options,
    required this.handler,
    required this.error,
  });

  final RequestOptions options;
  final ErrorInterceptorHandler handler;
  final DioException error;
}