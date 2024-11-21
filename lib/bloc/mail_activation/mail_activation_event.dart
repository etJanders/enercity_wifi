part of 'mail_activation_bloc.dart';

@immutable
abstract class MailActivationEvent {}

class InitBlocEvent extends MailActivationEvent {
  final ModelUserData modelUserData;
  InitBlocEvent({required this.modelUserData});
}

class ResetActivationToken extends MailActivationEvent {}

class InitialActivationToken extends MailActivationEvent {}

class ActivateUserAccount extends MailActivationEvent {
  final String activationToken;
  ActivateUserAccount({required this.activationToken});
}

class EnteringTokenEvent extends MailActivationEvent {
  final String activationToken;
  EnteringTokenEvent({required this.activationToken});
}

class RefreshingActivationToken extends MailActivationEvent {}

class EnableEmailNotification extends MailActivationEvent {}

class SaveDataAndNext extends MailActivationEvent {}
