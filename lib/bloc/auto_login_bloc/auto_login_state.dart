part of 'auto_login_bloc.dart';

@immutable
abstract class AutoLoginBlocState {}

class AutoLoginInProgressState extends AutoLoginBlocState {}

class AutoLoginSuccessState extends AutoLoginBlocState {}

class GetSelfeCalledState extends AutoLoginBlocState {}

class AutoLoginSuccessErrorState extends AutoLoginBlocState {}
class NetworkErrorState extends AutoLoginBlocState {}
class PopUpStateSuccess extends AutoLoginBlocState {}
class PopUpStateFalse extends AutoLoginBlocState {}
class TimeOutErrorState extends AutoLoginBlocState {}
class PopUpManualStateSuccess extends AutoLoginBlocState {}
class PopUpManualStateFalse extends AutoLoginBlocState {}

