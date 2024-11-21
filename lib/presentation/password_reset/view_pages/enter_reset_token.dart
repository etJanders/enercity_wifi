import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wifi_smart_living/bloc/password_reset/password_reset_bloc.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/presentation/alert_dialogs/alert_dialog_information.dart';
import 'package:wifi_smart_living/presentation/general_widgets/click_buttons/click_button_colored.dart';
import 'package:wifi_smart_living/presentation/general_widgets/editTextWidgets/edit_token_text_widget.dart';
import 'package:wifi_smart_living/presentation/general_widgets/image_container/home_image.dart';
import 'package:wifi_smart_living/presentation/general_widgets/loading_spinner/loading_circle.dart';
import 'package:wifi_smart_living/presentation/general_widgets/textWidgets/clickebal_text_widget.dart';
import 'package:wifi_smart_living/validation/general/token_validation.dart';

import '../../../api_handler/api_treiber/password_reset_helper.dart';
import '../../../theme.dart';
import '../../alert_dialogs/alert_dialog_double_message.dart';
import '../../general_widgets/back_button_widget/back_button_widget.dart';

class PasswordResetTokenPage extends StatelessWidget {
  final tokenTextControler = TextEditingController();
  final Function nextStepCallback;

  PasswordResetTokenPage({super.key, required this.nextStepCallback});

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    LoadingCicle loadingCicle = LoadingCicle(context: context);
    return BlocConsumer<PasswordResetBloc, PasswordResetState>(
      listener: (context, state) {
        loadingCicle.animationDismiss();
        if (state is PasswordRefreshTokenRequested) {
          PasswordResetRespnseState requestState = state.respnseState;
          if (requestState == PasswordResetRespnseState.resetTokenSent) {
            InformationAlertDoubleMessage().showAlertDialog(
                context: context,
                message: local.sendResetPin,
                subMessage: local.spamHint,
                callback: () {});
          } else {
            InformationAlert().showAlertDialog(
                context: context, message: local.oopsError, callback: () {});
          }
        } else if (state is ResetTokenValidated) {
          nextStepCallback();
        } else if (state is PasswordResetResponse) {
          PasswordResetRespnseState respnseState = state.respnseState;
          if (respnseState == PasswordResetRespnseState.tokenAccepted) {
            nextStepCallback();
          } else {
            InformationAlert().showAlertDialog(
                context: context,
                message: local.resetTokenWrong,
                callback: () {});
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            leading: const BackButtonWidget(),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(local.resetPassword),
                Text(
                  local.verificationCode,
                  style: AppTheme.textStyleColored,
                )
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(Dimens.paddingDefault),
            child: Column(
              children: [
                const HomeImage(),
                const SizedBox(
                  height: Dimens.sizedBoxBigDefault,
                ),
                TokenInputField(
                    labelText: local.tokenHint,
                    tokenControler: tokenTextControler),
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
                ClickedText(
                    text: local.getNewToken,
                    textColor: AppTheme.violet,
                    onClick: () {
                      loadingCicle.showAnimation(local.resetTokenRequested);
                      BlocProvider.of<PasswordResetBloc>(context)
                          .add(RefreshResetToken());
                    }),
                const Spacer(),
                ClickButtonFilled(
                    buttonText: local.next,
                    buttonFunktion: () {
                      FocusScope.of(context).unfocus();
                      if (tokenTextControler.text.isEmpty) {
                        InformationAlert().showAlertDialog(
                            context: context,
                            message: local.tokenInfoMessage,
                            callback: () {});
                      } else if (!TokenValidation().validateToken(
                          enteredToken: tokenTextControler.text)) {
                        InformationAlert().showAlertDialog(
                            context: context,
                            message: local.activationTokenNotCorrect,
                            callback: () {});
                      } else {
                        loadingCicle.showAnimation(local.resetTokenVerified);
                        BlocProvider.of<PasswordResetBloc>(context).add(
                            ResetTokenEntered(
                                resetToken: tokenTextControler.text));
                      }
                    },
                    width: double.infinity)
              ],
            ),
          ),
        );
      },
    );
  }
}
