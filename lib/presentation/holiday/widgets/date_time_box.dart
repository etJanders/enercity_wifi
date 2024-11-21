import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/provider/holiday_profile_provider.dart';

import '../../../theme.dart';

class HolidayDateTimeBox extends StatelessWidget {
  final bool startDate;
  final Function changeDate;
  final Function changeTime;
  const HolidayDateTimeBox(
      {super.key,
      required this.startDate,
      required this.changeDate,
      required this.changeTime});

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Dimens.sizedBoxBigDefault),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimens.borderRadius),
          color: AppTheme.hintergrundHell),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          startDate
              ? Text(
                  local.holidayStart,
                  style: AppTheme.textStyleDefault,
                )
              : Text(
                  local.holidayEnd,
                  style: AppTheme.textStyleDefault,
                ),
          const Divider(
            color: AppTheme.textDarkGrey,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                local.date,
                style: AppTheme.textStyleDefault,
              ),
              InkWell(
                onTap: () => changeDate(),
                child: Text(
                  startDate
                      ? context
                          .watch<HolidayProfileProvider>()
                          .getHolidayProfile
                          .getStartDate()
                      : context
                          .watch<HolidayProfileProvider>()
                          .getHolidayProfile
                          .getEndDate(),
                  style: AppTheme.textStyleDefaultUntderlined,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: Dimens.sizedBoxBigDefault,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                local.time,
                style: AppTheme.textStyleDefault,
              ),
              InkWell(
                onTap: () => changeTime(),
                child: Text(
                  startDate
                      ? context
                          .watch<HolidayProfileProvider>()
                          .getHolidayProfile
                          .getStartTimeWithFormat(context)
                      : context
                          .watch<HolidayProfileProvider>()
                          .getHolidayProfile
                          .getEndTimeWithFormat(context),
                  style: AppTheme.textStyleDefaultUntderlined,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
