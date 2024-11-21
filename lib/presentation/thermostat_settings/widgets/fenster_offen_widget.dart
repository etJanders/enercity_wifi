import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/thermostat_attributes/window_open_detection.dart';

import '../../../theme.dart';

// ignore: must_be_immutable
///Description
///Manage window open detection
///
///Author: J. Anders
///created: 30-11-2022
///changed: 30-11-2022
///
///History:
///
///Notes:
///
class FensterOffenWidget extends StatefulWidget {
  final WindowOpenDetectionHelper model;
  final Function stateChanged;

  const FensterOffenWidget(
      {Key? key, required this.model, required this.stateChanged})
      : super(key: key);

  @override
  State<FensterOffenWidget> createState() => _FensterOffenWidgetState();
}

class _FensterOffenWidgetState extends State<FensterOffenWidget> {
  List<String> sliderValues = [];
  List<String> durationValues = ["10", "20", "30", "40", "50", "60"];
  late String sensitivityText;
  late String durationText;
  late WindowOpenDetectionHelper model;

  @override
  void initState() {
    model = widget.model;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    sliderValues = [local.low, local.middle, local.high];
    sensitivityText = sliderValues[model.getSensitivityPointer()];
    durationText = durationValues[model.getDurationPointer()];
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimens.borderRadius),
          color: AppTheme.violet),
      child: Padding(
        padding: const EdgeInsets.all(Dimens.paddingDefault),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  local.windowOpenDetection,
                  style: AppTheme.textStyleWhite,
                ),
                Switch(
                    value: model.windowOpenDetectionEnabled,
                    onChanged: (onChanged) {
                      setState(() {
                        model.enableDisable(onChanged);
                        if (model.windowOpenDetectionEnabled) {
                          sensitivityText =
                              sliderValues[model.getSensitivityPointer()];
                          durationText =
                              durationValues[model.getDurationPointer()];
                        }
                      });
                      widget.stateChanged(model);
                    })
              ],
            ),
            if (model.windowOpenDetectionEnabled)
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(
                    color: AppTheme.schriftfarbe,
                  ),
                  Text(
                    local.windowOpenDetectionSensitivity,
                    style: AppTheme.textStyleWhite,
                  ),
                  const SizedBox(
                    height: Dimens.sizedBoxHalf,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        sensitivityText,
                        style: AppTheme.textStyleWhite,
                      ),
                      SliderTheme(
                        data: const SliderThemeData(
                          trackHeight: Dimens.trackHeight,
                          thumbShape: RoundSliderThumbShape(
                              enabledThumbRadius: Dimens.trackThumbRadius),
                          overlayShape: RoundSliderOverlayShape(
                              overlayRadius: Dimens.zero),
                        ),
                        child: Slider(
                          activeColor: AppTheme.textLightGrey,
                          inactiveColor: AppTheme.schriftfarbe,
                          thumbColor: AppTheme.textDarkGrey,
                          value: model.getSensitivityPointer().toDouble(),
                          min: 0,
                          max: sliderValues.length - 1,
                          divisions: sliderValues.length - 1,
                          onChanged: (onChanged) {
                            setState(() {
                              model.changeSensitivity(onChanged.toInt());
                              sensitivityText =
                                  sliderValues[model.getSensitivityPointer()];
                            });
                            widget.stateChanged(model);
                          },
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: Dimens.sizedBoxDefault,
                  ),
                  const Divider(
                    color: AppTheme.schriftfarbe,
                  ),
                  Text(
                    local.windowOpenDetectionDuration,
                    style: AppTheme.textStyleWhite,
                  ),
                  const SizedBox(
                    height: Dimens.sizedBoxHalf,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        durationText,
                        style: AppTheme.textStyleWhite,
                      ),
                      SliderTheme(
                        data: const SliderThemeData(
                          trackHeight: Dimens.trackHeight,
                          thumbShape: RoundSliderThumbShape(
                              enabledThumbRadius: Dimens.trackThumbRadius),
                          overlayShape: RoundSliderOverlayShape(
                              overlayRadius: Dimens.zero),
                        ),
                        child: Slider(
                          activeColor: AppTheme.textLightGrey,
                          inactiveColor: AppTheme.schriftfarbe,
                          thumbColor: AppTheme.textDarkGrey,
                          value: model.getDurationPointer().toDouble(),
                          min: 0,
                          max: durationValues.length - 1,
                          divisions: durationValues.length - 1,
                          onChanged: (onChanged) {
                            setState(() {
                              model.changeDuration(onChanged.toInt());
                              durationText =
                                  durationValues[model.getDurationPointer()];
                            });
                            widget.stateChanged(model);
                          },
                        ),
                      )
                    ],
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
