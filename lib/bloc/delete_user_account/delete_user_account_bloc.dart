// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wifi_smart_living/api_handler/api_treiber/reset_heating_profiles/reset_heating_profile.dart';
import 'package:wifi_smart_living/const/const_schedule_id.dart';
import 'package:wifi_smart_living/device_specification/thermostat_interface.dart';
import 'package:wifi_smart_living/models/database/model_schedule_group.dart';
import 'package:wifi_smart_living/models/database/model_schedule_manager.dart';
import 'package:wifi_smart_living/mqtt/mqtt_topic_handler/topic_builder.dart';
import 'package:wifi_smart_living/mqtt_treiber/mqtt_commands/const_mqtt_commands.dart';
import 'package:wifi_smart_living/mqtt_treiber/reset_devices/reset_mqtt_device_helper.dart';
import 'package:wifi_smart_living/mqtt_treiber/reset_heating_profile/reset_heating_profile.dart';
import 'package:wifi_smart_living/singelton/api_singelton.dart';
import 'package:wifi_smart_living/singelton/helper/change_room_ui_position.dart';
import 'package:wifi_smart_living/singelton/mqtt_singelton.dart';

import '../../api_handler/api_treiber/delete_room_helper/delete_room_helper.dart';
import '../../api_handler/api_treiber/user_management/delete_user_account_helper.dart';
import '../../const/const_location.dart';
import '../../singelton/helper/api_singelton_helper.dart';

part 'delete_user_account_event.dart';
part 'delete_user_account_state.dart';

