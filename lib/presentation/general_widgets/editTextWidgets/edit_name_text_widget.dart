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
class EditNameTextInput extends StatelessWidget {
  final TextEditingController emailController;
  final String? hintText;

  const EditNameTextInput(
      {super.key, required this.emailController, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: 1,
      maxLength: 15,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      cursorColor: AppTheme.textLightGrey,
      style: AppTheme.textStyleDefault,
      enableInteractiveSelection: false,
      decoration: InputDecoration(
        hintStyle: const TextStyle(color: AppTheme.textLightGrey),
        hintText: hintText,
        counterStyle: AppTheme.textStyleDefault,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        suffixIcon: const Icon(
          Icons.edit,
          color: AppTheme.textLightGrey,
        ),
      ),
    );
  }
}
