part of 'auto_login_bloc.dart';

@immutable
abstract class AutoLoginBlocEvent {}

class AutoLoginInitEvent extends AutoLoginBlocEvent {}

class AutoLogin extends AutoLoginBlocEvent {}

class DetermineSelfDataFromDatabase extends AutoLoginBlocEvent {}

class DeterminePopUpStatusForAutoLogin extends AutoLoginBlocEvent {}

class DeterminePopUpStatusForManualLogin extends AutoLoginBlocEvent {}
