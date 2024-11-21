import 'package:flutter/material.dart';

import '../../../dimens.dart';
import '../../../theme.dart';

///Description
///Show a switch container with Information icon
///
///Author: J. Anders
///created: 27-02-2023
///changed: 27-02-2023
///
///History:
///
///Notes:
///
class CheckboxInfoWidget extends StatefulWidget {
  final String title;
  final bool initState;
  final Function stateChanged;
  final Function infoCallback;
  const CheckboxInfoWidget(
      {super.key,
      required this.title,
      required this.initState,
      required this.stateChanged,
      required this.infoCallback});

  @override
  State<CheckboxInfoWidget> createState() => _CheckboxInfoWidgetState();
}

class _CheckboxInfoWidgetState extends State<CheckboxInfoWidget> {
  late bool checkState;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    checkState = widget.initState;
    return Container(
      // width: double.infinity,
      padding: const EdgeInsets.all(Dimens.paddingDefault),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimens.borderRadius),
          color: AppTheme.violet),
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.start,

        children: [
          SizedBox(
            // flex: 1,
            //height: 18.0,
            width: 18.0,
            child: IconButton(
              onPressed: () => widget.infoCallback(),
              padding: const EdgeInsets.all(0),
              //constraints: const BoxConstraints(),
              icon: const Icon(
                Icons.info_outline_rounded,
                color: AppTheme.schriftfarbe,
                size: 24,
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            flex: 9,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  constraints: const BoxConstraints(maxWidth: 200),
                  child: Text(
                    widget.title,
                    style: AppTheme.textStyleWhite,
                    maxLines: 4,
                    softWrap: true,
                  ),
                ),
                Switch(
                    value: checkState,
                    onChanged: (onChanged) {
                      setState(() {
                        checkState = onChanged;
                        widget.stateChanged(onChanged);
                      });
                    }),
              ],
            ),
          )
        ],
      ),
    );
  }
}
