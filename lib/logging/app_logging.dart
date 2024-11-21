class AppLogging {
  static final AppLogging _singelton = AppLogging._internal();
  AppLogging._internal();
  final List<ModelLogMessage> _logMessage = [];

  factory AppLogging() {
    return _singelton;
  }

  void addNewLogMessage(ModelLogMessage logMessage) {
    _logMessage.add(logMessage);
  }

  List<ModelLogMessage> get getLogMessages => _logMessage;
}

class ModelLogMessage {
  final String className;
  final String methodName;
  final String logMessage;
  late String timeStamp;

  ModelLogMessage(
      {required this.className,
      required this.methodName,
      required this.logMessage}) {
    timeStamp = DateTime.now().toString();
  }

  @override
  String toString() {
    return 'Class: $className method: $methodName logmessage: $logMessage';
  }
}
