import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wifi_smart_living/thermostat_attributes/holiday_profile.dart';

import '../../api_handler/api_treiber/add_room_to_schedule/add_rooms_to_schedule_helper.dart';
import '../../api_handler/api_treiber/heating_profile/update_heating_profile_helper.dart';
import '../../converter/holiday_profile_builder.dart';
import '../../mqtt_treiber/send_time_schedule/mqtt_send_time_schedule.dart';
import '../../singelton/helper/api_singelton_helper.dart';

part 'add_room_to_schedule_event.dart';
part 'add_room_to_schedule_state.dart';

///Description
///Block to manage the add room to schedule event
///
///Author: J. Anders
///created: 01-02-2023
///changed: 01-02-2023
///
///History:
///
///Notes:
///
class AddRoomToScheduleBloc
    extends Bloc<AddRoomToScheduleEvent, AddRoomToScheduleState> {
  UpdateTimeScheduleHelper updateTimeScheduleHelper =
      UpdateTimeScheduleHelper();
  MqttSendTimeScheduleHelper mqttSendTimeScheduleHelper =
      MqttSendTimeScheduleHelper();

  AddRoomToScheduleBloc() : super(AddRoomToScheduleInitial()) {
    on<AddRoomsToSchedule>((event, emit) async {
      ///Lege Verknüpfung an zwischen raum und zeitplan
      AddRoomsToScheduleHelperState response =
          await AddNewRoomsToScheduleHelper().addNewRooms(
              groupIds: event.groupIds, smPublicId: event.smPublicId);
      if (response == AddRoomsToScheduleHelperState.succesfullAdded) {
        MqttTimeScheduleState mqttState =
            await mqttSendTimeScheduleHelper.sendDataToDevices(
                deviceMacs:
                    ApiSingeltonHelper().getMacsFromRooms(event.groupIds),
                roomProfiles: updateTimeScheduleHelper.roomProfile(
                    event.groupIds[0], event.scheduleMap));
        // }
        if (mqttState == MqttTimeScheduleState.dataSend) {
          await updateTimeScheduleHelper.updateTimeScheduleProfile(
              groupIds: event.groupIds, profileData: event.scheduleMap);
        }
      }
      emit(AddRoomToScheduleResponse(state: response));
    });
    on<AddRoomsToHolidaySchedule>((event, emit) async {
      ///Lege Verknüpfung an zwischen raum und zeitplan
      AddRoomsToScheduleHelperState response =
          await AddNewRoomsToScheduleHelper().addNewRooms(
              groupIds: event.groupIds, smPublicId: event.smPublicId);
      if (response == AddRoomsToScheduleHelperState.succesfullAdded) {
        MqttTimeScheduleState mqttState =
            await mqttSendTimeScheduleHelper.sendHolidayProfiel(
                deviceMacs:
                    ApiSingeltonHelper().getMacsFromRooms(event.groupIds),
                holidayProfile: event.holidayProfile);

        if (mqttState == MqttTimeScheduleState.dataSend) {
          UpdateTimeScheduleState updateState =
              await updateTimeScheduleHelper.updateHolidayProfile(
                  groupIds: event.groupIds,
                  profileValue: BuildHolidayProfile.buildHolidayDataString(
                      event.holidayProfile));
        }
      }
      emit(AddRoomToScheduleResponse(state: response));
    });
  }
}