///Description
///Delete Database Entry algorithms
///
///Author: J. Anders
///created: 05-01-2023
///changed: 30-01-2023
///
///History:
///30-01-2023 Send a reset command to all devices
///
///Notes:
///
class DeleteDatabaseEntriesBloc
    extends Bloc<DeleteUserAccountEvent, DeleteDatabaseEntriesState> {
  DeleteDatabaseEntriesBloc() : super(DeleteUserAccountInitial()) {
    on<DeleteUserAccountInitialEvent>(
      (event, emit) {
        emit(DeleteUserAccountInitial());
      },
    );

    on<DeleteUserAccount>((event, emit) async {
      emit(ShowLoadingSpinner(showLoadingSpinner: true));
      MqttSingelton singelton = MqttSingelton();
      for (int i = 0; i < ApiSingelton().getModelDeviceManagement.length; i++) {
        singelton.sendMqttMessage(
            topic: MqttTopicBuilder.buildCommunicationTopic(
                home: ApiSingelton().getDatabaseUserModel.mqttUserName,
                mac: ApiSingelton().getModelDeviceManagement[i].deviceMac,
                profielIdentifier: ThermostatInterface.flags,
                broker: ApiSingelton().getDatabaseUserModel.broker),
            message: ConstMqttCommands.resetDevices);
      }
      DeleteAccountState state =
          await DeleteUserAccountHelper().deleteUserAccount();

      emit(ShowLoadingSpinner(showLoadingSpinner: false));
      emit(DeleteUserResponseState(state: state));
    });

    on<DeleteRoomFromDatabase>((event, emit) async {
      emit(ShowLoadingSpinner(showLoadingSpinner: true));
      DeleteEntryState state = await DeleteRoomFromDatabaseHelper()
          .deletRoomFromDatabase(groupId: event.groupId);

      if (state == DeleteEntryState.roomSuccesfulDeleted) {
        await MqttResetDeviceHelper().resetMqttDevices(groupId: event.groupId);
        //Reorganize UI Position after a room is removed
        ChangeUIPositionHelper uiPositionHelper = ChangeUIPositionHelper();
        uiPositionHelper.changeUiPositionNumber(ApiSingeltonHelper()
            .groupManagementsByLocation(
                ConstLocationidentifier.locationidentifierIndoorInt));
      }
      emit(DeleteRoomFromDatabaseState(state: state));
      emit(ShowLoadingSpinner(showLoadingSpinner: false));
    });

    on<DeleteDeviceFromDatabase>((event, emit) async {
      emit(ShowLoadingSpinner(showLoadingSpinner: true));
      DeleteEntryState state = await DeleteRoomFromDatabaseHelper()
          .deleteDeviceFromDatabase(mac: event.macAdress);
      if (state == DeleteEntryState.roomSuccesfulDeleted) {
        await MqttResetDeviceHelper().resetSingelDevice(mac: event.macAdress);
      }
      emit(DeleteDeviceFromDatabaseState(state: state));
      emit(ShowLoadingSpinner(showLoadingSpinner: false));
    });

    on<DeleteScheduleFromDatabase>((event, emit) async {
      emit(ShowLoadingSpinner(showLoadingSpinner: true));
      DeleteEntryState state = await DeleteRoomFromDatabaseHelper()
          .deleteScheduleFromDatabase(
              smPublicId: event.smPublicId.entryPublicId);
      if (state == DeleteEntryState.scheduleSuccesfulDeleted) {
        if (event.smPublicId.scheduleId ==
            ConstScheduleId.timeScheduleProfileId) {
          //Reset Datenbank
          await ResetHeatingProfileHelper()
              .resetHeatingProfiles(smPublicId: event.smPublicId.entryPublicId);
          //Delete heating profiles from devices
          await MqttDeleteheatingprofile().deleteHeatingProfileFromSchedule(
              smPublicId: event.smPublicId.entryPublicId);
        } else if (event.smPublicId.scheduleId ==
            ConstScheduleId.holidayProfileScheduleId) {
          await ResetHeatingProfileHelper()
              .resetHolidayprofile(smPublicId: event.smPublicId.entryPublicId);
          //
          // await MqttDeleteheatingprofile().deleteHolidayProfileFromSchedule(
          //     smPublicId: event.smPublicId.entryPublicId);
        }
      }
      emit(DeleteScheduleFromDatabaseState(state: state));
      emit(ShowLoadingSpinner(showLoadingSpinner: false));
    });

    on<DeleteHolidayScheduleFromDatabase>((event, emit) async {
      emit(ShowLoadingSpinner(showLoadingSpinner: true));
      DeleteEntryState state = await DeleteRoomFromDatabaseHelper()
          .deleteScheduleFromDatabase(
              smPublicId: event.smPublicId.entryPublicId);
      if (state == DeleteEntryState.scheduleSuccesfulDeleted) {
        if (event.smPublicId.scheduleId ==
            ConstScheduleId.timeScheduleProfileId) {
          //Reset Datenbank
          await ResetHeatingProfileHelper()
              .resetHeatingProfiles(smPublicId: event.smPublicId.entryPublicId);
          //Delete heating profiles from devices
          await MqttDeleteheatingprofile().deleteHeatingProfileFromSchedule(
              smPublicId: event.smPublicId.entryPublicId);
        } else if (event.smPublicId.scheduleId ==
            ConstScheduleId.holidayProfileScheduleId) {
          await ResetHeatingProfileHelper()
              .resetHolidayprofile(smPublicId: event.smPublicId.entryPublicId);
          //
          await MqttDeleteheatingprofile().deleteHolidayProfileFromSchedule(
              smPublicId: event.smPublicId.entryPublicId);
        }
      }
      emit(DeleteScheduleFromDatabaseState(state: state));
      emit(ShowLoadingSpinner(showLoadingSpinner: false));
    });

    on<DeleteSingelRoomFromSchedule>((event, emit) async {
      emit(ShowLoadingSpinner(showLoadingSpinner: true));
      DeleteEntryState state = await DeleteRoomFromDatabaseHelper()
          .deleteSingelRoomFromSchedule(event.scheduleGroup);
      if (state == DeleteEntryState.roomSuccesfulDeleted) {
        //  Aktualisiere Datenbank Eintraege des entsprechenden Raumes
        await ResetHeatingProfileHelper().resetSingleHeatingProfiles(
            smPublicId: event.scheduleGroup.scheduleManagerPublicId,
            groupId: event.scheduleGroup.groupId);
        //Entferne das HP vom Thermostat
        await MqttDeleteheatingprofile()
            .deleteHeatingProfileSingelRoom(group: event.scheduleGroup);
      }
      emit(DeleteScheduleFromDatabaseState(state: state));
      emit(ShowLoadingSpinner(showLoadingSpinner: false));
    });

    on<DeleteSingelRoomFromHolidaySchedule>((event, emit) async {
      emit(ShowLoadingSpinner(showLoadingSpinner: true));
      DeleteEntryState state = await DeleteRoomFromDatabaseHelper()
          .deleteSingelRoomFromSchedule(event.scheduleGroup);
      if (state == DeleteEntryState.roomSuccesfulDeleted) {
        //  Aktualisiere Datenbank Eintraege des entsprechenden Raumes
        await ResetHeatingProfileHelper().resetSingleHolidayProfiles(
            smPublicId: event.scheduleGroup.scheduleManagerPublicId,
            groupId: event.scheduleGroup.groupId);
        //Entferne das HP vom Thermostat
        await MqttDeleteheatingprofile()
            .deleteHolidayProfileSingelRoom(group: event.scheduleGroup);
      }
      emit(DeleteScheduleFromDatabaseState(state: state));
      emit(ShowLoadingSpinner(showLoadingSpinner: false));
    });
  }
}
