///Description
///Define all supported profile types of Comet Aqua
///
///Author: J. Anders
///created: 07-12-2022
///changed: 07-12-2022
///
///History:
///
///Nodes:
///
class AquaInterface {
  final List<String> _profileIdentifierList = [];

  static const String deviceTypeAquaStandalone = '0021';
  static const String deviceTypeAquaWithFlowmeter = '0021';

  static const String aquaControl = 'A0';
  static const String aquaFlow = 'A1';
  static const String aquaTempMonitoring = 'A2';
  static const String flags = 'A3';
  static const String rtc = 'A4';
  static const String measuredTemperature = 'A5';
  static const String battery = 'A6';
  static const String weekdayMonday = 'A8';
  static const String weekdayTuesday = 'A9';
  static const String weekdayWednesday = 'AA';
  static const String weekdayThursday = 'AB';
  static const String weekdayFriday = 'AC';
  static const String weekdaySaturday = 'AD';
  static const String weekdaySunday = 'AE';
  static const String getOrDeviceType = 'AF';

  static const String baseSoftwareVersion = 'B1';
  static const String radioSoftwareVersion = 'B2';
  static const String rssi = 'B3';
  static const String getEEprom = 'B4';
  static const String rtcOffset = 'BC';

  AquaInterface() {
    _profileIdentifierList.add(aquaControl);
    _profileIdentifierList.add(aquaFlow);
    _profileIdentifierList.add(aquaTempMonitoring);
    _profileIdentifierList.add(flags);
    _profileIdentifierList.add(rtc);
    _profileIdentifierList.add(measuredTemperature);
    _profileIdentifierList.add(battery);
    _profileIdentifierList.add(weekdayMonday);
    _profileIdentifierList.add(weekdayTuesday);
    _profileIdentifierList.add(weekdayWednesday);
    _profileIdentifierList.add(weekdayThursday);
    _profileIdentifierList.add(weekdayFriday);
    _profileIdentifierList.add(weekdaySaturday);
    _profileIdentifierList.add(weekdaySunday);
    _profileIdentifierList.add(getOrDeviceType);

    _profileIdentifierList.add(baseSoftwareVersion);
    _profileIdentifierList.add(radioSoftwareVersion);
    _profileIdentifierList.add(rssi);
    _profileIdentifierList.add(getEEprom);
    _profileIdentifierList.add(rtcOffset);
  }

  bool profileSupportedFromDevice(
      {required String deviceType, required String profileValue}) {
    return (AquaInterface.deviceTypeAquaStandalone == deviceType ||
            AquaInterface.deviceTypeAquaWithFlowmeter == deviceType) &&
        _profileIdentifierList.contains(profileValue);
  }
}
