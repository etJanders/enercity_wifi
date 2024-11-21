import 'package:flutter/material.dart';
import 'package:wifi_smart_living/converter/holiday_profile_builder.dart';
import 'package:wifi_smart_living/models/database/model_schedule_manager.dart';
import 'package:wifi_smart_living/singelton/helper/api_singelton_helper.dart';
import 'package:wifi_smart_living/thermostat_attributes/holiday_profile.dart';

class HolidayProfileProvider with ChangeNotifier {
  bool _profileDataChanged = false;
  late HolidayProfile _holidayProfile;
  late ModelScheduleManager _scheduleManager;

  void initProvider({required ModelScheduleManager manager}) {
    _profileDataChanged = false;
    _scheduleManager = manager;
    _holidayProfile = BuildHolidayProfile.buildHolidayProfile(
        holidayProfileString: ApiSingeltonHelper()
            .getHolidayProfile(smPublicId: manager.entryPublicId));
  }

  void setNewDate(bool startDate, DateTime dateTime) {
    _holidayProfile.setNewDate(startDate, dateTime);
    _profileDataChanged = true;
    notifyListeners();
  }

  void setNewTime(bool startDate, TimeOfDay timeOfDay) {
    _holidayProfile.setNewTime(startDate, timeOfDay);
    _profileDataChanged = true;
    notifyListeners();
  }

  void changeTemperature(int newTemperature) {
    _holidayProfile.setNewTemperature(newTemperature);
    _profileDataChanged = true;
    notifyListeners();
  }

  bool get getDataChanged => _profileDataChanged;
  HolidayProfile get getHolidayProfile => _holidayProfile;
  ModelScheduleManager get getSchedulemanager => _scheduleManager;


}
