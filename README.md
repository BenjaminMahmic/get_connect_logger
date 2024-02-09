```dart
import 'package:get/get.dart';
import 'package:get_connect_logger/get_connect_logger.dart';

class ApiService extends GetConnect {
  @override
  void onInit() {
    GetConnectLogger.enableLogger(httpClient);
    super.onInit();
  }
```