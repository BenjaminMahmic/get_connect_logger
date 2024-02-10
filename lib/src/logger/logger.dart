import 'package:get/get_connect.dart' as g;
import 'package:get_connect_logger/models/get_connect_logger_settings.dart';
import 'package:get_connect_logger/src/helpers/console_log_helper.dart';

class Logger {
  final g.GetHttpClient _httpClient;
  final GetConnectLoggerSettings? _settings;

  int _requestNumber = 0;
  final Map<int, Map<String, dynamic>> _requestsSha = {};

  Logger(this._httpClient, {GetConnectLoggerSettings? settings})
      : _settings = settings ?? GetConnectLoggerSettings();

  void startLogging() {
    _httpClient.addRequestModifier<dynamic>((request) {
      final hashCode = request.hashCode;
      _requestNumber++;
      _requestsSha[hashCode] = {};
      _requestsSha[hashCode]!['requestNumber'] = _requestNumber;
      _requestsSha[hashCode]!['startTime'] = DateTime.now();

      return request;
    });

    _httpClient.addResponseModifier<dynamic>((request, response) async {
      ConsoleLogHelper.printConsoleMessage(
        request,
        response,
        requestNumber: _requestsSha[request.hashCode]?['requestNumber'],
        reqStartTime: _requestsSha[request.hashCode]?['startTime'],
        maxResponseLenghtForPrint: _settings!.maxResponseLenghtForPrint,
        logBodyNullValues: _settings!.logBodyNullValues,
      );
      _requestsSha.remove(request.hashCode);

      return response;
    });
  }
}
