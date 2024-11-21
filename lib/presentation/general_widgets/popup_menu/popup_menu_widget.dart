// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/theme.dart';

///Description
///Generate a popup menu to edit or delete ui elements
///
///Author: J. Anders
///created: 03-02-2023
///changed: 03-02-2023
///
///History:
///
///Notes:
///
class PopupMenuWidget extends StatelessWidget {
  late List<PopupMenuEntry> menuList;
  final Widget icon;
  final Function callback;

  PopupMenuWidget({super.key, required this.icon, required this.callback});

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    menuList = [
      PopupMenuItem(
        padding: const EdgeInsets.only(left: 10, right: 10),
        value: PopupMenuOption.editOption,
        child: ListTile(
          trailing: const Icon(
            Icons.edit,
            color: AppTheme.textDarkGrey,
          ),
          title: Text(local.bearbeiten),
        ),
      ),
      const PopupMenuDivider(),
      PopupMenuItem(
        padding: const EdgeInsets.only(left: 10, right: 10),
        value: PopupMenuOption.deleteOption,
        child: ListTile(
          trailing: const ImageIcon(AssetImage("assets/images/delete_icon.png"),
              color: AppTheme.textDarkGrey),
          title: Text(local.delete),
        ),
      ),
    ];

    return PopupMenuButton(
      onSelected: (value) {
        callback(value);
      },
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.borderRadius)),
      itemBuilder: (BuildContext context) => menuList,
      icon: icon,
    );
  }
}

enum PopupMenuOption {
  editOption,
  deleteOption,
}
