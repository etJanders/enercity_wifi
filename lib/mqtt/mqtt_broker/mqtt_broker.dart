import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:wifi_smart_living/device_specification/thermostat_interface.dart';
import 'package:wifi_smart_living/mqtt/config/mqtt_config_helper.dart';
import 'package:wifi_smart_living/mqtt/mqtt_broker/mqtt_callback_interface.dart';
import 'package:wifi_smart_living/mqtt/mqtt_topic_handler/topic_structure_helper.dart';
import 'package:wifi_smart_living/singelton/helper/mqtt_message_puffer.dart';
import '../message_helper/mqtt_message_helper.dart';

///Description
///Mqtt Broker Configuration and interaction
///
///Author: J. Anders
///created: 07-12-2022
///changed: 15-02-2023
///
///History:
///15-02-2023 enable cleasn season flag. App hat nach einem MQTT reconnect per QoS2
/// nicht immer alle Nachrichten zugestellt bekommen, bzw. oft auch fehlinformationen.
/// Daher kann ich mich nicht 100% auf den MQTT Nachrichtenpuffer verlassen.
///
///Nodes:
///
///use mqtts sertificate https://www.emqx.com/en/blog/using-mqtt-in-flutter
class MqttBroker {
  late MqttConfig _mqttConfig;
  late MqttServerClient _mqttServerClient;
  MqttCallback? mqttCallback;

  MqttBroker({required MqttConfig config}) {
    _mqttConfig = config;
    _initMqttClient();
  }

  void _initMqttClient() {
    _mqttServerClient = MqttServerClient.withPort(
        _mqttConfig.mqttUrl, _mqttConfig.clientId, _mqttConfig.port);
    _mqttServerClient.port = _mqttConfig.port;
    _mqttServerClient.keepAlivePeriod = _mqttConfig.keepAlive;
    _mqttServerClient.setProtocolV311();
    _mqttServerClient.autoReconnect = _mqttConfig.autoReconnectState;
    _mqttServerClient.connectionMessage = _initConnMessage(
        authName: _mqttConfig.mqttUserName,
        authPassword: _mqttConfig.mqttUserPassword);
    _mqttServerClient.onConnected = onConnected;
    _mqttServerClient.onDisconnected = onDisconnected;
    _mqttServerClient.logging(on: false);
  }

  MqttConnectMessage _initConnMessage(
      {required String authName, required String authPassword}) {
    return MqttConnectMessage()
        .authenticateAs(authName, authPassword)
        .startClean();
  }

  Future<MqttConnectionState> connect() async {
    MqttConnectionState connected = getConnectionState();
    if (connected != MqttConnectionState.connected ||
        connected != MqttConnectionState.connecting) {
      MqttClientConnectionStatus? status = await _mqttServerClient.connect();
      if (status != null) {
        connected = status.state;
      }
    }
    return connected;
  }

  void initMqttCallback(MqttCallback callback) {
    mqttCallback = callback;
  }

  void removeReturnCallback() {
    mqttCallback = null;
  }

  //Todo check how to throw InvalidTopicException
  int publishMessage({required String topic, required String message}) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    if (!message.startsWith('#')) {
      builder.addString("#${message.toUpperCase()}");
    } else {
      builder.addString(message.toUpperCase());
    }
    print("MqttBroker -> publishMessage() topic: $topic message: $message");
    return _mqttServerClient.publishMessage(
        topic, MqttQos.exactlyOnce, builder.payload!);
  }

  void subscribeTopic({required String mqttTopic}) {
    _mqttServerClient.subscribe(mqttTopic, MqttQos.exactlyOnce);
  }

  void unsubscibeTopic(String topic) {
    _mqttServerClient.unsubscribe(topic);
  }

  void disconnect() {
    _mqttServerClient.disconnect();
  }

  void onConnected() {
    print('MqttBroker onConnected');
    _initMqttListener();
  }

  void onDisconnected() {
    print('MqttBroker onDisconnected');
  }

  MqttConnectionState getConnectionState() {
    MqttConnectionState connectionState = MqttConnectionState.disconnected;
    connectionState = _mqttServerClient.connectionStatus!.state;
    return connectionState;
  }

  void _initMqttListener() {
    _mqttServerClient.updates!
        .listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage message = c[0].payload as MqttPublishMessage;

      final topic = c[0].topic;
      final payload =
          MqttPublishPayload.bytesToStringAsString(message.payload.message);

      TopicStructureHelper helper = TopicStructureHelper(recivedTopic: topic);
      if (helper.getDirectionIndex == TopicStructureHelper.aquaDirection ||
          helper.getDirectionIndex ==
              TopicStructureHelper.thermostatDirection) {
        if (mqttCallback != null) {
          mqttCallback!
              .receivedMessage(topic, MqttMessageHelper.getMessage(payload));
        }
        if (helper.getIdentifier == ThermostatInterface.targetTemperature) {
          MqttMessagePuffer().addNewData(
              mac: helper.getTopicMac,
              value: MqttMessageHelper.getMessage(payload));
        }
      }
    });
  }

  /*
  SecurityContext context = new SecurityContext()
  ..useCertificateChain('path/to/my_cert.pem')
  ..usePrivateKey('path/to/my_key.pem', password: 'key_password')
  ..setClientAuthorities('path/to/client.crt', password: 'password');
  client.secure = true;
  client.securityContext = context;

  */
}
