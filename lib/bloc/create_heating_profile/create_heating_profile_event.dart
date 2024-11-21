part of 'create_heating_profile_bloc.dart';

@immutable
abstract class CreateHeatingProfileEvent {}

class ScheduleImageSelected extends CreateHeatingProfileEvent {
  final String imageName;

  ScheduleImageSelected({required this.imageName});
}

class ScheduleNameSelected extends CreateHeatingProfileEvent {
  final String scheduleName;
  ScheduleNameSelected({required this.scheduleName});
}

class AddScheduleRooms extends CreateHeatingProfileEvent {
  final List<String> groupids;
  AddScheduleRooms({required this.groupids});
}
