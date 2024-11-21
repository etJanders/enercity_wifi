import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wifi_smart_living/core/uiHelper/build_time_string.dart';
import 'package:wifi_smart_living/theme.dart';

import '../../../core/uiHelper/build_temperature_string.dart';
import '../../../heatingProfile/heating_profile_item.dart';

class TimeScheduleRow extends StatelessWidget {
  final HeatingProfileDatabaseItem item;
  final Function callbackTime;
  final Function callbackTemperature;
  final Function callbackDelete;

  const TimeScheduleRow(
      {super.key,
      required this.item,
      required this.callbackTime,
      required this.callbackTemperature,
      required this.callbackDelete});

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          local.from,
          textAlign: TextAlign.center,
          style: AppTheme.textStyleDefault,
        ),
        InkWell(
          onTap: () => callbackTime(),
          child: Row(
            children: [
              Text(
                BuildTimeString.getDisplayTimeWithFormat(context,
                    hour: item.getStartHour, minute: item.getStartMinute),
                textAlign: TextAlign.center,
                style: AppTheme.textStyleDefault,
              ),
              const SizedBox(
                width: 5,
              ),
              const ImageIcon(
                AssetImage("assets/images/heizprofil_menu.png"),
                color: AppTheme.textDarkGrey,
                size: 18,
              )
            ],
          ),
        ),
        InkWell(
          onTap: () => callbackTemperature(),
          child: Row(
            children: [
              Text(
                BuildTemperatureString.bildTemperatureStringBasic(
                    temperature: item.getTemperature),
                textAlign: TextAlign.center,
                style: AppTheme.textStyleDefault,
              ),
              const SizedBox(
                width: 5,
              ),
              const ImageIcon(
                AssetImage("assets/images/thermometer.png"),
                size: 24,
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => callbackDelete(),
          icon: const ImageIcon(
            AssetImage("assets/images/delete_icon.png"),
            color: AppTheme.textDarkGrey,
            size: 24,
          ),
        )
      ],
    );
  }
}
