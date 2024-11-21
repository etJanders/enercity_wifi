part of 'add_new_thermostat_bloc.dart';

@immutable
abstract class AddNewThermostatState {}

class AddNewThermostatInitial extends AddNewThermostatState {}

class DeterminedSsid extends AddNewThermostatState {
  final String ssid;
  DeterminedSsid({required this.ssid});
}

class DetectSsidError extends AddNewThermostatState {
  final ConnectivityStates errorState;
  DetectSsidError({required this.errorState});
}

class SapConfigState extends AddNewThermostatState {
  final SapState state;
  SapConfigState({required this.state});
}

class DeviceNameAdded extends AddNewThermostatState {}

class ImageNameAdded extends AddNewThermostatState {}

class SaveRoomInDatabaseResponse extends AddNewThermostatState {
  final CreateRoomState createRoomState;
  SaveRoomInDatabaseResponse({required this.createRoomState});
}

//State which is called to go forward
class NextState extends AddNewThermostatState {}

class DelayState extends AddNewThermostatState {}

class DelayFinished extends AddNewThermostatState {}

//State seperaort could not be fecthed
class SeparatorFetchStatus extends AddNewThermostatState {}

class SeparatorFetchStatusFail extends AddNewThermostatState {}
