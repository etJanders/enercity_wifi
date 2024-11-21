import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../theme.dart';

class TokenInputField extends StatelessWidget {
  final String labelText;
  final TextEditingController tokenControler;

  const TokenInputField(
      {Key? key, required this.labelText, required this.tokenControler})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: 6,
      maxLines: 1,
      controller: tokenControler,
      keyboardType: Platform.isIOS
          ? const TextInputType.numberWithOptions(signed: true)
          : TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      textInputAction: TextInputAction.done,
      cursorColor: AppTheme.textLightGrey,
      style: AppTheme.textStyleDefault,
      enableInteractiveSelection: true,
      decoration: InputDecoration(
        hintText: labelText,
        hintStyle: const TextStyle(color: AppTheme.textLightGrey),
        counter: const Offstage(),
        prefixIcon: const Icon(
          Icons.key,
          color: AppTheme.textLightGrey,
        ),
      ),
    );
  }
}
