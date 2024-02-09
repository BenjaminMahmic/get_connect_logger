library get_connect_logger;

import 'package:get/get_connect.dart' as g;

import 'helpers/console_log_helper.dart';

class GetConnectLogger {
  static int _requestNumber = 0;
  static final Map<int, Map<String, dynamic>> _requestsSha = {};

  static void enableLogger(g.GetHttpClient httpClient) {
    httpClient.addRequestModifier<void>((request) {
      _requestNumber++;
      _requestsSha[request.hashCode] = {};
      _requestsSha[request.hashCode]!['requestNumber'] = _requestNumber;
      _requestsSha[request.hashCode]!['startTime'] = DateTime.now();

      return request;
    });

    httpClient.addResponseModifier<void>((request, response) async {
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
        maxResponseLenghtForPrint: 1200,
      );

      return response;
    });
  }
}
