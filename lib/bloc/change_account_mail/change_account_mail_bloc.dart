import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wifi_smart_living/api_handler/api_treiber/change_mail_adress/change_mail_adress_helper.dart';

part 'change_account_mail_event.dart';
part 'change_account_mail_state.dart';

class ChangeAccountMailBloc
    extends Bloc<ChangeAccountMailEvent, ChangeAccountMailState> {
  ChangeUserMailHelper helper = ChangeUserMailHelper();

  ChangeAccountMailBloc() : super(ChangeAccountMailInitial()) {
    on<ChanegAccountMail>((event, emit) async {
      ChangeUserMailState state =
          await helper.setNewMailAdress(newMail: event.newMailAdress);
      emit(ChangeMailAdressState(state: state));
    });

    on<TokenEntered>((event, emit) async {
      ChangeUserMailState state = await helper.activateNewMailAdress(
          activationToken: event.activationToken);

      emit(ChangeMailAdressState(state: state));
    });

    on<SendTokenAgain>((event, emit) async {
      ChangeUserMailState state = await helper.sendTokenAgain();
      emit(ChangeMailAdressState(state: state));
    });
  }
}
