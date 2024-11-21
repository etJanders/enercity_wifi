import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/presentation/alert_dialogs/alert_dialog_information.dart';
import 'package:wifi_smart_living/presentation/general_widgets/checkBoxen/default_check_box.dart';
import 'package:wifi_smart_living/presentation/general_widgets/click_buttons/click_button_colored.dart';
import 'package:wifi_smart_living/presentation/general_widgets/loading_spinner/loading_circle.dart';
import 'package:wifi_smart_living/presentation/home_page/indoor/homepage_indoor_page.dart';
import 'package:wifi_smart_living/theme.dart';

import '../../api_handler/api_treiber/update_ui_components/update_ui_components_helper.dart';
import '../../bloc/change_notification/change_notification_bloc.dart';
import '../../singelton/api_singelton.dart';
import '../alert_dialogs/alert_ok.dart';

class DisplayNotificationContent extends StatefulWidget {
  const DisplayNotificationContent({super.key});

  @override
  State<DisplayNotificationContent> createState() =>
      _DisplayNotificationContentState();
}

class _DisplayNotificationContentState
    extends State<DisplayNotificationContent> {
  final ApiSingelton apiSingelton = ApiSingelton();
  bool changed = true;
  @override
  void initState() {
    super.initState();
    changeNotification(true);
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    LoadingCicle loadingCicle = LoadingCicle(context: context);
    return BlocConsumer<ChangeNotificationBloc, ChangeNotificationState>(
      listener: (context, state) {
        print(state);
        loadingCicle.animationDismiss();
        if (state is NotificationChanged) {
          UpdateUIComponentState response = state.stateChanged;
          if (response == UpdateUIComponentState.entrySuccesfulChanged) {
            if (ApiSingelton().getDatabaseUserModel.notification) {
              AlertDialogYes()
                  .zeigeDialog(
                context: context,
                message: local.emailNotification,
                positiveButtontext: local.okay,
              )
                  .then((value) {
                if (value) {
                  Navigator.of(context)
                      .popAndPushNamed(HomepageIndoorPage.routName);
                }
              });
            } else {
              AlertDialogYes()
                  .zeigeDialog(
                context: context,
                message: local.noEmailNotification,
                positiveButtontext: local.okay,
              )
                  .then((value) {
                if (value) {
                  Navigator.of(context)
                      .popAndPushNamed(HomepageIndoorPage.routName);
                }
              });
            }
          } else {
            InformationAlert().showAlertDialog(
                context: context, message: local.oopsError, callback: () {});
          }
        } else {
          Navigator.of(context).popAndPushNamed(HomepageIndoorPage.routName);
        }
      },
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(Dimens.paddingDefault),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  local.notificationInfoMessageWiFi,
                  style: AppTheme.textStyleDefault,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: Dimens.sizedBoxBigDefault,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          local.lowBatteryPoint,
                          style: AppTheme.textStyleDefault,
                        ),
                        Text(
                          local.temperatureWarningPoint,
                          style: AppTheme.textStyleDefault,
                        ),
                        Text(
                          local.adaptionErrorPoint,
                          style: AppTheme.textStyleDefault,
                        ),
                      ]),
                ),
                const SizedBox(
                  height: Dimens.sizedBoxBigDefault,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      local.receiveMailNotification,
                      style: AppTheme.textStyleDefault,
                    ),
                    CustomeCheckBox(
                        initState: true,
                        callback: (value) {
                          print(value);
                          changed = true;
                          changeNotification(value);
                        })
                  ],
                ),
                const Spacer(),
                ClickButtonFilled(
                    buttonText: local.saveAndProceed,
                    buttonFunktion: () {
                      loadingCicle.showAnimation(local.updatingStatus);
                      BlocProvider.of<ChangeNotificationBloc>(context).add(
                          ChangeMailNotification(
                              notificationState: apiSingelton
                                  .getDatabaseUserModel.notification));
                    },
                    width: double.infinity)
              ],
            ),
          ),
        );
      },
    );
  }

  void changeNotification(bool state) {
    setState(() {
      apiSingelton.getDatabaseUserModel.notification = state;
    });
  }
}
