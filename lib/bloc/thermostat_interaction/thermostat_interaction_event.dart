part of 'thermostat_interaction_bloc.dart';

@immutable
abstract class ThermostatInteractionEvent {}

class MqttInitCallback extends ThermostatInteractionEvent {
  final MqttCallback callback;
  MqttInitCallback({required this.callback});
}

class SendMqttData extends ThermostatInteractionEvent {
  final String macAdresses;
  final String profileIdentifier;
  final String profileValue;

  SendMqttData(
      {required this.macAdresses,
      required this.profileIdentifier,
      required this.profileValue});
}

class SendMqttToDeviceList extends ThermostatInteractionEvent {
  final List<ModelDeviceManagament> macAdresses;
  final String profileIdentifier;
  final String profileValue;

  SendMqttToDeviceList(
      {required this.macAdresses,
      required this.profileIdentifier,
      required this.profileValue});
}

class UpdateDeviceProfileEntrie extends ThermostatInteractionEvent {
  final ModelDeviceProfile deviceProfile;
  UpdateDeviceProfileEntrie({required this.deviceProfile});
}

class UpdateRoomProfileEntrie extends ThermostatInteractionEvent {
  final ModelRoomProfile roomProfile;
  UpdateRoomProfileEntrie({required this.roomProfile});
}

class GroupOrganizer extends ThermostatInteractionEvent {
  final String groupId;
  GroupOrganizer({required this.groupId});
}
