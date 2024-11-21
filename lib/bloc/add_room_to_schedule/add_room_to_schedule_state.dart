part of 'add_room_to_schedule_bloc.dart';

@immutable
abstract class AddRoomToScheduleState {}

class AddRoomToScheduleInitial extends AddRoomToScheduleState {}

class AddRoomToScheduleResponse extends AddRoomToScheduleState {
  final AddRoomsToScheduleHelperState state;
  AddRoomToScheduleResponse({required this.state});
}
