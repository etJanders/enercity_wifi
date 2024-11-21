part of 'mail_activation_bloc.dart';

@immutable
abstract class MailActivationState {}

class MailActivationInitial extends MailActivationState {}

class InitFinished extends MailActivationState {}

class AccountActivationError extends MailActivationState {
  final CreateAccountState state;

  AccountActivationError({required this.state});
}

class TokenRefreshed extends MailActivationState {}

class TokenFistSentSuccessful extends MailActivationState {}

class TokenResent extends MailActivationState {}

class TokenResendFailed extends MailActivationState {}

class UserAccountActivated extends MailActivationState {}

class WrongActivationCodeError extends MailActivationState {
  final CreateAccountState state;

  WrongActivationCodeError({required this.state});
}

class EmailNotificationActivated extends MailActivationState {}

class AccountActivatedSuccessfully extends MailActivationState {}

class CallIntroductionScreen extends MailActivationState { }
