class GetConnectLoggerSettings {
  final int maxResponseLenght;
  final bool logBodyNullValues;

  GetConnectLoggerSettings({
    this.maxResponseLenght = 2000,
    this.logBodyNullValues = true,
  });
}
