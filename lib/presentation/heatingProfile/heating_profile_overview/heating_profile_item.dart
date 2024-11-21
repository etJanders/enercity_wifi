import 'package:flutter/material.dart';
import 'package:wifi_smart_living/helper/heating_profiel_helper/heating_weekday_creator.dart';
import 'package:wifi_smart_living/models/database/model_schedule_manager.dart';

import '../../../dimens.dart';
import '../../../theme.dart';
import '../../general_widgets/popup_menu/popup_menu_widget.dart';

class HeatingProfileItem extends StatelessWidget {
  final ModelScheduleManager scheduleManager;
  final Function onTapCallback;
  final bool heatingprofile;
  final Function menuOptionCalled;
  final bool tabletUsed;

  const HeatingProfileItem(
      {super.key,
      required this.heatingprofile,
      required this.scheduleManager,
      required this.onTapCallback,
      required this.menuOptionCalled,
      required this.tabletUsed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTapCallback(),
      child: Container(
        color: AppTheme.hintergrund,
        child: GridTile(
          header: Container(
            padding: tabletUsed
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
                        style: tabletUsed
                            ? AppTheme.textStyleWhiteTablet
                            : AppTheme.textStyleWhite,
                      )
                    : const Text(""),
                PopupMenuWidget(
                  callback: (value) {
                    print('Popup menu widget $value');
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
            padding: tabletUsed
                ? const EdgeInsets.only(bottom: 40, left: 20)
                : const EdgeInsets.all(Dimens.paddingDefault),
            child: GridTileBar(
              title: Text(
                scheduleManager.scheduleName,
                style: tabletUsed
                    ? AppTheme.textStyleWhiteTablet
                    : AppTheme.textStyleWhite,
                textAlign: TextAlign.start,
              ),
            ),
          ),
          child: Image.asset("assets/images/${scheduleManager.scheudleImage}"),
        ),
      ),
    );
  }
}
