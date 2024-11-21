import 'package:flutter/material.dart';
import 'package:wifi_smart_living/dimens.dart';

import '../../../theme.dart';

///Description
///Widget which shows an checkbox
///
///Author: J. Anders
///created: 06-01-2023
///changed: 06-01-2023
///
///History:
///
///Notes:
///
class CheckboxWidgetDisabled extends StatefulWidget {
  final String title;
  final bool initState;
  final Function stateChanged;
  const CheckboxWidgetDisabled(
      {super.key,
      required this.title,
      required this.initState,
      required this.stateChanged});

  @override
  State<CheckboxWidgetDisabled> createState() => _CheckboxWidgetDisabledState();
}

class _CheckboxWidgetDisabledState extends State<CheckboxWidgetDisabled> {
  late bool checkState;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    checkState = widget.initState;
    return Container(
      height: Dimens.thermostatSettingsBoxHight,
      padding: const EdgeInsets.all(Dimens.paddingDefault),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimens.borderRadius),
          color: AppTheme.hintergrundHell),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.title,
            style: AppTheme.textStyleDefault,
          ),
          Switch(value: checkState, onChanged: null),
        ],
      ),
    );
  }
}
