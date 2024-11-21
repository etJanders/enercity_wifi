import 'package:wifi_smart_living/api_handler/api_treiber/heating_profile/init_heating_profile.dart';
import 'package:wifi_smart_living/const/const_schedule_id.dart';
import 'package:wifi_smart_living/device_specification/thermostat_interface.dart';
import 'package:wifi_smart_living/models/database/model_group_management.dart';
import 'package:wifi_smart_living/models/database/model_room_profile.dart';
import 'package:wifi_smart_living/models/init_heating_profile/model_init_heating_profile.dart';

import '../../singelton/helper/api_singelton_helper.dart';

///Description
///wenn ein Raum ein Heizprofil hat, soll eine neue Struktur angelegt werden
///
///Author: J. Anders
///created: 09-01-2023
///changed: 20-01-2023
///
///History:
///200-01-2023 add holiday profiles to init routine
///Notes:
///
class InitHeatingProfileHelper {
  final ApiSingeltonHelper apiSingeltonHelper = ApiSingeltonHelper();

  bool initHeatingProfiles() {
    return

        _existHeatingProfiles();
  }

  bool initHolidayProfiles() {
    return

        _existsHolidayProfiles();
  }

  Future<void> initTimeSchedules() async {
    var apiHelper = ApiSingeltonHelper();
    final List<ModelGroupManagement> myRooms =
        apiSingeltonHelper.apiSingelton.getModelGroupManagement;//accessing data for each room
    for (int i = 0; i < myRooms.length; i++) {
      List<ModelRoomProfile> heatingProfile =
          apiSingeltonHelper.getHeatingProfile(myRooms[i].groupId);//Access all heating profiles for that room
      ModelRoomProfile holidayProfile = apiSingeltonHelper.getRoomProfile(
          groupId: myRooms[i].groupId,
          profileIdentifier: ThermostatInterface.holidayProfile);
      ///Wenn ein Heizprofil existiert, erzeuge einen separaten Eintrag für das Profil
      if (_heatingProfileExists(heatingProfile: heatingProfile) &&  !(apiHelper.roomWithScheduledProfile(scheduleId: 'T', groupid: myRooms[i].groupId))) {// checks if any value of heating profile has value other than #
        ModelInitHeatingProfile tempData = ModelInitHeatingProfile(
            groupId: myRooms[i].groupId,
            scheduleName: myRooms[i].groupName,
            scheduleImage: 'heating_profile_one_flutter.png',
            scheduleId: ConstScheduleId.timeScheduleProfileId);
        await HeatingProfileHelper().initHeatingProfile(data: tempData);
      }
      if (_existsHolidayProfile(holidayProfile: holidayProfile) && !(apiHelper.roomWithScheduledProfile(scheduleId: 'H', groupid: myRooms[i].groupId))) {
        ModelInitHeatingProfile tempData = ModelInitHeatingProfile(
            groupId: myRooms[i].groupId,
            scheduleName: myRooms[i].groupName,
            scheduleImage: 'holiday_profile_summer_flutter.png',
            scheduleId: ConstScheduleId.holidayProfileScheduleId);
        await HeatingProfileHelper().initHeatingProfile(data: tempData);
      }
    }
  }

  bool _existHeatingProfiles() {
    bool profilesExists = false;
    final List<ModelGroupManagement> myRooms =
        apiSingeltonHelper.apiSingelton.getModelGroupManagement;
    for (int i = 0; i < myRooms.length; i++) {
      if (_heatingProfileExists(
          heatingProfile:
              apiSingeltonHelper.getHeatingProfile(myRooms[i].groupId))) {
        profilesExists = true;

        break;
      }else{

      }
    }
    return profilesExists;
  }

  bool _existsHolidayProfiles() {
    bool profileExists = false;
    final List<ModelGroupManagement> myRooms =
        apiSingeltonHelper.apiSingelton.getModelGroupManagement;

    for (int i = 0; i < myRooms.length; i++) {
      if (_holidayProfile(holidayProfile:
      apiSingeltonHelper.getHolidayProfileExisting(myRooms[i].groupId))) {
        profileExists = true;

        break;
      }else{

      }
    }
    return profileExists;
  }
  
  bool _existsHolidayProfile({required ModelRoomProfile holidayProfile}) {
    bool profileExists = false;
    
    if(holidayProfile.profileValue != "#"){
      profileExists = true;
    }
    return profileExists;
  }

  bool _heatingProfileExists({required List<ModelRoomProfile> heatingProfile}) {
    bool profileExists = false;
    if (heatingProfile.isNotEmpty) {
      for (int i = 0; i < heatingProfile.length; i++) {
        if (heatingProfile[i].profileValue != '#') {
          profileExists = true;
          break;
        }
      }
    }
    return profileExists;
  }

  bool _holidayProfile({required List<ModelRoomProfile> holidayProfile}) {
    bool profileExists = false;
    if (holidayProfile.isNotEmpty) {
      for (int i = 0; i < holidayProfile.length; i++) {
        if (holidayProfile[i].profileValue != '#') {
          profileExists = true;
          break;
        }
      }
    }
    return profileExists;
  }

}
