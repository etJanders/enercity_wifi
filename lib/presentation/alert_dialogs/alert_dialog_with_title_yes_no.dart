import 'package:flutter/material.dart';
import 'package:wifi_smart_living/helper/userSpecificPopUpHelper/user_pop_up_helper.dart';

import '../../dimens.dart';
import '../../theme.dart';
import '../general_widgets/checkBoxen/default_check_box.dart';

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
class AlertDialogTitleYesNo {
  AlertDialog _showAlertDialog(BuildContext context, String title,
      String message, String positiveButtontext, String doNotShow) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(
        title,
        style: AppTheme.textStyleDefault,
        textAlign: TextAlign.center,
      ),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              doNotShow,
              style: AppTheme.textStyleColored,
            ),
            CustomeCheckBox(
                initState: false,
                callback: (value) {
                  PopUpHelper().statusIntermediateCheckbox = value;
                })
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(
                positiveButtontext,
                textAlign: TextAlign.center,
                style: AppTheme.textStyleColored,
              ),
            ),
          ],
        )
      ],
    );
    return alertDialog;
  }

  Future<bool> zeigeDialogs(
      {required BuildContext context,
      required String title,
      required String message,
      required String positiveButtontext,
      required String doNotShow}) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialogTitleYesNo()._showAlertDialog(
          context, title, message, positiveButtontext, doNotShow),
    );
  }
}
