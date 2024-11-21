import 'package:mqtt_client/mqtt_client.dart';
import 'package:wifi_smart_living/device_specification/thermostat_interface.dart';
import 'package:wifi_smart_living/models/database/model_schedule_group.dart';
import 'package:wifi_smart_living/mqtt/mqtt_topic_handler/topic_builder.dart';
import 'package:wifi_smart_living/mqtt_treiber/mqtt_commands/const_mqtt_commands.dart';
import 'package:wifi_smart_living/singelton/api_singelton.dart';
import 'package:wifi_smart_living/singelton/helper/api_singelton_helper.dart';
import 'package:wifi_smart_living/singelton/mqtt_singelton.dart';

class MqttDeleteheatingprofile {
  final MqttSingelton _mqttSingelton = MqttSingelton();

  Future<void> deleteHeatingProfileFromSchedule(
      {required String smPublicId}) async {
    List<String> groupIds = ApiSingeltonHelper()
        .getGroupIdsFromHeatingProfile(smPublicId: smPublicId);
    for (int i = 0; i < groupIds.length; i++) {
      await Future.forEach(groupIds, (element) async {
        deleteHetingProfileFromRoom(groupId: element);
      });
    }
  }

  Future<void> deleteHolidayProfileFromSchedule(
      {required String smPublicId}) async {
    List<String> groupIds = ApiSingeltonHelper()
        .getGroupIdsFromHeatingProfile(smPublicId: smPublicId);
    List<String> uniquegroupIds = groupIds.toSet().toList();
    await Future.forEach(uniquegroupIds, (element) async {
      deleteHolidayProfileFromRoom(groupId: element);
    });
  }

  Future<void> deleteHeatingProfileSingelRoom(
      {required ModelScheduleGroup group}) async {
    await deleteHetingProfileFromRoom(groupId: group.groupId);
  }

  Future<void> deleteHolidayProfileSingelRoom(
      {required ModelScheduleGroup group}) async {
    await deleteHolidayProfileFromRoom(groupId: group.groupId);
  }

  Future<void> deleteHetingProfileFromRoom({required String groupId}) async {
    List<String> macAdresses =
        ApiSingeltonHelper().determineRoomDeviceMacs(groupId: groupId);

    if (_mqttSingelton.getMqttConnectionSate() ==
        MqttConnectionState.connected) {
      await Future.forEach(macAdresses, (element) async {
        sendMqttCommand(macAdress: element);
      });
    }
  }

  void sendMqttCommand({required String macAdress}) {
    _mqttSingelton.sendMqttMessage(
        topic: MqttTopicBuilder.buildCommunicationTopic(
            home: ApiSingelton().getDatabaseUserModel.mqttUserName,
            mac: macAdress,
            profielIdentifier: ThermostatInterface.flags,
            broker: ApiSingelton().getDatabaseUserModel.broker),
        message: ConstMqttCommands.deleteHeatingProfile);
  }

  Future<void> deleteHolidayProfileFromRoom({required String groupId}) async {
    List<String> macAdresses =
        ApiSingeltonHelper().determineRoomDeviceMacs(groupId: groupId);
    List<String> uniqueMacAdresses = macAdresses.toSet().toList();

    if (_mqttSingelton.getMqttConnectionSate() ==
        MqttConnectionState.connected) {
      await Future.forEach(uniqueMacAdresses, (element) async {
        sendHolidayMqttCommand(macAdress: element);
      });
    }
  }

  void sendHolidayMqttCommand({required String macAdress}) {
    _mqttSingelton.sendMqttMessage(
        topic: MqttTopicBuilder.buildCommunicationTopic(
            home: ApiSingelton().getDatabaseUserModel.mqttUserName,
            mac: macAdress,
            profielIdentifier: ThermostatInterface.holidayProfile,
            broker: ApiSingelton().getDatabaseUserModel.broker),
        message: ConstMqttCommands.deleteHolidayProfile);
  }
}
