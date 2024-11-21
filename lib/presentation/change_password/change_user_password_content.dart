import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wifi_smart_living/bloc/password_reset/password_reset_bloc.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/presentation/alert_dialogs/alert_dialog_information.dart';
import 'package:wifi_smart_living/presentation/general_widgets/click_buttons/click_button_colored.dart';
import 'package:wifi_smart_living/presentation/general_widgets/editTextWidgets/edit_password_text_widget.dart';
import 'package:wifi_smart_living/presentation/general_widgets/image_container/home_image.dart';
import 'package:wifi_smart_living/presentation/general_widgets/loading_spinner/loading_circle.dart';
import 'package:wifi_smart_living/theme.dart';
import 'package:wifi_smart_living/validation/general/change_password_validation.dart';

import '../../api_handler/api_treiber/password_reset_helper.dart';
import '../../singelton/api_singelton.dart';
import '../general_widgets/back_button_widget/back_button_widget.dart';

class ChangeUserPasswordContent extends StatelessWidget {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();
  ChangeUserPasswordContent({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    LoadingCicle loadingCicle = LoadingCicle(context: context);
    return BlocConsumer<PasswordResetBloc, PasswordResetState>(
      listener: (context, state) {
        loadingCicle.animationDismiss();
        if (state is PasswordResetResponse) {
          PasswordResetRespnseState responseState = state.respnseState;
          if (responseState == PasswordResetRespnseState.noInternetConnection) {
            InformationAlert().showAlertDialog(
                context: context,
                message: local.noInternetConnectionAvaialable,
                callback: () {});
          } else if (responseState == PasswordResetRespnseState.passwordKnown) {
            InformationAlert().showAlertDialog(
                context: context,
                message: local.newPasswordSameLikeOld,
                callback: () {});
          } else if (responseState ==
              PasswordResetRespnseState.passwordChanged) {
            InformationAlert().showAlertDialog(
                context: context,
                message: local.passwordSuccesfullChanged,
                callback: () {
                  Navigator.of(context).pop();
                });
          } else if (responseState ==
              PasswordResetRespnseState.wrongOldPassword) {
            InformationAlert().showAlertDialog(
                context: context,
                message: local.wrongOldPassword,
                callback: () {});
          } else {
            InformationAlert().showAlertDialog(
                context: context, message: local.oopsError, callback: () {});
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: const BackButtonWidget(),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(local.myUserAccount),
                Text(
                  local.editPassword,
                  style: AppTheme.textStyleDefault,
                )
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(Dimens.paddingDefault),
            child: Column(
              children: [
                const SizedBox(
                  height: Dimens.sizedBoxDefault,
                ),
                const HomeImage(),
                const SizedBox(
                  height: Dimens.sizedBoxBigDefault,
                ),
                EditPasswortTextInput(
                    passwordEditingControler: oldPasswordController,
                    hintText: local.oldpassword),
                const SizedBox(
                  height: Dimens.sizedBoxDefault,
                ),
                EditPasswortTextInput(
                    passwordEditingControler: passwordController,
                    hintText: local.password),
                const SizedBox(
                  height: Dimens.sizedBoxDefault,
                ),
                EditPasswortTextInput(
                    passwordEditingControler: confirmPasswordController,
                    hintText: local.confirmPassword),
                const Spacer(),
                ClickButtonFilled(
                    buttonText: local.save,
                    buttonFunktion: () {
                      if (passwordController.text.isNotEmpty &&
                          confirmPasswordController.text.isNotEmpty &&
                          oldPasswordController.text.isNotEmpty) {
                        PasswordValidationState state =
                            ChangePasswordValidator().validateNewPassword(
                                password: passwordController.text,
                                confirmedPassword:
                                    confirmPasswordController.text);
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
                          loadingCicle.showAnimation(local.changeUserPassword);
                          String email = ApiSingelton()
                              .getDatabaseUserModel
                              .userMailAdress;
                          BlocProvider.of<PasswordResetBloc>(context).add(
                              ChangePassword(
                                  newPassword: passwordController.text,
                                  oldPassword: oldPasswordController.text,
                                  email: email));
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
