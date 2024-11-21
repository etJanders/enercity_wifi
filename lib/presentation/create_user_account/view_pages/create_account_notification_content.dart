import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wifi_smart_living/presentation/general_widgets/loading_spinner/loading_circle.dart';

import '../../../bloc/mail_activation/mail_activation_bloc.dart';
import '../../../dimens.dart';
import '../../../theme.dart';
import '../../alert_dialogs/alert_dialog_information.dart';
import '../../general_widgets/checkBoxen/default_check_box.dart';
import '../../general_widgets/click_buttons/click_button_colored.dart';
import '../../general_widgets/image_container/home_image.dart';
import '../../home_page/indoor/homepage_indoor_page.dart';

class CreateAccountNotificationContent extends StatefulWidget {
  const CreateAccountNotificationContent(
      {super.key, required this.callbackFunction});

  final Function callbackFunction;

  @override
  State<CreateAccountNotificationContent> createState() =>
      _CreateAccountNotificationContentState();
}

class _CreateAccountNotificationContentState
    extends State<CreateAccountNotificationContent> {
  bool emailNotificationState = true;
  @override
  Widget build(BuildContext context) {
    LoadingCicle loadingCircle = LoadingCicle(context: context);
    AppLocalizations local = AppLocalizations.of(context)!;

    return BlocConsumer<MailActivationBloc, MailActivationState>(
      listener: (context, state) {

        if (state is EmailNotificationActivated) {
          BlocProvider.of<MailActivationBloc>(context)
                    .add(SaveDataAndNext());

        } else if (state is CallIntroductionScreen) {
          loadingCircle.animationDismiss();
          Navigator.of(context).pushNamed(HomepageIndoorPage.routName);
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
        return Padding(
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
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
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
                      BlocProvider.of<MailActivationBloc>(context)
                          .add(EnableEmailNotification());
                    } else {
                      BlocProvider.of<MailActivationBloc>(context)
                          .add(SaveDataAndNext());
                    }
                  },
                  width: double.infinity),
            ],
          ),
        );
      },
    );
  }
}
