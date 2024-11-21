import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../dimens.dart';
import '../../theme.dart';

///Description
///Information Alert if app detetcts wrong user credentials during the app workflo
///
///Author: J. Anders
///created: 18-01-2023
///changed: 18-01-2023
///
///History:
///
///Notes:
///
class AlertDialogCredentialsChanged {
  AlertDialog showAlertDialogWidget(BuildContext context, Function callback) {
    AppLocalizations local = AppLocalizations.of(context)!;
    AlertDialog alertDialog = AlertDialog(
      content: Text(
        local.loginDataChanged,
        style: AppTheme.textStyleDefault,
        textAlign: TextAlign.center,
      ),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(Dimens.borderRadius))),
      alignment: Alignment.center,
      actionsAlignment: MainAxisAlignment.center,
      backgroundColor: AppTheme.schriftfarbe,
      actions: [
        TextButton(
          onPressed: () {
            callback();
          },
          child: Text(
            local.goToLogin,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppTheme.violet),
          ),
        ),
      ],
    );
    return alertDialog;
  }
}
