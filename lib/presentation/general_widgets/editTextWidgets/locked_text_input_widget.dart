import 'package:flutter/material.dart';
import 'package:wifi_smart_living/dimens.dart';

import '../../../theme.dart';

class LockedEditTextInput extends StatelessWidget {
  final String text;

  const LockedEditTextInput({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: 1,
      readOnly: true,
      enabled: false,
      focusNode: FocusNode(),
      style: AppTheme.textStyleDefault,
      enableInteractiveSelection: false,
      decoration: InputDecoration(
        disabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppTheme.violet, width: 1.0),
            borderRadius: BorderRadius.circular(Dimens.borderRadius)),
        label: Text(text,
            style: AppTheme.textStyleDefault
                .copyWith(color: AppTheme.textLightGrey)),
        hintStyle: const TextStyle(color: AppTheme.textLightGrey),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        prefixIcon: const Icon(
          Icons.wifi,
          color: AppTheme.textLightGrey,
        ),
      ),
    );
  }
}
