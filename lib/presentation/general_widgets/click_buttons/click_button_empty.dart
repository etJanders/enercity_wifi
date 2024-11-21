import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wifi_smart_living/dimens.dart';

import '../../../theme.dart';

class ClickButton extends StatelessWidget {
  //Text der dem Button zugewisen wird
  final String buttonText;
  //Login Funktion
  final Function? buttonFunktion;
  final double width;

  const ClickButton(
      {super.key,
      required this.buttonText,
      required this.buttonFunktion,
      required this.width});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (() {
        if (buttonFunktion != null) {
          buttonFunktion!();
        }
      }),
      child: Container(
        width: width,
        padding: const EdgeInsets.all(Dimens.borderRadius),
        margin: Platform.isIOS
            ? const EdgeInsets.only(bottom: 10)
            : const EdgeInsets.only(bottom: 0),
        decoration: BoxDecoration(
            color: AppTheme.hintergrund,
            border:
                Border.all(color: AppTheme.violet, width: Dimens.borderWidth),
            borderRadius: BorderRadius.circular(Dimens.borderRadius)),
        child: Center(
          child: Text(
            buttonText,
            style: AppTheme.textStyleColored,
          ),
        ),
      ),
    );
  }
}
