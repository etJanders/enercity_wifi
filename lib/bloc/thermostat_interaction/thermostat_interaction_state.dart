part of 'thermostat_interaction_bloc.dart';

@immutable
abstract class ThermostatInteractionState {}

class ThermostatInteractionInitial extends ThermostatInteractionState {}

class MqttDeviceProfileSuccesfullSent extends ThermostatInteractionState {
  final String profileIdentifier;
  MqttDeviceProfileSuccesfullSent({required this.profileIdentifier});
}

class MqttTransmissionError extends ThermostatInteractionState {}

class DatabaseResponse extends ThermostatInteractionState {
  final UpdateDatabaseState state;
  DatabaseResponse({required this.state});
}

class GroupOrganized extends ThermostatInteractionState {}
