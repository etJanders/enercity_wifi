part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class StartLoginEvent extends LoginEvent {
  final String email;
  final String password;
  final bool stayLoggedIn;

  StartLoginEvent(
      {required this.email,
      required this.password,
      required this.stayLoggedIn});
}

class DetermineSelfEvent extends LoginEvent {
  final ModelAccessToken token;
  final String password;
  DetermineSelfEvent({required this.token, required this.password});
}
