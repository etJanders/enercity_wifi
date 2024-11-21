import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wifi_smart_living/dimens.dart';

import '../../../theme.dart';

class ClickButtonFilled extends StatelessWidget {
  //Text der dem Button zugewisen wird
  final String buttonText;
  //Login Funktion
  final Function buttonFunktion;
  final double width;
  const ClickButtonFilled(
      {super.key,
      required this.buttonText,
      required this.buttonFunktion,
      required this.width});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (() => buttonFunktion()),
      child: Container(
        width: width,
        margin: Platform.isIOS
            ? const EdgeInsets.only(bottom: 10)
            : const EdgeInsets.only(bottom: 0),
        padding: const EdgeInsets.all(Dimens.borderRadius),
        decoration: BoxDecoration(
            color: AppTheme.violet,
            border:
                Border.all(color: AppTheme.violet, width: Dimens.borderWidth),
            borderRadius: BorderRadius.circular(Dimens.borderRadius)),
        child: Center(
          child: Text(
            buttonText,
            style: AppTheme.textStyleWhite,
          ),
        ),
      ),
    );
  }
}
