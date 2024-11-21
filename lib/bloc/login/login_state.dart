part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginResponse extends LoginState {
  final LoginHelperState loginState;
  LoginResponse({required this.loginState});
}

class GetSelfResponseState extends LoginState {
  final GetSelfState getSelfResponse;
  GetSelfResponseState({required this.getSelfResponse});
}
