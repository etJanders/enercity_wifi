part of 'send_schedule_bloc.dart';

@immutable
abstract class SendScheduleEvent {}

class SendNewSchedule extends SendScheduleEvent {
  final String smPublicId;
  final Map<String, String> scheduleMap;
  SendNewSchedule({required this.smPublicId, required this.scheduleMap});
}

class SendNewHolidayProfiel extends SendScheduleEvent {
  final String smPublicId;
  final HolidayProfile holidayProfile;

  SendNewHolidayProfiel(
      {required this.smPublicId, required this.holidayProfile});
}
