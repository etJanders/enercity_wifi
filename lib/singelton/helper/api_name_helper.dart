import 'package:wifi_smart_living/singelton/api_singelton.dart';

import '../../const/const_schedule_id.dart';

///Description
///Check if a new name is in use. Every name of an object can be used only once
///
///Author: J. Anders
///created: 17-01-2023
///changed: 17-01-2023
///
///History:
///
///Notes
class ApiNameHelper {
  final ApiSingelton singelton = ApiSingelton();

  bool deviceNameInUse({required String newDeviceName}) {
    bool devieNameInUse = false;
    for (int i = 0; i < singelton.getModelDeviceManagement.length; i++) {
      if (singelton.getModelDeviceManagement[i].deviceName == newDeviceName) {
        devieNameInUse = true;
        break;
      }
    }
    return devieNameInUse;
  }

  bool roomNameInUse({required String newRoomName}) {
    print('ApiNameHelper -> roomNameInUse() param_newRoomName: $newRoomName');
    bool roomNameInUse = false;
    for (int i = 0; i < singelton.getModelGroupManagement.length; i++) {
      print(
          'ApiNameHelper -> roomNameInUse() room names: ${singelton.getModelGroupManagement[i].groupName}');
      if (singelton.getModelGroupManagement[i].groupName == newRoomName) {
        roomNameInUse = true;
        print('ApiNameHelper -> roomNameInUse() break');
        break;
      }
    }
    print('ApiNameHelper -> roomNameInUse() output: $roomNameInUse');
    return roomNameInUse;
  }

  bool scheduleNameInUse({required String newScheduleName}) {
    bool scheduleNameInUse = false;
    for (int i = 0;
        i <
            singelton
                .getScheduleById(ConstScheduleId.timeScheduleProfileId)
                .length;
        i++) {
      if (singelton
              .getScheduleById(ConstScheduleId.timeScheduleProfileId)[i]
              .scheduleName ==
          newScheduleName) {
        scheduleNameInUse = true;
        break;
      }
    }
    return scheduleNameInUse;
  }

  bool holidayNameInUse({required String newProfileName}) {
    bool scheduleNameInUse = false;
    for (int i = 0;
        i <
            singelton
                .getScheduleById(ConstScheduleId.holidayProfileScheduleId)
                .length;
        i++) {
      if (singelton
              .getScheduleById(ConstScheduleId.holidayProfileScheduleId)[i]
              .scheduleName ==
          newProfileName) {
        scheduleNameInUse = true;
        break;
      }
    }
    return scheduleNameInUse;
  }
}
