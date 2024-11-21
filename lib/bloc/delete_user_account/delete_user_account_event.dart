part of 'delete_user_account_bloc.dart';

@immutable
abstract class DeleteUserAccountEvent {}

class DeleteUserAccountInitialEvent extends DeleteUserAccountEvent {}

class DeleteUserAccount extends DeleteUserAccountEvent {
  final String mailAdress;
  DeleteUserAccount({required this.mailAdress});
}

class DeleteRoomFromDatabase extends DeleteUserAccountEvent {
  final String groupId;
  DeleteRoomFromDatabase({required this.groupId});
}

class DeleteDeviceFromDatabase extends DeleteUserAccountEvent {
  final String macAdress;
  DeleteDeviceFromDatabase({required this.macAdress});
}

class DeleteScheduleFromDatabase extends DeleteUserAccountEvent {
  final ModelScheduleManager smPublicId;

  DeleteScheduleFromDatabase({required this.smPublicId});
}

class DeleteSingelRoomFromSchedule extends DeleteUserAccountEvent {
  final ModelScheduleGroup scheduleGroup;
  DeleteSingelRoomFromSchedule({required this.scheduleGroup});
}

class DeleteSingelRoomFromHolidaySchedule  extends DeleteUserAccountEvent {
  final ModelScheduleGroup scheduleGroup;

  DeleteSingelRoomFromHolidaySchedule({required this.scheduleGroup});
}

  class DeleteHolidayScheduleFromDatabase extends DeleteUserAccountEvent {
  final ModelScheduleManager smPublicId;

  DeleteHolidayScheduleFromDatabase({required this.smPublicId});
  }



