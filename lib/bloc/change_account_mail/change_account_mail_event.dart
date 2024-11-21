part of 'change_account_mail_bloc.dart';

@immutable
abstract class ChangeAccountMailEvent {}

class ChanegAccountMail extends ChangeAccountMailEvent {
  final String newMailAdress;
  ChanegAccountMail({required this.newMailAdress});
}

class TokenEntered extends ChangeAccountMailEvent {
  final String activationToken;
  TokenEntered({required this.activationToken});
}

class SendTokenAgain extends ChangeAccountMailEvent {}
