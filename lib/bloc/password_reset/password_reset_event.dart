part of 'password_reset_bloc.dart';

@immutable
abstract class PasswordResetEvent {}

class CheckuserAccountActivationState extends PasswordResetEvent {
  final String mailAdress;
  CheckuserAccountActivationState({required this.mailAdress});
}

class RequestResetToken extends PasswordResetEvent {
  final String mailAdress;
  RequestResetToken({required this.mailAdress});
}

///Change the user account password
class ChangePasswordReset extends PasswordResetEvent {
  final String newPassword;
  ChangePasswordReset({required this.newPassword});
}

class ChangePassword extends PasswordResetEvent {
  final String newPassword;
  final String oldPassword;
  final String email;
  ChangePassword({required this.newPassword,required this.oldPassword,required this.email});
}

class RefreshResetToken extends PasswordResetEvent {}

class ResetTokenEntered extends PasswordResetEvent {
  final String resetToken;
  ResetTokenEntered({required this.resetToken});
}
