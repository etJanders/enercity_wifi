import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wifi_smart_living/dimens.dart';

import '../../theme.dart';

///Description
///Alert Box which shows an information message
///
///Author: J. Anders
///created: 30-11-2022
///changed: 30-11-2022
///
///History:
///
///Notes:
///
class InformationAlert {
  void showAlertDialog(
      {required BuildContext context,
      required String message,
      required Function callback}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          InformationAlert().showAlertDialogWidget(context, message, callback),
    );
  }

  AlertDialog showAlertDialogWidget(
      BuildContext context, String message, Function callback) {
    AppLocalizations local = AppLocalizations.of(context)!;
    AlertDialog alertDialog = AlertDialog(
      content: Text(
        message,
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
            if (!(message == local.deleteUserAccountSuccesful) &&
                !(message == local.emailSuccesfullChanged)) {
              Navigator.of(context).pop();
            }
          },
          child: Text(
            local.okay,
            textAlign: TextAlign.center,
            style: AppTheme.textStyleColored,
          ),
        ),
      ],
    );
    return alertDialog;
  }
}
