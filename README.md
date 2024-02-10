## BM GetConnect Logger
BM GetConnect Logger is a lightweight and efficient logging package for GetConnect. It logs both the request and response of the GetConnect client, providing valuable insights for debugging and development.

### Safety
This package is designed with production safety in mind. It only logs the request and response when the app is in debug mode, ensuring no sensitive data is logged in a production environment.

### Usage
```dart
import 'package:get/get.dart';
import 'package:get_connect_logger/get_connect_logger.dart';

class ApiService extends GetConnect {
  @override
  void onInit() {
    GetConnectLogger.instance.enableLogger(httpClient);
    super.onInit();
  }
}

// Alternatively

class ApiService extends GetConnect {
  ApiService() {
    GetConnectLogger.instance.enableLogger(httpClient);
  }
}
```

### About `enableLogger`
`enableLogger` is a method in the GetConnectLogger singleton class. It enables logging for HTTP requests and responses made by the GetConnect instance.

Despite the number of times `enableLogger` is called, logging **will only be enabled once**. This is because enableLogger checks if logging is already enabled before proceeding. If logging is already enabled, enableLogger will return without performing any action.

This design prevents unnecessary multiple logging activations, which could potentially lead to performance issues.

### Result

![Screenshot_2](https://github.com/BenjaminMahmic/get_connect_logger/assets/89051381/65a0a87c-6f45-4b54-83f5-fbc6f46d908b)

