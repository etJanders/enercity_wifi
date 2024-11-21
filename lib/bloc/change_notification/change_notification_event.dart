part of 'change_notification_bloc.dart';

@immutable
abstract class ChangeNotificationEvent {}

class ChangeMailNotification extends ChangeNotificationEvent {
  final bool notificationState;
  ChangeMailNotification({required this.notificationState});

}

class SaveDataAndGoToHomePage extends ChangeNotificationEvent {

}
