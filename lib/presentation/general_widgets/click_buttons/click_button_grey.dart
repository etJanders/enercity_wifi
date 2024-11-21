import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wifi_smart_living/dimens.dart';

import '../../../theme.dart';

class ClickButtonGrey extends StatelessWidget {
  final String buttonText;
  final Function? buttonFunktion;
  final double width;

  const ClickButtonGrey(
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
            color: AppTheme.hintergrundHell,
            borderRadius: BorderRadius.circular(Dimens.borderRadius)),
        child: Center(
          child: Text(
            buttonText,
            style: AppTheme.textStyleDefault,
          ),
        ),
      ),
    );
  }
}
