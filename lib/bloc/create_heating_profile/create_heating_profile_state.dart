part of 'create_heating_profile_bloc.dart';

@immutable
abstract class CreateHeatingProfileState {}

class CreateHeatingProfileInitial extends CreateHeatingProfileState {}

class ScheduleDataSet extends CreateHeatingProfileState {}

class CreateScheduleResponse extends CreateHeatingProfileState {
  final CreateScheduleState state;

  CreateScheduleResponse({required this.state});
}
