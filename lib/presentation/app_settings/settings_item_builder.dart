import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/ui/app_settings/model_app_settings.dart';

class SettingsItemBuilder {
  late final AppLocalizations local;

  SettingsItemBuilder(BuildContext context) {
    local = AppLocalizations.of(context)!;
  }

  List<ModelSettingsPage> generateSettingsItems() {
    List<ModelSettingsPage> menuList = [
      ModelSettingsPage(
          title: local.myUserAccount,
          imageAssatName: "benutzer_verwaltung.png",
          itemIdentifier: SettingItemIdentifier.myUserAccount),
      ModelSettingsPage(
          title: local.help,
          imageAssatName: "hilfe_und_feedback.png",
          itemIdentifier: SettingItemIdentifier.help),
      ModelSettingsPage(
          title: local.legalNodes,
          imageAssatName: "paragraph.png",
          itemIdentifier: SettingItemIdentifier.lawInformation),
      ModelSettingsPage(
          title: local.logout,
          imageAssatName: "logout.png",
          itemIdentifier: SettingItemIdentifier.logout),
    ];
    return menuList;
  }
}

enum SettingItemIdentifier {
  myUserAccount,
  help,
  lawInformation,
  share,
  logout
}
