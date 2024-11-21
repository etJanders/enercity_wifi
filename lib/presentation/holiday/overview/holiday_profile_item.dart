import 'package:flutter/material.dart';
import 'package:wifi_smart_living/const/const_general_app.dart';
import 'package:wifi_smart_living/helper/heating_profiel_helper/heating_weekday_creator.dart';
import 'package:wifi_smart_living/ja/check_tablet.dart';
import 'package:wifi_smart_living/models/database/model_schedule_manager.dart';

import '../../../dimens.dart';
import '../../../theme.dart';
import '../../general_widgets/popup_menu/popup_menu_widget.dart';

class HolidayProfileItem extends StatelessWidget {
  final ModelScheduleManager scheduleManager;
  final Function onTapCallback;
  final bool heatingprofile;
  final Function menuOptionCalled;

  const HolidayProfileItem(
      {super.key,
      required this.heatingprofile,
      required this.scheduleManager,
      required this.onTapCallback,
      required this.menuOptionCalled});

  @override
  Widget build(BuildContext context) {
    var tablet = TabletHelper().isTablet(context: context);
    return InkWell(
      onTap: () => onTapCallback(),
      child: Container(
        color: AppTheme.hintergrund,
        child: GridTile(
          header: Container(
            padding: tablet
                ? const EdgeInsets.only(top: 40, left: 20, right: 20)
                : const EdgeInsets.only(
                    top: Dimens.paddingDefault, left: 20, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                heatingprofile
                    ? Text(
                        DetermineWeekdays.weekdayOverview(
                            context: context,
                            smPublicId: scheduleManager.entryPublicId),
                        style: AppTheme.textStyleDefault,
                      )
                    : const Text(""),
                PopupMenuWidget(
                  callback: (value) {
                    menuOptionCalled(value);
                  },
                  icon: const Icon(
                    Icons.more_vert,
                    color: AppTheme.schriftfarbe,
                  ),
                ),
              ],
            ),
          ),
          footer: Container(
            padding: tablet
                ? const EdgeInsets.only(bottom: 40, left: 20)
                : const EdgeInsets.all(Dimens.paddingDefault),
            child: GridTileBar(
              title: Text(
                scheduleManager.scheduleName,
                style: tablet
                    ? AppTheme.textStyleWhiteTablet
                    : AppTheme.textStyleWhite,
                textAlign: TextAlign.start,
              ),
            ),
          ),
          child: Image.asset(
            "assets/images/${scheduleManager.scheudleImage}",
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(ConstAppGeneral.defaultHolidayProfileIcon);
            },
          ),
        ),
      ),
    );
  }
}
