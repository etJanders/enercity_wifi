// ignore_for_file: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wifi_smart_living/converter/holiday_profile_builder.dart';
import 'package:wifi_smart_living/singelton/helper/api_singelton_helper.dart';
import 'package:wifi_smart_living/thermostat_attributes/holiday_profile.dart';

import '../../api_handler/api_treiber/heating_profile/update_heating_profile_helper.dart';
import '../../mqtt_treiber/send_time_schedule/mqtt_send_time_schedule.dart';

part 'send_schedule_event.dart';
part 'send_schedule_state.dart';

class SendScheduleBloc extends Bloc<SendScheduleEvent, SendScheduleState> {
  UpdateTimeScheduleHelper updateTimeScheduleHelper =
      UpdateTimeScheduleHelper();

  MqttSendTimeScheduleHelper mqttSendTimeScheduleHelper =
      MqttSendTimeScheduleHelper();

  SendScheduleBloc() : super(SendScheduleInitial()) {
    on<SendNewSchedule>((event, emit) async {
      MqttTimeScheduleState mqttState =
          await mqttSendTimeScheduleHelper.sendDataToDevices(
              deviceMacs: ApiSingeltonHelper()
                  .getAllDevicesOfSchedule(smPublicId: event.smPublicId),
              roomProfiles: updateTimeScheduleHelper.roomProfile(
                  ApiSingeltonHelper().getGroupIdsFromHeatingProfile(
                      smPublicId: event.smPublicId)[0],
                  event.scheduleMap));

      if (mqttState == MqttTimeScheduleState.dataSend) {
        UpdateTimeScheduleState updateState =
            await updateTimeScheduleHelper.updateTimeScheduleProfile(
                groupIds: ApiSingeltonHelper().getGroupIdsFromHeatingProfile(
                    smPublicId: event.smPublicId),
                profileData: event.scheduleMap);

        emit(UpdateScheduleDatabase(updateState: updateState));
      } else {
        emit(MqttConnectionError());
      }
    });

    on<SendNewHolidayProfiel>((event, emit) async {
      MqttTimeScheduleState mqttState =
          await mqttSendTimeScheduleHelper.sendHolidayProfiel(
              deviceMacs: ApiSingeltonHelper()
                  .getAllDevicesOfSchedule(smPublicId: event.smPublicId),
              holidayProfile: event.holidayProfile);
      if (mqttState == MqttTimeScheduleState.dataSend) {
        UpdateTimeScheduleState updateState =
            await updateTimeScheduleHelper.updateHolidayProfile(
                groupIds: ApiSingeltonHelper().getGroupIdsFromHeatingProfile(
                    smPublicId: event.smPublicId),
                profileValue: BuildHolidayProfile.buildHolidayDataString(
                    event.holidayProfile));
        emit(UpdateScheduleDatabase(updateState: updateState));
      } else {
        emit(MqttConnectionError());
      }
    });
  }
}
