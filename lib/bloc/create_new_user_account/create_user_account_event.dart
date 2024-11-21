part of 'create_user_account_bloc.dart';

@immutable
abstract class CreateUserAccountEvent {}
///Create a new user account
class CreateAccountEvent extends CreateUserAccountEvent {
  final String userMail;
  final String userPassword;

  CreateAccountEvent({required this.userMail, required this.userPassword});
}

//Activate user account
class EnterTokenEvent extends CreateUserAccountEvent {
  final String activationToken;
  EnterTokenEvent({required this.activationToken});
}

///Refresh account activation Token
class RefreshActivationToken extends CreateUserAccountEvent {}

///Enable email notification 
class EnableEmailNotification extends CreateUserAccountEvent {}
///Safe login data to secret store and go forward
class SaveDataAndNext extends CreateUserAccountEvent {}
