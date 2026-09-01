import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

/// Logging interceptor — logs all HTTP requests and responses.
/// Redacts sensitive headers (Authorization, tokens).
class LoggingInterceptor extends Interceptor {
  final _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      printTime: true,
      colors: true,
    ),
  );

  static const _sensitiveHeaders = {
    'authorization',
    'cookie',
    'set-cookie',
  };

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final redactedHeaders = _redactHeaders(options.headers);

    _logger.i(
      '→ ${options.method} ${options.uri}\n'
      '  Headers: $redactedHeaders\n'
      '${options.data != null ? "  Body: ${_truncate(options.data.toString())}" : ""}',
    );

    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    _logger.i(
      '← ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.uri}\n'
      '  Size: ${response.data?.toString().length ?? 0} bytes\n'
      '  Time: ${response.requestOptions.extra['startTime'] != null ? "${DateTime.now().difference(response.requestOptions.extra['startTime'] as DateTime).inMilliseconds}ms" : "N/A"}',
    );

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.e(
      '✗ ${err.response?.statusCode ?? "NO_STATUS"} ${err.requestOptions.method} ${err.requestOptions.uri}\n'
      '  Error: ${err.message}\n'
      '  Type: ${err.type}',
    );

    handler.next(err);
  }

  Map<String, dynamic> _redactHeaders(Map<String, dynamic> headers) {
    final redacted = Map<String, dynamic>.from(headers);
    for (final key in redacted.keys.toList()) {
      if (_sensitiveHeaders.contains(key.toLowerCase())) {
        redacted[key] = '[REDACTED]';
      }
    }
    return redacted;
  }

  String _truncate(String text, {int maxLength = 200}) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}... (truncated)';
  }
}