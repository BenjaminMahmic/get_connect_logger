library get_connect_logger;

import 'package:flutter/foundation.dart';
import 'package:get/get_connect.dart' as g;
import 'package:get_connect_logger/models/get_connect_logger_settings.dart';
import 'package:get_connect_logger/src/logger/logger.dart';

class GetConnectLogger {
  static bool _enabled = false;

  static void enableLogger(
    g.GetHttpClient httpClient, {
    GetConnectLoggerSettings? settings,
  }) {
    if (!kDebugMode || _enabled) return;
    _enabled = true;
    final Logger logger = Logger(httpClient, settings: settings);
    logger.startLogging();
  }
}
