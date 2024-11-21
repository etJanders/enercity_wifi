///Description
///Constants are used to ask devices for informtion
///
///Author: J. Anders
///created: 05-01-2023
///changed: 05-01-2023
///
///History:
///
///Notes:
///
abstract class ConstMqttCommands {
  static const String resetDevices = '0000100000';

  static const String getDeviceType = '48000000';

  static const String deleteHeatingProfile = '0000200000';
  static const String deleteHolidayProfile = 'FFFFFFFFFFFFFFFFFF';

}
