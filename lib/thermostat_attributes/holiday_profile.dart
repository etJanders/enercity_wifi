import 'package:flutter/material.dart';

import '../core/uiHelper/build_time_string.dart';

///Description
///Model to handle the holiday profile
///
///Author: J. Anders
///creared: 30-11-2022
///changed: 30-11-2022
///
///History:
///
///Notes:
///
class HolidayProfile {
  DateTime startDate;
  DateTime endDate;
  TimeOfDay startTime;
  TimeOfDay endTime;
  int temperature;

  HolidayProfile(
      {required this.startDate,
      required this.endDate,
      required this.startTime,
      required this.endTime,
      required this.temperature});

  void setNewDate(bool start, DateTime newDateTime) {
    if (start) {
      startDate = newDateTime;
    } else {
      endDate = newDateTime;
    }
  }

  void setNewTime(bool start, TimeOfDay timeOfDay) {
    print("Time of the day $timeOfDay");
    if (start) {
      startTime = timeOfDay;
    } else {
      endTime = timeOfDay;
    }
  }

  void setNewTemperature(int temperature) {
    this.temperature = temperature;
  }

  String getStartDate() {
    return "${startDate.day}.${startDate.month}.${(startDate.year)}";
  }

  String getEndDate() {
    return "${endDate.day}.${endDate.month}.${(endDate.year)}";
  }

  String getStartTime() {
    // return "${startTime.hour}:00";
    print("Start jour ${startTime.hour}");
    if (startTime.hour < 25) {
      return "${startTime.hour}:00";
    } else {
      return "00:00";
    }
  }

  String getStartTimeWithFormat(BuildContext context) {
    return BuildTimeString.getDisplayTimeWithFormat(context,
        hour: startTime.hour, minute: startTime.minute);
  }

  String getEndTime() {
    //   return "${endTime.hour}:00";
    if (startTime.hour < 25) {
      return "${endTime.hour}:00";
    } else {
      return "00:00";
    }
  }

  String getEndTimeWithFormat(BuildContext context) {
    return BuildTimeString.getDisplayTimeWithFormat(context,
        hour: endTime.hour, minute: endTime.minute);
  }

  String getTemperature() {
    if (temperature != 0x80) {
      if (temperature == 15) {
        return 'off';
      } else if (temperature == 57) {
        return 'on';
      } else {
        return "${temperature / 2}°C";
      }
    }
    return "${temperature / 2}°C";
  }
}
