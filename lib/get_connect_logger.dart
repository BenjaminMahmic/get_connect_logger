library get_connect_logger;

import 'package:get/get_connect.dart' as g;

class GetConnectLogger {
  static void enableLogger(g.GetHttpClient httpClient) {
    httpClient.addRequestModifier<void>((request) {
      print('Request: ${request.method} ${request.url}');
      return request;
    });

    httpClient.addResponseModifier<void>((request, response) {
      print('Response: ${response.statusCode} ${response.statusText}');
      return response;
    });
  }
}
