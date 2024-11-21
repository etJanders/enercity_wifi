import 'package:flutter/material.dart';
import 'package:wifi_smart_living/dimens.dart';

import '../../../theme.dart';

class AddWidget extends StatelessWidget {
  final Function onPressCallback;
  const AddWidget({super.key, required this.onPressCallback});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPressCallback();
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
                color: AppTheme.violet, width: Dimens.borderWidthSmall),
            color: AppTheme.violet,
            borderRadius: BorderRadius.circular(Dimens.borderRadius)),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        width: 35,
        height: 35,
        child: const Center(
          child: Icon(
            Icons.add,
            color: AppTheme.schriftfarbe,
          ),
        ),
      ),
    );
  }
}
