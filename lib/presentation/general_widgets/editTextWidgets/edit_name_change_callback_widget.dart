import 'package:flutter/material.dart';

import '../../../theme.dart';

///Description
///
///Autoihr: J. Anders
///created: 30-11-2022
///changed: 26-01-2023
///
///History:
///26-01-2023 remove deprecated option
///toolbarOptions: const ToolbarOptions(copy: false, paste: false, cut: false, selectAll: false),
///
///Notes:
class EditNameCallbackTextInput extends StatelessWidget {
  final TextEditingController emailController;
  final Function dataChanged;

  const EditNameCallbackTextInput(
      {super.key, required this.emailController, required this.dataChanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: 1,
      maxLength: 15,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      cursorColor: AppTheme.textLightGrey,
      style: AppTheme.textStyleDefault,
      onEditingComplete: () {
        dataChanged();
      },
      decoration: const InputDecoration(
        hintStyle: TextStyle(color: AppTheme.textLightGrey),
        counterStyle: AppTheme.textStyleDefault,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        suffixIcon: Icon(
          Icons.edit,
          color: AppTheme.textLightGrey,
        ),
      ),
    );
  }
}
