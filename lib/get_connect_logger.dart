library get_connect_logger;

import 'package:flutter/foundation.dart';
import 'package:get/get_connect.dart' as g;
import 'package:get_connect_logger/models/get_connect_logger_settings.dart';
import 'package:get_connect_logger/src/logger/logger.dart';

/// A logger for GetConnect HTTP requests and responses.
class GetConnectLogger {
  GetConnectLogger._();

  static GetConnectLogger? _instance;

  /// Singleton instance of [GetConnectLogger].
  static GetConnectLogger get instance {
    _instance ??= GetConnectLogger._();
    return _instance!;
  }

  bool _enabled = false;

  /// Enables logging for HTTP requests and responses.
  ///
  /// When called, this method activates logging for all HTTP requests and responses
  /// made through the provided [httpClient]. If [settings] are provided, they can
  /// be used to configure the logger behavior.
  ///
  /// Only activates logging in debug mode.
  ///
  /// Example:
  /// ```dart
  /// GetConnectLogger.instance.enableLogger(
  ///   GetHttpClient(), // Provide your GetConnect HTTP client instance
  ///   settings: GetConnectLoggerSettings(), // Optional settings
  /// );
  /// ```
  void enableLogger(
    g.GetHttpClient httpClient, {
    GetConnectLoggerSettings? settings,
  }) {
    if (!kDebugMode || _enabled) return;
    _enabled = true;
    final Logger logger = Logger(httpClient, settings: settings);
    logger.startLogging();
  }
}
