// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:wifi_smart_living/api_handler/api_treiber/update_database_entries/update_database_entry_helper.dart';
import 'package:wifi_smart_living/const/const_api.dart';
import 'package:wifi_smart_living/device_specification/thermostat_interface.dart';
import 'package:wifi_smart_living/models/database/model_device_manaagement.dart';
import 'package:wifi_smart_living/models/database/model_device_profile.dart';
import 'package:wifi_smart_living/models/database/model_room_profile.dart';
import 'package:wifi_smart_living/mqtt/mqtt_broker/mqtt_callback_interface.dart';
import 'package:wifi_smart_living/mqtt/mqtt_topic_handler/topic_builder.dart';
import 'package:wifi_smart_living/singelton/api_singelton.dart';
import 'package:wifi_smart_living/singelton/mqtt_singelton.dart';
import 'package:wifi_smart_living/thermostat_attributes/group_function/device_group_helpder.dart';

part 'thermostat_interaction_event.dart';
part 'thermostat_interaction_state.dart';

class ThermostatInteractionBloc
    extends Bloc<ThermostatInteractionEvent, ThermostatInteractionState> {
  MqttSingelton mqttSingelton = MqttSingelton();

  ThermostatInteractionBloc() : super(ThermostatInteractionInitial()) {
    on<MqttInitCallback>((event, emit) {
      MqttConnectionState state = mqttSingelton.getMqttConnectionSate();
      if (state == MqttConnectionState.connected ||
          state == MqttConnectionState.connecting) {
        mqttSingelton.initCallback(event.callback);
        emit(ThermostatInteractionInitial());
      }
    });

    on<SendMqttData>((event, emit) async {
      MqttConnectionState state = mqttSingelton.getMqttConnectionSate();
      if (state == MqttConnectionState.connected) {
        mqttSingelton.sendMqttMessage(
            topic: MqttTopicBuilder.buildCommunicationTopic(
                home: ApiSingelton().getDatabaseUserModel.mqttUserName,
                mac: event.macAdresses,
                profielIdentifier: event.profileIdentifier,
                broker: ApiSingelton().getDatabaseUserModel.broker),
            message: event.profileValue);
        emit(MqttDeviceProfileSuccesfullSent(
            profileIdentifier: event.profileIdentifier));
      } else {
        emit(MqttTransmissionError());
      }
    });

    on<SendMqttToDeviceList>((event, emit) {
      MqttConnectionState state = mqttSingelton.getMqttConnectionSate();
      if (state == MqttConnectionState.connected) {
        List<ModelDeviceManagament> list = event.macAdresses;
        for (int i = 0; i < list.length; i++) {
          mqttSingelton.sendMqttMessage(
              topic: MqttTopicBuilder.buildCommunicationTopic(
                  home: ApiSingelton().getDatabaseUserModel.mqttUserName,
                  mac: list[i].deviceMac,
                  profielIdentifier: event.profileIdentifier,
                  broker: ApiSingelton().getDatabaseUserModel.broker),
              message: event.profileValue);
          if (event.profileIdentifier ==
              ThermostatInterface.targetTemperature) {
            mqttSingelton.sendMqttMessage(
                topic: MqttTopicBuilder.buildCommunicationTopic(
                    home: ApiSingelton().getDatabaseUserModel.mqttUserName,
                    mac: list[i].deviceMac,
                    profielIdentifier: ThermostatInterface.getOrDeviceType,
                    broker: ApiSingelton().getDatabaseUserModel.broker),
                message: '01000000');
          }
        }
        emit(MqttDeviceProfileSuccesfullSent(
            profileIdentifier: event.profileIdentifier));
      } else {
        emit(MqttTransmissionError());
      }
    });

    on<UpdateDeviceProfileEntrie>((event, emit) async {
      UpdateDatabaseState state = await UpdateDatabaseEntryHelper()
          .updateDatabaseEntry(
              model: event.deviceProfile,
              api: ConstApi.updateDeviceProfilesPut);
      emit(DatabaseResponse(state: state));
    });

    on<UpdateRoomProfileEntrie>((event, emit) async {
      UpdateDatabaseState state = await UpdateDatabaseEntryHelper()
          .updateDatabaseEntry(
              model: event.roomProfile, api: ConstApi.updateRoomProfilePut);
      emit(DatabaseResponse(state: state));
    });

    on<GroupOrganizer>((event, emit) async {
      print('Organize Group');
      DeviceGroupHelper groupHelper = DeviceGroupHelper(groupId: event.groupId);
      List<ModelDeviceProfile> groupDevices =
          groupHelper.getUpdatableDeviceGroups();
      if (groupDevices.isNotEmpty) {
        print('Organize Group erstelle gruppe');
        MqttConnectionState state = mqttSingelton.getMqttConnectionSate();
        if (state == MqttConnectionState.connected) {
          ///Sende die Group Infos an alle Thermostate
          for (int i = 0; i < groupDevices.length; i++) {
            mqttSingelton.sendMqttMessage(
                topic: MqttTopicBuilder.buildCommunicationTopic(
                    home: ApiSingelton().getDatabaseUserModel.mqttUserName,
                    mac: groupDevices[i].macAdress,
                    profielIdentifier: ThermostatInterface.groupMac,
                    broker: ApiSingelton().getDatabaseUserModel.broker),
                message: 'S${groupHelper.getModelRoomProfile.profileValue}');
          }

          await UpdateDatabaseEntryHelper().updateDatabaseEntry(
              model: groupHelper.getModelRoomProfile,
              api: ConstApi.updateRoomProfilePut);
          await UpdateDatabaseEntryHelper().updateDatabaseByList(
              databaseModels: groupDevices,
              api: ConstApi.updateDeviceProfileByListPut);
        }
      } else {
        print('Organize Group keine gruppe noetig');
      }
      emit(GroupOrganized());
    });
  }
}
