///Description
///Callback Interface for received MQTT Messages
///
///Author: J. Anders
///created: 07-12-2022
///changed: 07-12-2022
///
///History:
///
///Nodes:
abstract class MqttCallback {
  void receivedMessage(String topic, String message);
}
