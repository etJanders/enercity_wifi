// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wifi_smart_living/bloc/create_new_user_account/create_user_account_bloc.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/presentation/alert_dialogs/alert_dialog_information.dart';
import 'package:wifi_smart_living/presentation/general_widgets/click_buttons/click_button_colored.dart';
import 'package:wifi_smart_living/presentation/general_widgets/editTextWidgets/edit_token_text_widget.dart';
import 'package:wifi_smart_living/presentation/general_widgets/image_container/home_image.dart';
import 'package:wifi_smart_living/presentation/general_widgets/textWidgets/clickebal_text_widget.dart';
import 'package:wifi_smart_living/theme.dart';

import '../../../api_handler/api_treiber/create_user_account/create_user_account_helper.dart';
import '../../general_widgets/back_button_widget/back_button_widget.dart';
import '../../general_widgets/loading_spinner/loading_circle.dart';

class CreateAccountEnterTokenPage extends StatelessWidget {
  final tokenController = TextEditingController();
  final Function callbackFunction;
  late LoadingCicle loadingCicle;

  CreateAccountEnterTokenPage({super.key, required this.callbackFunction});

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    loadingCicle = LoadingCicle(context: context);
    return BlocConsumer<CreateUserAccountBloc, CreateUserAccountState>(
      listener: (context, state) {
        loadingCicle.animationDismiss();
        if (state is AccountActivated) {
          InformationAlert().showAlertDialog(
              context: context,
              message: local.useraccountSuccessfulActivated,
              callback: () {
                callbackFunction();
              });
        } else if (state is RefreshTokenSent) {
          InformationAlert().showAlertDialog(
              context: context,
              message: local.activationTokenRefreshed,
              callback: () {});
        } else if (state is AccountCreatedError) {
          CreateAccountState errorState = state.state;
          if (errorState == CreateAccountState.wrongToken) {
            InformationAlert().showAlertDialog(
                context: context,
                message: local.activationTokenNotCorrect,
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
                Text(
                  local.createAccount,
                ),
                Text(
                  local.activateUserAccount,
                  style: AppTheme.textStyleDefault,
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
                  width: Dimens.sizedBoxBigDefault,
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
                      loadingCicle
                          .showAnimation(local.createNewActivationToken);
                      BlocProvider.of<CreateUserAccountBloc>(context)
                          .add(RefreshActivationToken());
                    }),
                // const Spacer(),
                ClickButtonFilled(
                    buttonText: local.activateUserAccount,
                    buttonFunktion: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      if (tokenController.text.length == 6) {
                        loadingCicle.showAnimation(
                            local.userAccountActivationInProgress);
                        BlocProvider.of<CreateUserAccountBloc>(context).add(
                            EnterTokenEvent(
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
