import 'package:mqtt_client/mqtt_client.dart';
import 'package:wifi_smart_living/device_specification/thermostat_interface.dart';
import 'package:wifi_smart_living/mqtt/mqtt_topic_handler/topic_builder.dart';
import 'package:wifi_smart_living/mqtt_treiber/mqtt_commands/const_mqtt_commands.dart';
import 'package:wifi_smart_living/singelton/api_singelton.dart';
import 'package:wifi_smart_living/singelton/helper/api_singelton_helper.dart';
import 'package:wifi_smart_living/singelton/mqtt_singelton.dart';

class MqttResetDeviceHelper {
  final MqttSingelton _mqttSingelton = MqttSingelton();

  Future<void> resetMqttDevices({required String groupId}) async {
    List<String> macAdresses =
        ApiSingeltonHelper().determineRoomDeviceMacs(groupId: groupId);
    MqttConnectionState conState = _mqttSingelton.getMqttConnectionSate();
    if (conState == MqttConnectionState.connected) {
      for (int i = 0; i < macAdresses.length; i++) {
        _mqttSingelton.sendMqttMessage(
            topic: MqttTopicBuilder.buildCommunicationTopic(
                home: ApiSingelton().getDatabaseUserModel.mqttUserName,
                mac: macAdresses[i],
                profielIdentifier: ThermostatInterface.flags,
                broker: ApiSingelton().getDatabaseUserModel.broker),
            message: ConstMqttCommands.resetDevices);
      }
    }
  }

  Future<void> resetSingelDevice({required String mac}) async {
    MqttConnectionState conState = _mqttSingelton.getMqttConnectionSate();
    if (conState == MqttConnectionState.connected) {
      _mqttSingelton.sendMqttMessage(
          topic: MqttTopicBuilder.buildCommunicationTopic(
              home: ApiSingelton().getDatabaseUserModel.mqttUserName,
              mac: mac,
              profielIdentifier: ThermostatInterface.flags,
              broker: ApiSingelton().getDatabaseUserModel.broker),
          message: ConstMqttCommands.resetDevices);
    }
  }
}
