import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
class OffsetInfoWidget extends StatefulWidget {
  final String title;
  final bool initState;
  final Function stateChanged;
  final Function infoCallback;
  final String offsetvalue;
  const OffsetInfoWidget(
      {super.key,
      required this.title,
      required this.initState,
      required this.stateChanged,
      required this.infoCallback,
      required this.offsetvalue});

  @override
  State<OffsetInfoWidget> createState() => _OffsetInfoWidgetState();
}

class _OffsetInfoWidgetState extends State<OffsetInfoWidget> {
  late bool checkState;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;

    checkState = widget.initState;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Dimens.paddingDefault),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimens.borderRadius),
          color: AppTheme.violet),
      child: Row(
        children: [
          const SizedBox(
            width: 5,
          ),
          Expanded(
            flex: 9,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  local.offset,
                  style: AppTheme.textStyleWhite,
                ),
                FilledButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.violet,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      //side: BorderSide(color: Colors.white),
                    ),
                  ),
                  onPressed: () {
                    widget.infoCallback();
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(widget.offsetvalue, style: AppTheme.textStyleWhite),
                      // <-- Text
                      const SizedBox(
                        width: 5,
                      ),
                      const Icon(
                        // <-- Icon
                        Icons.unfold_more,
                        size: 24.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
