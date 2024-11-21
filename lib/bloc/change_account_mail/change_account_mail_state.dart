part of 'change_account_mail_bloc.dart';

@immutable
abstract class ChangeAccountMailState {}

class ChangeAccountMailInitial extends ChangeAccountMailState {}

class ChangeMailAdressState extends ChangeAccountMailState {
  final ChangeUserMailState state;
  ChangeMailAdressState({required this.state});
}
