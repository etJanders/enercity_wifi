import 'package:flutter/material.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/models/ui/heating_profile/model_select_weekday.dart';
import 'package:wifi_smart_living/theme.dart';

class WeekdaySelectionItem extends StatelessWidget {
  final ModelSelectWeekday selectWeekday;
  final Function itemClicked;

  const WeekdaySelectionItem(
      {super.key, required this.selectWeekday, required this.itemClicked});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => itemClicked(),
      child: GridTile(
        child: Container(
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: selectWeekday.selected
                    ? AppTheme.violet
                    : AppTheme.hintergrund,
                border: Border.all(
                    color: AppTheme.violet, width: Dimens.borderWidth),
                borderRadius: BorderRadius.circular(Dimens.borderRadius)),
            child: Center(
                child: selectWeekday.selected
                    ? Text(
                        selectWeekday.title.toUpperCase(),
                        style: AppTheme.textStyleWhite,
                        textAlign: TextAlign.center,
                      )
                    : Stack(
                        alignment: Alignment.center, // Center of Top
                        children: <Widget>[
                          Center(
                            child: Text(
                              selectWeekday.title.toUpperCase(),
                              style: AppTheme.textStyleColored,
                              textAlign: TextAlign.center,
                              // ),
                            ),
                          ),
                        ],
                      ))),
      ),
    );
  }
}
