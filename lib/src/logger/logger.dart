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
    _httpClient.addRequestModifier<void>((request) {
      _requestNumber++;
      _requestsSha[request.hashCode] = {};
      _requestsSha[request.hashCode]!['requestNumber'] = _requestNumber;
      _requestsSha[request.hashCode]!['startTime'] = DateTime.now();

      return request;
    });

    _httpClient.addResponseModifier<void>((request, response) async {
      final reqNumber = _requestsSha[request.hashCode];
      _requestsSha.remove(request.hashCode);

      await ConsoleLogHelper.logGetRequest(
        request,
        requestNumber: reqNumber!['requestNumber'],
      );

      ConsoleLogHelper.logGetResponse(
        request,
        response,
        requestNumber: reqNumber['requestNumber'],
        reqStartTime: reqNumber['startTime'],
        maxResponseLenghtForPrint: _settings!.maxResponseLenght,
        logBodyNullValues: _settings!.logBodyNullValues,
      );

      return response;
    });
  }
}
