class GetConnectLoggerSettings {
  final int maxResponseLenghtForPrint;
  final bool logBodyNullValues;

  GetConnectLoggerSettings({
    this.maxResponseLenghtForPrint = 2000,
    this.logBodyNullValues = false,
  });
}
