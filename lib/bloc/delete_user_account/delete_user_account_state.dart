part of 'delete_user_account_bloc.dart';

@immutable
abstract class DeleteDatabaseEntriesState {}

class DeleteUserAccountInitial extends DeleteDatabaseEntriesState {}

class ShowLoadingSpinner extends DeleteDatabaseEntriesState {
  final bool showLoadingSpinner;
  ShowLoadingSpinner({required this.showLoadingSpinner});
}

class DeleteUserResponseState extends DeleteDatabaseEntriesState {
  final DeleteAccountState state;
  DeleteUserResponseState({required this.state});
}

class DeleteRoomFromDatabaseState extends DeleteDatabaseEntriesState {
  final DeleteEntryState state;
  DeleteRoomFromDatabaseState({required this.state});
}

class DeleteDeviceFromDatabaseState extends DeleteDatabaseEntriesState {
  final DeleteEntryState state;
  DeleteDeviceFromDatabaseState({required this.state});
}

class DeleteScheduleFromDatabaseState extends DeleteDatabaseEntriesState {
  final DeleteEntryState state;
  DeleteScheduleFromDatabaseState({required this.state});
}
