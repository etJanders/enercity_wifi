import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wifi_smart_living/presentation/general_widgets/click_buttons/click_button_colored.dart';
import 'package:wifi_smart_living/presentation/general_widgets/editTextWidgets/edit_token_text_widget.dart';
import 'package:wifi_smart_living/presentation/general_widgets/textWidgets/clickebal_text_widget.dart';
import 'package:wifi_smart_living/theme.dart';
import 'package:wifi_smart_living/validation/general/token_validation.dart';

import '../../../api_handler/api_treiber/change_mail_adress/change_mail_adress_helper.dart';
import '../../../bloc/change_account_mail/change_account_mail_bloc.dart';
import '../../../dimens.dart';
import '../../alert_dialogs/alert_dialog_double_message.dart';
import '../../alert_dialogs/alert_dialog_information.dart';
import '../../general_widgets/image_container/home_image.dart';

///Description
///Enter a Activation Token for Mail Changing
///
///Author: J. Anders
///created: 05-01-2023
///changed: 05-01-2023
///
///History:
///
///Notes:
///
class EnterChangeMailTokenPage extends StatelessWidget {
  final TextEditingController changeMailToken = TextEditingController();
  final Function changeUiCallback;
  EnterChangeMailTokenPage({super.key, required this.changeUiCallback});

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    return BlocConsumer<ChangeAccountMailBloc, ChangeAccountMailState>(
      listener: (context, state) {
        if (state is ChangeMailAdressState) {
          ChangeUserMailState response = state.state;
          if (response == ChangeUserMailState.newMailActivated) {
            InformationAlert().showAlertDialog(
                context: context,
                message: local.emailSuccesfullChanged,
                callback: () {
                  changeUiCallback();
                });
          } else if (response == ChangeUserMailState.activationTokenResent) {
            InformationAlertDoubleMessage().showAlertDialog(
              context: context,
              message: local.tokenToNewEmail,
              subMessage: local.spamHint,
              callback: () {},
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
                local.tokenInfoMessage,
                style: AppTheme.textStyleDefault,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: Dimens.sizedBoxBigDefault,
              ),
              TokenInputField(
                  labelText: local.tokenHint, tokenControler: changeMailToken),
              const SizedBox(
                height: Dimens.sizedBoxBigDefault,
              ),
              ClickedText(
                  text: local.getNewActivationToken,
                  textColor: AppTheme.violet,
                  onClick: () {
                    BlocProvider.of<ChangeAccountMailBloc>(context)
                        .add(SendTokenAgain());
                  }),
              const Spacer(),
              ClickButtonFilled(
                  buttonText: local.save,
                  buttonFunktion: () {
                    if (changeMailToken.text.isEmpty ||
                        !TokenValidation().validateToken(
                            enteredToken: changeMailToken.text)) {
                      InformationAlert().showAlertDialog(
                          context: context,
                          message: local.tokenInfoMessage,
                          callback: () {});
                    } else {
                      BlocProvider.of<ChangeAccountMailBloc>(context).add(
                          TokenEntered(activationToken: changeMailToken.text));
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
