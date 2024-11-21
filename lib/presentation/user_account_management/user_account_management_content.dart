import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wifi_smart_living/bloc/delete_user_account/delete_user_account_bloc.dart';
import 'package:wifi_smart_living/core/logout_helper/logout_helper.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/models/ui/account_management/model_user_management.dart';
import 'package:wifi_smart_living/presentation/alert_dialogs/alert_dialog_information.dart';
import 'package:wifi_smart_living/presentation/alert_dialogs/alert_dialog_yes_no.dart';
import 'package:wifi_smart_living/presentation/chang_notification/change_notification_page.dart';
import 'package:wifi_smart_living/presentation/change_account_mail/change_account_mail.dart';
import 'package:wifi_smart_living/presentation/change_password/change_user_password.dart';
import 'package:wifi_smart_living/presentation/general_widgets/click_buttons/click_button_colored.dart';
import 'package:wifi_smart_living/presentation/general_widgets/list_items/single_list_item_without_start_image.dart';
import 'package:wifi_smart_living/presentation/general_widgets/loading_spinner/loading_circle.dart';
import 'package:wifi_smart_living/singelton/api_singelton.dart';
import 'package:wifi_smart_living/theme.dart';
import 'package:wifi_smart_living/timer/individual_timer.dart';

import '../../api_handler/api_treiber/user_management/delete_user_account_helper.dart';
import '../login/login_page.dart';

///Description
///UI for user account management
///
///Author: J. Anders
///created: 15-12-2022
///changed: 15-12-2022
///
///History:
///
///Notes:
///
class UserAccountManagementContent extends StatelessWidget {
  static const String _idEditMail = '01';
  static const String _idPasswortAendern = '02';
  static const String _idNotification = '03';

  const UserAccountManagementContent({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    LoadingCicle loadingCicle = LoadingCicle(context: context);
    IndividualTimer individualTimer = IndividualTimer();
    final List<ModelUserManagement> userManagementList = [
      ModelUserManagement(id: _idEditMail, title: local.editEmail),
      ModelUserManagement(id: _idPasswortAendern, title: local.editPassword),
      ModelUserManagement(id: _idNotification, title: local.editNotifications),
    ];
    return BlocConsumer<DeleteDatabaseEntriesBloc, DeleteDatabaseEntriesState>(
      listener: (context, state) {
        if (state is ShowLoadingSpinner) {
          if (state.showLoadingSpinner) {
            loadingCicle.showAnimation(local.deleteUserAccount);
          } else {
            loadingCicle.animationDismiss();
          }
        } else if (state is DeleteUserResponseState) {
          DeleteAccountState response = state.state;
          BuildContext parentContext = context;

          if (response == DeleteAccountState.accountDeletet) {
            LogoutHelper(logoutCallback: () {
              InformationAlert().showAlertDialog(
                  context: context,
                  message: local.deleteUserAccountSuccesful,
                  callback: () {
                    Navigator.pushNamedAndRemoveUntil(
                        parentContext, LoginPage.routName, (route) => false);
                  });
            }).logoutHandler();
          } else if (response == DeleteAccountState.networkConnectionIssue) {
            InformationAlert().showAlertDialog(
                context: context,
                message: local.noInternetConnectionAvaialable,
                callback: () {});
          } else if (response == DeleteAccountState.networkConnectionIssue) {
            InformationAlert().showAlertDialog(
                context: context, message: local.oopsError, callback: () {});
          }
        }
      },
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                // onTapDown: (data) {
                //   ///Zeige den Home an, wobei führende 0en entfernt werden
                //   individualTimer.starteSekundenTimer(5, (duration) {
                //     String home =
                //         ApiSingelton().getDatabaseUserModel.mqttUserName;
                //     InformationAlert().showAlertDialog(
                //         context: context,
                //         message: 'Home: ${home.replaceAll('0', '')}',
                //         callback: () {});
                //   });
                // },
                // onTapUp: (data) {
                //   individualTimer.stopTimer();
                // },
                child: Image.asset(
                  'assets/images/benutzerkonto.png',
                  width: Dimens.homeImagesize,
                  height: Dimens.homeImagesize,
                ),
              ),
              const SizedBox(
                height: Dimens.sizedBoxBigDefault,
              ),
              Text(
                local.email,
                style: AppTheme.textStyleDefault,
                textAlign: TextAlign.center,
              ),
              Text(
                ApiSingelton().getDatabaseUserModel.userMailAdress,
                style: AppTheme.textStyleDefault,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: Dimens.sizedBoxDefault,
              ),
              ListView.separated(
                  padding: const EdgeInsets.all(Dimens.paddingDefault),
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemBuilder: ((context, index) => SingelListItemWidget(
                      title: userManagementList[index].title,
                      itemClickedCallback: () {
                        itemSelected(context, userManagementList[index].id);
                      })),
                  separatorBuilder: ((context, index) => const Divider(
                        color: AppTheme.textDarkGrey,
                      )),
                  itemCount: userManagementList.length),
              const Spacer(),
              ClickButtonFilled(
                  buttonText: local.deleteUserAccount,
                  buttonFunktion: () {
                    AlertDialogYesNo()
                        .zeigeDialog(
                            context: context,
                            message: local.deleteUserAccountAlert,
                            positiveButtontext: local.deleteUserAccount,
                            negativeButtonText: local.cancel)
                        .then((value) {
                      if (value) {
                        BlocProvider.of<DeleteDatabaseEntriesBloc>(context).add(
                            DeleteUserAccount(
                                mailAdress: ApiSingelton()
                                    .getDatabaseUserModel
                                    .userMailAdress));
                      }
                    });
                  },
                  width: double.infinity)
            ],
          ),
        );
      },
    );
  }

  void itemSelected(BuildContext context, String itemId) {
    if (itemId == _idEditMail) {
      Navigator.of(context).pushNamed(ChangeAccountMailPage.routName);
    } else if (itemId == _idPasswortAendern) {
      Navigator.of(context).pushNamed(ChangeUserPasswordPage.routName);
    } else if (itemId == _idNotification) {
      Navigator.of(context).pushNamed(ChangeNotificationPage.routName);
    }
  }
}
