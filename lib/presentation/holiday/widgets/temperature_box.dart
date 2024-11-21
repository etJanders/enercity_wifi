import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wifi_smart_living/provider/holiday_profile_provider.dart';

import '../../../dimens.dart';
import '../../../theme.dart';

class TemperatureBox extends StatelessWidget {
  final Function changeTemperature;
  const TemperatureBox({super.key, required this.changeTemperature});

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Dimens.sizedBoxBigDefault),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimens.borderRadius),
          color: AppTheme.hintergrundHell),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            local.temperature,
            style: AppTheme.textStyleDefault,
          ),
          InkWell(
            onTap: () => changeTemperature(),
            child: Text(
              '${context.watch<HolidayProfileProvider>().getHolidayProfile.getTemperature()} ',
              style: AppTheme.textStyleDefaultUntderlined,
            ),
          )
        ],
      ),
    );
  }
}
