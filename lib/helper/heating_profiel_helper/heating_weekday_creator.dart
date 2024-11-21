import 'package:flutter/cupertino.dart';
import 'package:wifi_smart_living/device_specification/thermostat_interface.dart';
import 'package:wifi_smart_living/models/database/model_room_profile.dart';
import 'package:wifi_smart_living/models/database/model_schedule_group.dart';
import 'package:wifi_smart_living/singelton/api_singelton.dart';
import 'package:wifi_smart_living/singelton/helper/api_singelton_helper.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

///Description
///Prüfe ob ein Wochentag für ein Heizprfoil belegt ist und generiere eine Wochentag String, der in der UI angezeigt werden kann
abstract class DetermineWeekdays {
  static String weekdayOverview(
      {required BuildContext context, required String smPublicId}) {
    AppLocalizations local = AppLocalizations.of(context)!;
    List<ModelRoomProfile> profiles =
        ApiSingeltonHelper().getHeatingProfile(_getGroupId(smPublicId));
    List<String> weekday = [];
    for (int i = 0; i < profiles.length; i++) {
      ModelRoomProfile temp = profiles[i];
      if (temp.profileId == ThermostatInterface.weekdayMonday &&
          temp.profileValue != '#') {
        weekday.add(local.mondayShort);
      } else if (temp.profileId == ThermostatInterface.weekdayTuesday &&
          temp.profileValue != '#') {
        weekday.add(local.tuesdayShort);
      } else if (temp.profileId == ThermostatInterface.weekdayWednesday &&
          temp.profileValue != '#') {
        weekday.add(local.wednesdayShort);
      } else if (temp.profileId == ThermostatInterface.weekdayThursday &&
          temp.profileValue != '#') {
        weekday.add(local.thursdayShort);
      } else if (temp.profileId == ThermostatInterface.weekdayFriday &&
          temp.profileValue != '#') {
        weekday.add(local.fridayShort);
      } else if (temp.profileId == ThermostatInterface.weekdaySaturday &&
          temp.profileValue != '#') {
        weekday.add(local.saturdayShort);
      } else if (temp.profileId == ThermostatInterface.weekdaySunday &&
          temp.profileValue != '#') {
        weekday.add(local.sundayShort);
      }
    }
    String output = "";
    if (weekday.isEmpty) {
      output = local.noDayOfWeek;
    } else if (weekday.length == 7) {
      output = local.everyDay;
    } else {
      output = _buildString(weekday);
    }
    return output;
  }

  //Determine a groupId
  static String _getGroupId(String smPublicId) {
    String groupId = "";
    if (smPublicId.isNotEmpty) {
      List<ModelScheduleGroup> scheduleGroups = ApiSingelton().getScheduleGroup;
      for (int i = 0; i < scheduleGroups.length; i++) {
        if (scheduleGroups[i].scheduleManagerPublicId == smPublicId) {
          groupId = scheduleGroups[i].groupId;
          break;
        }
      }
    }
    return groupId;
  }

  static String _buildString(List<String> weekday) {
    String output = "";
    for (int i = 0; i < weekday.length; i++) {
      output = "$output ${weekday[i]}";
    }
    return output;
  }
}
