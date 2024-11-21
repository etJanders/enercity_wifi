import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wifi_smart_living/presentation/thermostat_control/temperature_mapping/temperature_mapping.dart';
import 'package:wifi_smart_living/theme.dart';

import '../../dimens.dart';
import '../thermostat_control/temperature_slider_widget.dart';

class SelectTemperatureAlert {
  //Defaut 16°C
  String _temperatureChanged = '20';

  AlertDialog _showAlertDialog(
    BuildContext context,
    Function callback,
    String titleText,
    String positiveButtonText,
    String negativeButtonText,
  ) {
    AppLocalizations local = AppLocalizations.of(context)!;
    if (titleText != '80') {
      _temperatureChanged = titleText;
    }
    AlertDialog alertDialog = AlertDialog(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            local.temperaturheatingTime,
            style: AppTheme.textStyleDefault,
          ),
          const SizedBox(
            height: Dimens.sizedBoxBigDefault,
          ),
          TemperatureSliderWidget(
              temperatureChanged: (value) {
                _temperatureChanged =
                    TemperatureMapping().getTempToSend(value: value);
              },
              temperature: titleText)
        ],
      ),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(Dimens.borderRadius))),
      alignment: Alignment.center,
      actionsAlignment: MainAxisAlignment.end,
      backgroundColor: AppTheme.hintergrund,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            negativeButtonText,
            textAlign: TextAlign.center,
            style: AppTheme.textStyleColored,
          ),
        ),
        TextButton(
          onPressed: () {
            if (_temperatureChanged.isNotEmpty) {
              callback(_temperatureChanged);
            }
            Navigator.of(context).pop();
          },
          child: Text(
            positiveButtonText,
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
      required Function callback,
      required String titleText,
      required String positiveButtontext,
      required String negativeButtonText}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((context) => SelectTemperatureAlert()._showAlertDialog(
              context,
              callback,
              titleText,
              positiveButtontext,
              negativeButtonText,
            )));
  }
}
