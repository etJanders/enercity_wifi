import 'package:mqtt_client/mqtt_client.dart';
import 'package:wifi_smart_living/converter/holiday_profile_builder.dart';
import 'package:wifi_smart_living/device_specification/thermostat_interface.dart';
import 'package:wifi_smart_living/mqtt/mqtt_topic_handler/topic_builder.dart';
import 'package:wifi_smart_living/singelton/api_singelton.dart';
import 'package:wifi_smart_living/singelton/mqtt_singelton.dart';
import 'package:wifi_smart_living/thermostat_attributes/holiday_profile.dart';

import '../../models/database/model_room_profile.dart';

class MqttSendTimeScheduleHelper {
  MqttSingelton mqttSingelton = MqttSingelton();

  Future<MqttTimeScheduleState> sendDataToDevices(
      {required List<String> deviceMacs,
      required List<ModelRoomProfile> roomProfiles}) async {
    MqttTimeScheduleState state = MqttTimeScheduleState.noMqttConnection;
    if (mqttSingelton.getMqttConnectionSate() ==
        MqttConnectionState.connected) {
      for (int i = 0; i < deviceMacs.length; i++) {
        String mac = deviceMacs[i];
        for (int j = 0; j < roomProfiles.length; j++) {
          ModelRoomProfile profile = roomProfiles[j];
          await mqttSingelton.sendMqttMessageWithDelay(
              topic: MqttTopicBuilder.buildCommunicationTopic(
                  home: ApiSingelton().getDatabaseUserModel.mqttUserName,
                  mac: mac,
                  profielIdentifier: profile.profileId,
                  broker: ApiSingelton().getDatabaseUserModel.broker),
              message: profile.profileValue);
        }
      }
      state = MqttTimeScheduleState.dataSend;
    }
    return state;
  }

  Future<MqttTimeScheduleState> sendHolidayProfiel(
      {required List<String> deviceMacs,
      required HolidayProfile holidayProfile}) async {
    MqttTimeScheduleState state = MqttTimeScheduleState.noMqttConnection;
    if (mqttSingelton.getMqttConnectionSate() ==
        MqttConnectionState.connected) {
      for (int i = 0; i < deviceMacs.length; i++) {
        String mac = deviceMacs[i];
        mqttSingelton.sendMqttMessage(
            topic: MqttTopicBuilder.buildCommunicationTopic(
                home: ApiSingelton().getDatabaseUserModel.mqttUserName,
                mac: mac,
                profielIdentifier: ThermostatInterface.holidayProfile,
                broker: ApiSingelton().getDatabaseUserModel.broker),
            message:
                BuildHolidayProfile.buildHolidayDataString(holidayProfile));
      }
      state = MqttTimeScheduleState.dataSend;
    }
    return state;
  }
}

enum MqttTimeScheduleState {
  noMqttConnection,
  dataSend;
}
