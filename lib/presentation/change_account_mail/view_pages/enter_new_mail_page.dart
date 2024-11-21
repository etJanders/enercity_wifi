import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wifi_smart_living/api_handler/api_treiber/change_mail_adress/change_mail_adress_helper.dart';
import 'package:wifi_smart_living/bloc/change_account_mail/change_account_mail_bloc.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/presentation/alert_dialogs/alert_dialog_double_message.dart';
import 'package:wifi_smart_living/presentation/general_widgets/click_buttons/click_button_colored.dart';
import 'package:wifi_smart_living/presentation/general_widgets/editTextWidgets/edit_mail_text_widget.dart';
import 'package:wifi_smart_living/presentation/general_widgets/image_container/home_image.dart';
import 'package:wifi_smart_living/theme.dart';
import 'package:wifi_smart_living/validation/general/change_email_validation.dart';

import '../../alert_dialogs/alert_dialog_information.dart';

class EnterNewMailPage extends StatelessWidget {
  final TextEditingController mailEditingControler = TextEditingController();
  final TextEditingController confirmMailEditingControler =
      TextEditingController();

  final Function changeUiCallback;

  EnterNewMailPage({super.key, required this.changeUiCallback});

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    return BlocConsumer<ChangeAccountMailBloc, ChangeAccountMailState>(
      listener: (context, state) {
        if (state is ChangeMailAdressState) {
          ChangeUserMailState response = state.state;
          if (response == ChangeUserMailState.databaseIssue) {
            //Todo was soll angezeigt werden
          } else if (response == ChangeUserMailState.mailAlreadyExists) {
            InformationAlert().showAlertDialog(
                context: context,
                message: local.mailAlreadyExists,
                callback: () {});
          } else if (response == ChangeUserMailState.noInternetConnection) {
            InformationAlert().showAlertDialog(
                context: context,
                message: local.noInternetConnectionAvaialable,
                callback: () {});
          } else if (response == ChangeUserMailState.tokenSendToNewMail) {
            InformationAlertDoubleMessage().showAlertDialog(
              context: context,
              message: local.tokenToNewEmail,
              subMessage: local.spamHint,
              callback: () {
                changeUiCallback();
              },
            );
          } else {
            InformationAlert().showAlertDialog(
                context: context, message: local.oopsError, callback: () {});
          }
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(Dimens.paddingDefault),
          child: Column(
            children: [
              const HomeImage(),
              const SizedBox(
                height: Dimens.sizedBoxBigDefault,
              ),
              Text(
                local.enterNewMailAdress,
                style: AppTheme.textStyleDefault,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: Dimens.sizedBoxDefault,
              ),
              EditEmailTextInput(
                  emailController: mailEditingControler, hintText: local.email),
              const SizedBox(
                height: Dimens.sizedBoxDefault,
              ),
              EditEmailTextInput(
                  emailController: confirmMailEditingControler,
                  hintText: local.confirmEmail),
              const Spacer(),
              ClickButtonFilled(
                  buttonText: local.next,
                  buttonFunktion: () {
                    MailValidationState state =
                        ChangeMailValidation.validateMail(
                            mail: mailEditingControler.text,
                            confirmMail: confirmMailEditingControler.text);
                    if (state == MailValidationState.mailWrongFormat) {
                      InformationAlert().showAlertDialog(
                          context: context,
                          message: local.wrongEmailFormat,
                          callback: () {});
                    } else if (state == MailValidationState.mailsNotSame) {
                      InformationAlert().showAlertDialog(
                          context: context,
                          message: local.enteredMailNotSame,
                          callback: () {});
                    } else if (state == MailValidationState.noEmailEnterd) {
                      InformationAlert().showAlertDialog(
                          context: context,
                          message: local.noMailEntered,
                          callback: () {});
                    } else {
                      BlocProvider.of<ChangeAccountMailBloc>(context).add(
                          ChanegAccountMail(
                              newMailAdress: mailEditingControler.text));
                    }
                  },
                  width: double.infinity),
              const SizedBox(height: 10)
            ],
          ),
        );
      },
    );
  }
}
