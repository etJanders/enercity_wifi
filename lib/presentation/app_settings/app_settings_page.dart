// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wifi_smart_living/presentation/app_settings/settings_item_builder.dart';
import 'package:wifi_smart_living/presentation/help/help_page.dart';
import 'package:wifi_smart_living/presentation/legal_nodes/legal_nodes_page.dart';
import 'package:wifi_smart_living/presentation/user_account_management/user_account_management_page.dart';

import '../../api_handler/api_treiber/sync/sync_database_entries.dart';
import '../../core/logout_helper/logout_helper.dart';
import '../../theme.dart';
import '../alert_dialogs/alert_dialog_credentials_changed.dart';
import '../alert_dialogs/alert_dialog_yes_no.dart';
import '../general_widgets/list_items/list_item_with_start_image.dart';
import '../general_widgets/loading_spinner/loading_circle.dart';
import '../login/login_page.dart';

///Description
///Show the main Menu Options for the app
///
///Author: J. Anders
///created: 08-12-2022
///changed: 08-12-2022
///
///History:
///
///Notes:
///
class AppSettingsPage extends StatelessWidget {
  late LoadingCicle loadingCicle;
  AppSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    loadingCicle = LoadingCicle(context: context);
    AppLocalizations local = AppLocalizations.of(context)!;
    SettingsItemBuilder itemIdentifier = SettingsItemBuilder(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          local.settings,
          style: const TextStyle(
            color: AppTheme.violet,
          ),
        ),
      ),
      body: context.watch<DatabaseSync>().getDatabaseSyncState ==
              DatabaseSyncState.credentialsWrong
          ? Center(
              child: AlertDialogCredentialsChanged()
                  .showAlertDialogWidget(context, () {
                Navigator.of(context).popAndPushNamed(LoginPage.routName);
              }),
            )
          : Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  ListView.separated(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) =>
                          ListItemStartImage(
                              onClick: () {
                                callActivity(
                                    context,
                                    itemIdentifier
                                        .generateSettingsItems()[index]
                                        .itemIdentifier);
                              },
                              title: itemIdentifier
                                  .generateSettingsItems()[index]
                                  .title,
                              assetName: itemIdentifier
                                  .generateSettingsItems()[index]
                                  .imageAssatName),
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(
                            color: AppTheme.textLightGrey,
                          ),
                      itemCount: itemIdentifier.generateSettingsItems().length),
                  const Spacer(),
                  Text(
                    local.version,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textLightGrey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    local.copyright,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textLightGrey,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void callActivity(BuildContext context, SettingItemIdentifier items) async {
    AppLocalizations local = AppLocalizations.of(context)!;
    if (SettingItemIdentifier.myUserAccount == items) {
      Navigator.of(context).pushNamed(UserAccountManagementPage.routName);
    } else if (SettingItemIdentifier.help == items) {
      Navigator.of(context).pushNamed(HelpPage.routName);
    } else if (SettingItemIdentifier.lawInformation == items) {
      Navigator.of(context).pushNamed(LegalNotesPage.routname);
    } else if (SettingItemIdentifier.logout == items) {
      AlertDialogYesNo()
          .zeigeDialog(
              context: context,
              message: local.logoutConfirmationMessage,
              positiveButtontext: local.logout,
              negativeButtonText: local.cancel)
          .then((value) {
        if (value) {
          loadingCicle.showAnimation(local.abmelden);
          LogoutHelper(logoutCallback: () {
            loadingCicle.animationDismiss();
            Navigator.pushNamedAndRemoveUntil(
                context, LoginPage.routName, (route) => false);
          }).logoutHandler();
        }
      });
    }
  }
}
