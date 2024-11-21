import 'package:flutter/material.dart';
import 'package:wifi_smart_living/timer/individual_timer.dart';

import '../../../theme.dart';

///Description
///Loading Cycle Animation
///
///Author: J. Anders
///created: 30-11-2022
///changed: 06-01-2023
///
///History:
///06-01-2023: dismiss animation after timeout of 1 second
///
///Notes:
///
class LoadingCicle {
  BuildContext context;
  LoadingCicle({required this.context});

  ///Achtung!!! nicht verwenden
  AlertDialog showAlertDialog(String message) {
    AlertDialog alertDialog = AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            style: const TextStyle(color: AppTheme.violet),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),
          const Center(
            child: CircularProgressIndicator(
              color: AppTheme.violet,
            ),
          )
        ],
      ),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      alignment: Alignment.center,
      actionsAlignment: MainAxisAlignment.center,
      backgroundColor: AppTheme.schriftfarbe,
    );
    return alertDialog;
  }

  void showAnimation(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => showAlertDialog(message),
    );
  }

  ///Stop animation and dissmiss the view
  void animationDismiss() {
    Navigator.of(context).pop();
  }

  ///Stop animation with 2 second delay and dissmiss the view
  void animationDismissWithDelay() {
    IndividualTimer timer = IndividualTimer();
    timer.starteMsTimer(2000, (value) {
      Navigator.of(context).pop();
    });
  }
}
