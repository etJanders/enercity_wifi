import 'package:flutter/material.dart';
import 'package:wifi_smart_living/converter/hex_bin_converter.dart';
import 'package:wifi_smart_living/core/stringSplitter/string_splitter_builder.dart';
import 'package:wifi_smart_living/thermostat_attributes/holiday_profile.dart';
import 'package:wifi_smart_living/validation/general/data_length_validator.dart';

///Description
///Build a holiday profile object from database String
///
///Author: J. Anders
///created: 20-01-2023
///changed: 20-01-2023
///
///History:
///
///Notes:
abstract class BuildHolidayProfile {
  static const _indexStartHour = 0;
  static const _indexStartTag = 1;
  static const _indexStartMonat = 2;
  static const _indexStartJahr = 3;
  static const _indexEndStunde = 4;
  static const _indexEndTag = 5;
  static const _indexEndMonat = 6;
  static const _indexEndJahr = 7;
  static const _indexTemperatur = 8;

  static HolidayProfile buildHolidayProfile(
      {required String holidayProfileString}) {
    HolidayProfile holidayProfile;
    if (holidayProfileString.length < 18 || holidayProfileString == '#') {
      holidayProfile = HolidayProfile(
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 1)),
          startTime:  TimeOfDay(hour: DateTime.now().hour, minute: 0),
          endTime:  TimeOfDay(hour: DateTime.now().hour, minute: 0),
          temperature: 32);
    } else {
      List<int> parsed = SplitStringHelper.splitStringAfterCharactersInt(
          dataString: holidayProfileString,
          splitPosition: DataLengh.dataLengthTwo);
      holidayProfile = HolidayProfile(
          startDate: _dateBuild(true, parsed),
          endDate: _dateBuild(false, parsed),
          startTime: _timeBuild(true, parsed),
          endTime: _timeBuild(false, parsed),
          temperature: parsed[_indexTemperatur]);
    }
    return holidayProfile;
  }

  static DateTime _dateBuild(bool startTime, List<int> date) {
    DateTime dateTime;
    if (startTime) {
      if (date[_indexStartJahr] > 2000) {
        dateTime = DateTime(date[_indexStartJahr], date[_indexStartMonat],
            date[_indexStartTag]);
      } else {
        dateTime = DateTime((date[_indexStartJahr] + 2000),
            date[_indexStartMonat], date[_indexStartTag]);
      }
    } else {
      if (date[_indexEndJahr] > 2000) {
        dateTime = DateTime(
            date[_indexEndJahr], date[_indexEndMonat], date[_indexEndTag]);
      } else {
        dateTime = DateTime((date[_indexEndJahr] + 2000), date[_indexEndMonat],
            date[_indexEndTag]);
      }
    }
    return dateTime;
  }

  static TimeOfDay _timeBuild(bool startTime, List<int> date) {
    TimeOfDay timeOfDay;
    if (startTime) {
      timeOfDay = TimeOfDay(hour: date[_indexStartHour], minute: 0);
    } else {
      timeOfDay = TimeOfDay(hour: date[_indexEndStunde], minute: 0);
    }
    return timeOfDay;
  }

  static String buildHolidayDataString(HolidayProfile holidayProfile) {
    return HexBinConverter.convertIntToHex(
            DataLengh.dataLengthTwo, holidayProfile.startTime.hour) +
        HexBinConverter.convertIntToHex(
            DataLengh.dataLengthTwo, holidayProfile.startDate.day) +
        HexBinConverter.convertIntToHex(
            DataLengh.dataLengthTwo, holidayProfile.startDate.month) +
        HexBinConverter.convertIntToHex(
            DataLengh.dataLengthTwo, (holidayProfile.startDate.year - 2000)) +
        HexBinConverter.convertIntToHex(
            DataLengh.dataLengthTwo, holidayProfile.endTime.hour) +
        HexBinConverter.convertIntToHex(
            DataLengh.dataLengthTwo, holidayProfile.endDate.day) +
        HexBinConverter.convertIntToHex(
            DataLengh.dataLengthTwo, holidayProfile.endDate.month) +
        HexBinConverter.convertIntToHex(
            DataLengh.dataLengthTwo, (holidayProfile.endDate.year - 2000)) +
        HexBinConverter.convertIntToHex(
            DataLengh.dataLengthTwo, holidayProfile.temperature);
  }
}
