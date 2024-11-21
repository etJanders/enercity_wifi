import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/theme.dart';

///Description
///Container to show mac adress of a device
///
///Author: J. Anders
///created: 30-11-2022
///changed: 30-11-2022
///
///History:
///
///Notes:
///
class DeviceMacWidget extends StatelessWidget {
  final String macAdress;
  const DeviceMacWidget({super.key, required this.macAdress});

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      height: Dimens.thermostatSettingsBoxHight,
      padding: const EdgeInsets.all(Dimens.paddingDefault),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimens.borderRadius),
        color: AppTheme.violet,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            local.macAdresse,
            style: AppTheme.textStyleWhite,
          ),
          Text(
            macAdress,
            style: AppTheme.textStyleWhite,
          ),
        ],
      ),
    );
  }
}
