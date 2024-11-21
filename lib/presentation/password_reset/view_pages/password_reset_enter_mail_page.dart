import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wifi_smart_living/api_handler/api_treiber/password_reset_helper.dart';
import 'package:wifi_smart_living/bloc/password_reset/password_reset_bloc.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/presentation/alert_dialogs/alert_dialog_double_message.dart';
import 'package:wifi_smart_living/presentation/general_widgets/click_buttons/click_button_colored.dart';
import 'package:wifi_smart_living/presentation/general_widgets/editTextWidgets/edit_mail_text_widget.dart';
import 'package:wifi_smart_living/presentation/general_widgets/image_container/home_image.dart';
import 'package:wifi_smart_living/presentation/general_widgets/loading_spinner/loading_circle.dart';
import 'package:wifi_smart_living/validation/general/email_validation.dart';

import '../../../api_handler/api_treiber/activation_state/activation_state_helper.dart';
import '../../../theme.dart';
import '../../alert_dialogs/alert_dialog_information.dart';
import '../../general_widgets/back_button_widget/back_button_widget.dart';

class PasswordResetMailPage extends StatelessWidget {
  final emailTextControler = TextEditingController();
  final Function nextStepCallback;

  PasswordResetMailPage({super.key, required this.nextStepCallback});

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    LoadingCicle loadingCicle = LoadingCicle(context: context);
    return BlocListener<PasswordResetBloc, PasswordResetState>(
      listener: (context, state) {
        if (state is UserAccountActivationResponse) {
          UserAccountActivationState respone = state.responseState;
          if (respone == UserAccountActivationState.accountActivated) {
            BlocProvider.of<PasswordResetBloc>(context)
                .add(RequestResetToken(mailAdress: emailTextControler.text));
          } else if (respone ==
              UserAccountActivationState.accountNotActivated) {
            loadingCicle.animationDismiss();
            InformationAlert().showAlertDialog(
                context: context,
                message: local.userAccountNotActivated,
                callback: () {
                  Navigator.of(context).pop();
                });
          } else if (respone ==
              UserAccountActivationState.noInternetConnection) {
            loadingCicle.animationDismiss();
            InformationAlert().showAlertDialog(
                context: context,
                message: local.noInternetConnectionAvaialable,
                callback: () {
                  Navigator.of(context).pop();
                });
          } else if (respone == UserAccountActivationState.userDoseNotExists) {
            loadingCicle.animationDismiss();
            InformationAlert().showAlertDialog(
                context: context,
                message: local.userAccountNotFound,
                callback: () {});
          } else {
            loadingCicle.animationDismiss();
            InformationAlert().showAlertDialog(
                context: context,
                message: local.oopsError,
                callback: () {
                  Navigator.of(context).pop();
                });
          }
        } else if (state is PasswordResetResponse) {
          loadingCicle.animationDismiss();
          PasswordResetRespnseState resetRespnseState = state.respnseState;
          if (resetRespnseState ==
              PasswordResetRespnseState.noInternetConnection) {
            InformationAlert().showAlertDialog(
                context: context,
                message: local.noInternetConnectionAvaialable,
                callback: () {});
          } else if (resetRespnseState ==
              PasswordResetRespnseState.resetTokenSent) {
            InformationAlertDoubleMessage().showAlertDialog(
                context: context,
                message: local.sendResetPin,
                subMessage: local.spamHint,
                callback: () {
                  nextStepCallback();
                });
          } else {
            InformationAlert().showAlertDialog(
                context: context,
                message: local.oopsError,
                callback: () {
                  Navigator.of(context).pop();
                });
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: const BackButtonWidget(),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(local.resetPassword),
              Text(
                local.enterMail,
                style: AppTheme.textStyleColored,
              )
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(Dimens.paddingDefault),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  //    child: Expanded(
                  child: Column(
                    children: [
                      const HomeImage(),
                      const SizedBox(
                        height: Dimens.sizedBoxBigDefault,
                      ),
                      Text(
                        local.sendResetTokenEins,
                        style: AppTheme.textStyleDefault,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: Dimens.sizedBoxDefault,
                      ),
                      Text(
                        local.sendResetTokenZwei,
                        style: AppTheme.textStyleDefault,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: Dimens.sizedBoxBigDefault,
                      ),
                      Text(
                        local.sendEmailTo,
                        style: AppTheme.textStyleDefault,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      EditEmailTextInput(
                          emailController: emailTextControler,
                          hintText: local.email),
                    ],
                  ),
                  //  ),
                ),
              ),
              const SizedBox(
                height: Dimens.sizedBoxDefault,
              ),
              ClickButtonFilled(
                  buttonText: local.getNewPassword,
                  buttonFunktion: () {
                    FocusScope.of(context).unfocus();
                    if (emailTextControler.text.isEmpty) {
                      InformationAlert().showAlertDialog(
                          context: context,
                          message: local.enterAccountMail,
                          callback: () {});
                    } else if (!EmailValidator.emailValide(
                        emailTextControler.text)) {
                      InformationAlert().showAlertDialog(
                          context: context,
                          message: local.mailNotCorrect,
                          callback: () {});
                    } else {
                      loadingCicle.showAnimation(local.requestRestetPin);
                      BlocProvider.of<PasswordResetBloc>(context).add(
                          CheckuserAccountActivationState(
                              mailAdress: emailTextControler.text));
                    }
                  },
                  width: double.infinity),
            ],
          ),
        ),
      ),
    );
  }
}
