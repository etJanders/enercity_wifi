import 'package:flutter/material.dart';

import '../../../theme.dart';

///Desctiption
///Widget to enter a mail adress
///
///Author: J. Anders
///created: 30-11-2022
///changed: 26-01-2023
///
///History:
///26-01-2023 remove deprecated option
/// toolbarOptions: const ToolbarOptions(copy: false, paste: false, cut: false, selectAll: false),
///
///Notes:
class EditEmailTextInput extends StatelessWidget {
  final TextEditingController emailController;
  final String? hintText;

  const EditEmailTextInput(
      {super.key, required this.emailController, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: 1,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      cursorColor: AppTheme.textLightGrey,
      autocorrect: false,
      style: AppTheme.textStyleDefault,
      enableInteractiveSelection: true,
      autofocus: true,
      decoration: InputDecoration(
        hintStyle: const TextStyle(color: AppTheme.textLightGrey),
        hintText: hintText,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        prefixIcon: const Icon(
          Icons.alternate_email,
          color: AppTheme.textLightGrey,
        ),
      ),
    );
  }
}
