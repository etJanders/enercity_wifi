import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wifi_smart_living/dimens.dart';

import '../../../theme.dart';

///Description
///Show the battery value of a device.
///
///Author: J. Anders
///Created: 30-11-2022
///changed: 13-03-2023
///
///History:
///13-03-2023 Anpassung der Batterie Auswertung. Wenn Batterie Value noch nicht
///vorhanden, ist app abgestürzt, da # zum Ermitteln des Batterie Icons nicht verarbeitet
///werden konnte.
///
///Notes:
///
class BatterieWidget extends StatelessWidget {
  final String batterieValue;

  const BatterieWidget({Key? key, required this.batterieValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      height: Dimens.thermostatSettingsBoxHight,
      padding: const EdgeInsets.fromLTRB(
          Dimens.paddingDefault,
          Dimens.paddingDefault,
          Dimens.paddingSecondary,
          Dimens.paddingDefault),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimens.borderRadius),
          color: AppTheme.violet),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            local.batterieState,
            style: AppTheme.textStyleWhite,
          ),
          Row(
            children: [
              //Container(
              //width: 50,
              //child:
              Image.asset(
                determineImageAsset(batterieValue),
                width: Dimens.smallImageSize,
                height: Dimens.smallImageSize,
              ),
              //),
            ],
          )
        ],
      ),
    );
  }

  String batterieStringMapping(String batterie) {
    if (batterie != '#') {
      int batterieValue = int.parse(batterie);
      if (batterieValue > 100) {
        batterieValue = 100;
      } else if (batterieValue < 0) {
        batterieValue = 0;
      }
      return batterieValue.toString();
    } else {
      return '-- ';
    }
  }

  //Bestimme je nach Batteriestand das anzuzeigende Bild
  String determineImageAsset(String batterie) {
    String batterieImage = "assets/images/batterie_voll.png";
    if (batterie != '#') {
      int batterieInt = int.parse(batterie);

      if (batterieInt > 100) {
        batterieValue == '100';
      }
      if (batterieInt > 29) {
        batterieImage = "assets/images/batterie_voll.png";
      } else if (batterieInt > 9) {
        batterieImage = "assets/images/batterie_50.png";
      } else {
        batterieImage = "assets/images/batterie_fast_leer.png";
      }
    }
    return batterieImage;
  }
}
