part of 'create_user_account_bloc.dart';

@immutable
abstract class CreateUserAccountState {}

class CreateUserAccountInitial extends CreateUserAccountState {}

class AccountCreated extends CreateUserAccountState {}

class AccountActivated extends CreateUserAccountState {}

class EmailNotificationActivated extends CreateUserAccountState {}

class AccountCreatedError extends CreateUserAccountState {
  final CreateAccountState state;
  AccountCreatedError({required this.state});
}

class RefreshTokenSent extends CreateUserAccountState {}

class CallIntroductionScreen extends CreateUserAccountState {}

class DataStored extends CreateUserAccountState {}
