import 'package:mqtt_client/mqtt_client.dart';
import 'package:wifi_smart_living/mqtt/broker_fallback/broker_url_helper.dart';
import 'package:wifi_smart_living/mqtt/mqtt_topic_handler/topic_builder.dart';
import 'package:wifi_smart_living/singelton/api_singelton.dart';

import '../mqtt/config/client_id_generator.dart';
import '../mqtt/config/mqtt_config_helper.dart';
import '../mqtt/mqtt_broker/mqtt_broker.dart';
import '../mqtt/mqtt_broker/mqtt_callback_interface.dart';

///Description
///Singelton to realize the mqtt communication
///
///Author: J. Anders
///created: 07-12-2022
///changed: 07-12-2022
///
///History:
///
///Notes:
///
class MqttSingelton {
  //help to detect if broker url was switched
  bool brokerSwitched = false;

  MqttBroker? mqttBroke;

  static final MqttSingelton _singelton = MqttSingelton._internal();

  MqttSingelton._internal();

  factory MqttSingelton() {
    return _singelton;
  }

  Future<MqttConnectionState> startConnection() async {
    var config = await _createConfig();
    MqttConnectionState state = getMqttConnectionSate();
    if (MqttConnectionState.disconnected == state ||
        MqttConnectionState.disconnecting == state ||
        MqttConnectionState.faulted == state) {
      mqttBroke = MqttBroker(config: config);
      state = await mqttBroke!.connect();
      if (state == MqttConnectionState.connected) {
        subscribeTopic();
      }
    }
    return state;
  }

  Future<MqttConfig> _createConfig() async {
    ApiSingelton apisingelton = ApiSingelton();
    String clientId = await GeneriereClientId.generateClientIdNumber(
        home: apisingelton.getDatabaseUserModel.mqttUserName);
    return MqttConfig(
        mqttUrl: await BrokerUrlHelper().getDefaultUrl(),
        clientId: clientId,
        mqttUserName: apisingelton.getDatabaseUserModel.mqttUserName,
        mqttUserPassword: apisingelton.getDatabaseUserModel.mqttUserPassword);
  }

  MqttConnectionState getMqttConnectionSate() {
    MqttConnectionState state = MqttConnectionState.disconnected;
    if (mqttBroke != null) {
      state = mqttBroke!.getConnectionState();
    }
    print(state);
    return state;
  }

  void subscribeTopic() {
    mqttBroke!.subscribeTopic(
        mqttTopic: MqttTopicBuilder.buildSubscribeTopic(
            home: ApiSingelton().getDatabaseUserModel.mqttUserName,
            broker: ApiSingelton().getDatabaseUserModel.broker));
  }

  void unsubscribeTopic() {
    if (mqttBroke != null) {
      mqttBroke!.unsubscibeTopic(MqttTopicBuilder.buildSubscribeTopic(
          home: ApiSingelton().getDatabaseUserModel.mqttUserName,
          broker: ApiSingelton().getDatabaseUserModel.broker));
    }
  }

  void sendMqttMessage({required String topic, required String message}) {
    if (mqttBroke != null) {
      mqttBroke!.publishMessage(message: message, topic: topic);
    }
  }

  Future<void> sendMqttMessageWithDelay(
      {required String topic, required String message}) async {
    await Future.delayed(const Duration(milliseconds: 20), () {
      if (mqttBroke != null) {
        mqttBroke!.publishMessage(message: message, topic: topic);
      }
    });
  }

  void removeCallback() {
    if (mqttBroke != null) {
      mqttBroke!.removeReturnCallback();
    }
  }

  void closeMqttConnection() {
    if (mqttBroke != null) {
      mqttBroke!.disconnect();
      mqttBroke = null;
    }
  }

  void initCallback(MqttCallback mqttCallback) {
    if (mqttBroke != null) {
      mqttBroke!.initMqttCallback(mqttCallback);
    }
  }
}
