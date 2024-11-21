part of 'add_room_to_schedule_bloc.dart';

@immutable
abstract class AddRoomToScheduleEvent {}

class AddRoomsToSchedule extends AddRoomToScheduleEvent {
  final List<String> groupIds;
  final String smPublicId;
  final String type;

  final Map<String, String> scheduleMap;

  AddRoomsToSchedule(
      {required this.groupIds,
      required this.smPublicId,
        required this.type,
      required this.scheduleMap});
}
  class AddRoomsToHolidaySchedule extends AddRoomToScheduleEvent {

    final List<String> groupIds;
    final String smPublicId;
    final String type;

    final HolidayProfile holidayProfile;

    AddRoomsToHolidaySchedule(
        {required this.groupIds,
          required this.smPublicId,
          required this.type,
          required this.holidayProfile});
  }