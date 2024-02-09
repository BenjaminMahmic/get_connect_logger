## BM GetConnect Logger
- This package is a simple logger for GetConnect. It logs the request and response of the GetConnect client.

- The package is fully safe to use in production. It will only log the request and response when the app is in debug mode.

### Usage
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