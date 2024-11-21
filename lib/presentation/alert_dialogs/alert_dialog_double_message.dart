import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../dimens.dart';
import '../../theme.dart';

///Description
///Alert Box which shows an information message with two selection options
///
///Author: J. Anders
///created: 30-11-2022
///changed: 30-11-2022
///
///History:
///
///Notes:
///
class InformationAlertDoubleMessage {
  AlertDialog _showAlertDialog(BuildContext context, String message,
      String subMessage, Function callback) {
    AppLocalizations local = AppLocalizations.of(context)!;
    AlertDialog alertDialog = AlertDialog(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            style: AppTheme.textStyleDefault,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: Dimens.sizedBoxDefault,
          ),
          Text(
            subMessage,
            style: AppTheme.textStyleDefault,
            textAlign: TextAlign.center,
          ),
        ],
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
            Navigator.of(context).pop();
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

  void showAlertDialog(
      {required BuildContext context,
      required String message,
      required String subMessage,
      required Function callback}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => InformationAlertDoubleMessage()
          ._showAlertDialog(context, message, subMessage, callback),
    );
  }
}
