import 'package:flutter/material.dart';

import '../../dimens.dart';
import '../../theme.dart';

///Description
///A Alert Dialog Box with two selection oprions
///
///Author: J. Anders
///created: 15-12-2022
///changed: 15-12-2022
///
///History:
///
///Notes:
///
class AlertDialogYes {
  AlertDialog _showAlertDialog(
      BuildContext context, String message, String positiveButtontext) {
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
            print("Value is true");
            Navigator.of(context).pop(true);
          },
          child: Text(
            positiveButtontext,
            textAlign: TextAlign.center,
            style: AppTheme.textStyleColored,
          ),
        ),
      ],
    );
    return alertDialog;
  }

  Future<bool> zeigeDialog({
    required BuildContext context,
    required String message,
    required String positiveButtontext,
  }) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialogYes()
          ._showAlertDialog(context, message, positiveButtontext),
    );
  }
}
