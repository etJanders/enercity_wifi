import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wifi_smart_living/bloc/mail_activation/mail_activation_bloc.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/presentation/general_widgets/image_container/home_image.dart';
import 'package:wifi_smart_living/presentation/general_widgets/loading_spinner/loading_circle.dart';

import '../../theme.dart';
import '../alert_dialogs/alert_dialog_information.dart';
import '../general_widgets/click_buttons/click_button_colored.dart';
import '../general_widgets/editTextWidgets/edit_token_text_widget.dart';
import '../general_widgets/textWidgets/clickebal_text_widget.dart';

class MailActivationContent extends StatelessWidget {
  final Function nextCallback;
  final TextEditingController tokenEditingControler = TextEditingController();
  final tokenController = TextEditingController();
  late LoadingCicle loadingCicle;
  MailActivationContent({super.key, required this.nextCallback});

  @override
  Widget build(BuildContext context) {
    LoadingCicle loadingCicle = LoadingCicle(context: context);
    AppLocalizations local = AppLocalizations.of(context)!;

    return BlocConsumer<MailActivationBloc, MailActivationState>(
      listener: (context, state) {
        print("$state");
        if (state is TokenRefreshed) {
        } else if (state is AccountActivatedSuccessfully) {
          loadingCicle.animationDismiss();
          InformationAlert().showAlertDialog(
              context: context,
              message: local.useraccountSuccessfulActivated,
              callback: () {
                nextCallback();
              });
        } else if (state is WrongActivationCodeError) {
          loadingCicle.animationDismiss();
          InformationAlert().showAlertDialog(
              context: context,
              message: local.activationTokenNotCorrect,
              callback: () {});
        } else if (state is TokenFistSentSuccessful) {
          {
            // InformationAlert().showAlertDialog(
            //     context: context, message: "Activation code sent", callback: () {});
          }
        } else if (state is AccountActivationError) {
          loadingCicle.animationDismiss();
          InformationAlert().showAlertDialog(
              context: context, message: local.oopsError, callback: () {});
        } else if (state is TokenResent) {
          InformationAlert().showAlertDialog(
              context: context,
              message: local.activationTokenRefreshed,
              callback: () {});
        } else if (state is TokenResendFailed) {
          InformationAlert().showAlertDialog(
              context: context, message: local.oopsError, callback: () {});
        } else if (state is AccountActivationError) {
          InformationAlert().showAlertDialog(
              context: context, message: local.oopsError, callback: () {});
        }
      },
      builder: (context, state) {
        AppLocalizations local = AppLocalizations.of(context)!;
        loadingCicle = LoadingCicle(context: context);

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Dimens.paddingDefault),
            child: Column(
              children: [
                const HomeImage(),
                const SizedBox(
                  height: Dimens.sizedBoxBigDefault,
                ),
                Text(
                  local.activationInstructions,
                  style: AppTheme.textStyleDefault,
                ),
                const SizedBox(
                  height: Dimens.sizedBoxBigDefault,
                ),
                TokenInputField(
                    labelText: local.activationCode,
                    tokenControler: tokenController),
                const SizedBox(
                  height: Dimens.sizedBoxBigDefault,
                ),
                Text(
                  local.tokenInfoMessage,
                  style: AppTheme.textStyleDefault,
                ),
                const SizedBox(
                  height: Dimens.sizedBoxBigDefault,
                ),
                ClickedText(
                    text: local.getNewActivationToken,
                    textColor: AppTheme.violet,
                    onClick: () {
                      // loadingCicle
                      //     .showAnimation(local.createNewActivationToken);
                      BlocProvider.of<MailActivationBloc>(context)
                          .add(RefreshingActivationToken());
                    }),
                //const Spacer(),
                ClickButtonFilled(
                    buttonText: local.activateUserAccount,
                    buttonFunktion: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      if (tokenController.text.length == 6) {
                        loadingCicle.showAnimation(
                            local.userAccountActivationInProgress);
                        BlocProvider.of<MailActivationBloc>(context).add(
                            EnteringTokenEvent(
                                activationToken: tokenController.text));
                      } else {
                        InformationAlert().showAlertDialog(
                            context: context,
                            message: local.tokenInfoMessage,
                            callback: () {});
                      }
                    },
                    width: double.infinity),
              ],
            ),
          ),
        );
      },
    );
  }
}
