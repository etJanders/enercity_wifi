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
class CheckboxWidget extends StatefulWidget {
  final String title;
  final bool initState;
  final Function stateChanged;
  final bool isFromThermostatRoomContent;
  const CheckboxWidget(
      {super.key,
      required this.title,
      required this.initState,
      required this.stateChanged,
      this.isFromThermostatRoomContent = false});

  @override
  State<CheckboxWidget> createState() => _CheckboxWidgetState();
}

class _CheckboxWidgetState extends State<CheckboxWidget> {
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
          color: widget.isFromThermostatRoomContent
              ? AppTheme.hintergrundHell
              : AppTheme.violet),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.title,
            style: widget.isFromThermostatRoomContent
                ? AppTheme.textStyleDefault
                : AppTheme.textStyleWhite,
          ),
          Switch(
              activeTrackColor: widget.isFromThermostatRoomContent
                  ? AppTheme.violet
                  : AppTheme.textLightGrey,
              value: checkState,
              onChanged: (onChanged) {
                setState(() {
                  checkState = onChanged;
                  widget.stateChanged(onChanged);
                });
              }),
        ],
      ),
    );
  }
}
