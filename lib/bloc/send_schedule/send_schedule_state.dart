part of 'send_schedule_bloc.dart';

@immutable
abstract class SendScheduleState {}

class SendScheduleInitial extends SendScheduleState {}

class ScheduleSend extends SendScheduleState {}

class MqttConnectionError extends SendScheduleState {}

class UpdateScheduleDatabase extends SendScheduleState {
  final UpdateTimeScheduleState updateState;
  UpdateScheduleDatabase({required this.updateState});
}
