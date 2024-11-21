part of 'change_notification_bloc.dart';

@immutable
abstract class ChangeNotificationState {}

class ChangeNotificationInitial extends ChangeNotificationState {}

class NotificationChanged extends ChangeNotificationState {
  final UpdateUIComponentState stateChanged;
  NotificationChanged({required this.stateChanged});
}
class NavigateToHomePage extends ChangeNotificationState {
  NavigateToHomePage();
}