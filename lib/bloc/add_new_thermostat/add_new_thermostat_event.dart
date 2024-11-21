part of 'add_new_thermostat_bloc.dart';

@immutable
abstract class AddNewThermostatEvent {}

///Check ssid name of connected wifi network
class DetermineSsidName extends AddNewThermostatEvent {}

class IntroduceDelay extends AddNewThermostatEvent {}

///SSID and password are determined
class SsidAndPasswordSelected extends AddNewThermostatEvent {
  final String ssid;
  final String password;
  SsidAndPasswordSelected({required this.ssid, required this.password});
}

class ConfigDevice extends AddNewThermostatEvent {
  final int devicePort;
  final int mode;

  ConfigDevice({required this.devicePort, required this.mode});
}

class DeviceNameSelected extends AddNewThermostatEvent {
  final String deviceName;
  DeviceNameSelected({required this.deviceName});
}

class SetImageName extends AddNewThermostatEvent {
  final String imageName;
  SetImageName({required this.imageName});
}

class SaveNewRoomInDatabase extends AddNewThermostatEvent {
  final String roomName;
  SaveNewRoomInDatabase({required this.roomName});
}

class AddDeviceToARoom extends AddNewThermostatEvent {
  final String groupId;
  final String deviceName;
  AddDeviceToARoom({required this.groupId, required this.deviceName});
}
