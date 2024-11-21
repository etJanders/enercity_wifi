import 'package:wifi_smart_living/const/const_mqtt.dart';

///Descriptions
///specify all attributes are used for mqtt configuration
///
///Author: J. Anders
///created: 07-12-2022
///changed: 07-12-2022
///
///History:
///
///Nodes:
///
class MqttConfig {
  final String mqttUrl;
  final String mqttUserName;
  final String mqttUserPassword;
  final String clientId;
  final int port;
  final int keepAlive;
  final bool autoReconnectState;

  MqttConfig(
      {required this.mqttUrl,
      required this.clientId,
      required this.mqttUserName,
      required this.mqttUserPassword,
      this.port = ConstMqtt.defaultBrokerPort,
      this.keepAlive = ConstMqtt.keepAliveInterval,
      this.autoReconnectState = ConstMqtt.autoReconnectState});
}
