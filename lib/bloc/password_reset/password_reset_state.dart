part of 'password_reset_bloc.dart';

@immutable
abstract class PasswordResetState {}

class PasswordResetInitial extends PasswordResetState {}

class UserAccountActivationResponse extends PasswordResetState {
  final UserAccountActivationState responseState;
  UserAccountActivationResponse({required this.responseState});
}

class PasswordResetResponse extends PasswordResetState {
  final PasswordResetRespnseState respnseState;

  PasswordResetResponse({required this.respnseState});
}

class PasswordRefreshTokenRequested extends PasswordResetState {
  final PasswordResetRespnseState respnseState;
  PasswordRefreshTokenRequested({required this.respnseState});
}

class ResetTokenValidated extends PasswordResetState {
  ResetTokenValidated();
}
