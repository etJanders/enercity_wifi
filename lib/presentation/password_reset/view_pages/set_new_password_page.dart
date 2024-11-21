import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/presentation/general_widgets/click_buttons/click_button_colored.dart';
import 'package:wifi_smart_living/presentation/general_widgets/editTextWidgets/edit_password_text_widget.dart';
import 'package:wifi_smart_living/presentation/general_widgets/image_container/home_image.dart';
import 'package:wifi_smart_living/validation/general/change_password_validation.dart';

import '../../../api_handler/api_treiber/password_reset_helper.dart';
import '../../../bloc/password_reset/password_reset_bloc.dart';
import '../../../theme.dart';
import '../../alert_dialogs/alert_dialog_information.dart';
import '../../general_widgets/back_button_widget/back_button_widget.dart';

class SetNewPasswordPage extends StatelessWidget {
  final enteredPasswordControler = TextEditingController();
  final confirmPasswordControler = TextEditingController();
  final Function nextStepCallback;

  SetNewPasswordPage({super.key, required this.nextStepCallback});

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    return BlocConsumer<PasswordResetBloc, PasswordResetState>(
      listener: (context, state) {
        if (state is PasswordResetResponse) {
          PasswordResetRespnseState responseState = state.respnseState;
          if (responseState == PasswordResetRespnseState.passwordChanged) {
            InformationAlert().showAlertDialog(
                context: context,
                message: local.passwordChange,
                callback: () {
                  nextStepCallback();
                });
          } else if (responseState == PasswordResetRespnseState.passwordKnown) {
            InformationAlert().showAlertDialog(
                context: context,
                message: local.sameAsOldPassword,
                callback: () {});
          } else {
            InformationAlert().showAlertDialog(
                context: context, message: local.oopsError, callback: () {});
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
                  local.enterNewPassword,
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
                EditPasswortTextInput(
                    passwordEditingControler: enteredPasswordControler,
                    hintText: local.password),
                const SizedBox(
                  height: Dimens.sizedBoxDefault,
                ),
                EditPasswortTextInput(
                    passwordEditingControler: confirmPasswordControler,
                    hintText: local.confirmPassword),
                const Spacer(),
                ClickButtonFilled(
                    buttonText: local.save,
                    buttonFunktion: () {
                      if (enteredPasswordControler.text.isNotEmpty &&
                          confirmPasswordControler.text.isNotEmpty) {
                        PasswordValidationState state =
                            ChangePasswordValidator().validateNewPassword(
                                password: enteredPasswordControler.text,
                                confirmedPassword:
                                    confirmPasswordControler.text);
                        if (state == PasswordValidationState.passwordNotSame) {
                          InformationAlert().showAlertDialog(
                              context: context,
                              message: local.passwordNotSame,
                              callback: () {});
                        } else if (state ==
                            PasswordValidationState.wrongFormat) {
                          InformationAlert().showAlertDialog(
                              context: context,
                              message: local.passwordWrongFormat,
                              callback: () {});
                        } else {
                          BlocProvider.of<PasswordResetBloc>(context).add(
                              ChangePasswordReset(
                                  newPassword: enteredPasswordControler.text));
                        }
                      } else {
                        InformationAlert().showAlertDialog(
                            context: context,
                            message: local.emailOrPasswordNotEntered,
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
