///Description
///Define all supported profile types of Comet WiFi thermostat
///
///Author: J. Anders
///created: 07-12-2022
///changed: 07-12-2022
///
///History:
///
///Nodes:
class ThermostatInterface {
  final List<String> _profileIdentifierList = [];

  static const String deviceType = '0012';

  static const String targetTemperature = 'A0';
  static const String measuredTemperature = 'A1';
  static const String offset = 'A2';
  static const String flags = 'A3';
  static const String rtc = 'A4';
  static const String windowOpenDetection = 'A5';
  static const String battery = 'A6';
  static const String holidayProfile = 'A7';
  static const String weekdayMonday = 'A8';
  static const String weekdayTuesday = 'A9';
  static const String weekdayWednesday = 'AA';
  static const String weekdayThursday = 'AB';
  static const String weekdayFriday = 'AC';
  static const String weekdaySaturday = 'AD';
  static const String weekdaySunday = 'AE';
  static const String getOrDeviceType = 'AF';

  static const String groupMac = 'B0';
  static const String baseSoftwareVersion = 'B1';
  static const String radioSoftwareVersion = 'B2';
  static const String rssi = 'B3';
  static const String eepromGet = 'B4';
  static const String tmax = 'B5';
  static const String siledTargetTemperatureOrDivers = 'B6';
  static const String rtcOffset = 'BC';
  static const String holidayProfileActiveIndicator = 'BD';

  ThermostatInterface() {
    _profileIdentifierList.add(targetTemperature);
    _profileIdentifierList.add(measuredTemperature);
    _profileIdentifierList.add(offset);
    _profileIdentifierList.add(flags);
    _profileIdentifierList.add(rtc);
    _profileIdentifierList.add(windowOpenDetection);
    _profileIdentifierList.add(battery);
    _profileIdentifierList.add(holidayProfile);
    _profileIdentifierList.add(weekdayMonday);
    _profileIdentifierList.add(weekdayTuesday);
    _profileIdentifierList.add(weekdayWednesday);
    _profileIdentifierList.add(weekdayThursday);
    _profileIdentifierList.add(weekdayFriday);
    _profileIdentifierList.add(weekdaySaturday);
    _profileIdentifierList.add(weekdaySunday);
    _profileIdentifierList.add(getOrDeviceType);
    _profileIdentifierList.add(groupMac);
    _profileIdentifierList.add(baseSoftwareVersion);
    _profileIdentifierList.add(radioSoftwareVersion);
    _profileIdentifierList.add(rssi);
    _profileIdentifierList.add(eepromGet);
    _profileIdentifierList.add(tmax);
    _profileIdentifierList.add(siledTargetTemperatureOrDivers);
    _profileIdentifierList.add(rtcOffset);
  }

  bool profileSupportedFromDevice(
      {required String deviceType, required String profileValue}) {
    return ThermostatInterface.deviceType == deviceType &&
        _profileIdentifierList.contains(profileValue);
  }
}
