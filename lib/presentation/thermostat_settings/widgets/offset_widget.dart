import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../../../dimens.dart';
import '../../../theme.dart';

///Description
///Manages offset settings of a thermostat
///
///Author: J. Anders
///created: 30-11-2022
///changed: 30-11-2022
///
///History
///
///Notes:
///Todo wird nicht verwendet. Muss noch eingebunden werden
class OffsetWidget extends StatefulWidget {
  final Function offsetChanged;
  const OffsetWidget({super.key, required this.offsetChanged});

  @override
  State<OffsetWidget> createState() => _OffsetWidgetState();
}

class _OffsetWidgetState extends State<OffsetWidget> {
  List<String> offsetValues = [
    "-3.0°C",
    '-2.0°C',
    '-1.0°C',
    '0.0°C',
    '+1.0°C',
    '+2.0°C',
    '+3.0°C'
  ];

  int selectedOffsetState = 3;
  late String offsetString;

  @override
  void initState() {
    offsetString = offsetValues[selectedOffsetState];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimens.borderRadius),
          color: AppTheme.hintergrund),
      child: Padding(
        padding: const EdgeInsets.all(Dimens.paddingDefault),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              local.offset,
              style: AppTheme.textStyleDefault,
            ),
            const SizedBox(
              height: Dimens.sizedBoxDefault,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  offsetString,
                  style: AppTheme.textStyleColored,
                ),
                SleekCircularSlider(
                  initialValue: 0,
                  max: 3,
                  min: -3,
                  onChange: (value) {},
                  onChangeEnd: (value) {
                    // widget.temperatureChanged(value.round());
                  },
                  appearance: CircularSliderAppearance(
                    // animationEnabled: animation,
                    size: 200,
                    customColors: CustomSliderColors(
                        trackColor: AppTheme.schriftfarbe,
                        progressBarColor: AppTheme.violet,
                        dotColor: AppTheme.violet,
                        hideShadow: true),
                    customWidths: CustomSliderWidths(
                        trackWidth: 5, progressBarWidth: 6, handlerSize: 10),
                    infoProperties: InfoProperties(
                      mainLabelStyle: AppTheme.textStyleDefault,
                      //  modifier: (percentage) => percentageModifier(percentage),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
