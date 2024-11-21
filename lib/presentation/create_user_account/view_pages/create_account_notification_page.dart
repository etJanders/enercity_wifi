import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wifi_smart_living/bloc/create_new_user_account/create_user_account_bloc.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/presentation/alert_dialogs/alert_dialog_information.dart';
import 'package:wifi_smart_living/presentation/general_widgets/checkBoxen/default_check_box.dart';
import 'package:wifi_smart_living/presentation/general_widgets/click_buttons/click_button_colored.dart';
import 'package:wifi_smart_living/presentation/general_widgets/image_container/home_image.dart';
import 'package:wifi_smart_living/presentation/home_page/indoor/homepage_indoor_page.dart';
import 'package:wifi_smart_living/theme.dart';

import '../../general_widgets/back_button_widget/back_button_widget.dart';
import '../../general_widgets/loading_spinner/loading_circle.dart';

class NotificationInformationPage extends StatefulWidget {
  final Function callbackFunction;
  const NotificationInformationPage(
      {super.key, required this.callbackFunction});

  @override
  State<NotificationInformationPage> createState() =>
      _NotificationInformationPageState();
}

class _NotificationInformationPageState
    extends State<NotificationInformationPage> {
  bool emailNotificationState = true;

  @override
  Widget build(BuildContext context) {
    LoadingCicle loadingCircle = LoadingCicle(context: context);
    AppLocalizations local = AppLocalizations.of(context)!;
    return BlocConsumer<CreateUserAccountBloc, CreateUserAccountState>(
      listener: (context, state) {
        if (state is EmailNotificationActivated) {
          BlocProvider.of<CreateUserAccountBloc>(context)
              .add(SaveDataAndNext());
        } else if (state is CallIntroductionScreen) {
          loadingCircle.animationDismiss();
          Navigator.pushNamedAndRemoveUntil(
              context, HomepageIndoorPage.routName, (route) => false);
        } else {
          loadingCircle.animationDismiss();
          InformationAlert().showAlertDialog(
              context: context,
              message: local.oopsError,
              callback: () {
                widget.callbackFunction();
              });
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
              leading: const BackButtonWidget(),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(local.createAccount),
                  Text(
                    local.notifications,
                    style: AppTheme.textStyleDefault,
                  ),
                ],
              )),
          body: Padding(
            padding: const EdgeInsets.all(Dimens.paddingDefault),
            child: Column(
              children: [
                const HomeImage(),
                const SizedBox(
                  height: Dimens.sizedBoxBigDefault,
                ),
                Text(local.notificationInformationMessage,
                    textAlign: TextAlign.center,
                    style: AppTheme.textStyleDefault),
                const SizedBox(
                  height: Dimens.sizedBoxDefault,
                ),
                Text(
                  local.disableNotificationHint,
                  textAlign: TextAlign.center,
                  style: AppTheme.textStyleDefault,
                ),
                const SizedBox(
                  height: Dimens.sizedBoxBigDefault,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        local.enableDisableNotification,
                        style: AppTheme.textStyleDefault,
                      ),
                      CustomeCheckBox(
                          initState: emailNotificationState,
                          callback: (state) {
                            setState(() {
                              emailNotificationState = state;
                            });
                          }),
                    ]),
                const Spacer(),
                ClickButtonFilled(
                    buttonText: local.save,
                    buttonFunktion: () {
                      loadingCircle.showAnimation(local.saveUserDetails);
                      if (emailNotificationState) {
                        BlocProvider.of<CreateUserAccountBloc>(context)
                            .add(EnableEmailNotification());
                      } else {
                        BlocProvider.of<CreateUserAccountBloc>(context)
                            .add(SaveDataAndNext());
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
