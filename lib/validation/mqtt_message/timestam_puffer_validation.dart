import '../../singelton/mqttMessagePuffer/mqtt_puffer_queue.dart';

///Description
///Puffer received mqtt messages for 40 seconds. Check if a message is older than 40 seconds
///
///Author: J. Anders
///created: 09-02-2023
///changed: 09-02-2023
///
///History:
///
///Notes:
///
class MqttPufferTimestampValidation {
  static const int _secondsInMs = 1000;
  //Time stamp validaion of 40 seconds
  static const int _timeStampValidationTimeInSeconds = 40;

  bool deleteMessage(MqttPufferItem item) {
    int timeStamp = DateTime.now().millisecondsSinceEpoch;
    int calculation = timeStamp - item.timestamp;
    return calculation >= _secondInMilliSecond();
  }

  int _secondInMilliSecond() {
    return _secondsInMs * _timeStampValidationTimeInSeconds;
  }
}
