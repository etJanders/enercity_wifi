import 'package:flutter/material.dart';

import '../../../theme.dart';

///Description
///General Widgit to enter a password allows to toggle visibility of text area
///All text Area inteactions are diesbaled (copy, paste, cut,..)
///
///Author: J. Anders
///created: 31-10-2022
///changed: 26-01-2023
///
///History:
///26-01-2023 remove deprecated option
///toolbarOptions: const ToolbarOptions( copy: false, paste: false, cut: false, selectAll: false),
///
///Notes:
///
class EditPasswortTextInput extends StatefulWidget {
  final TextEditingController passwordEditingControler;
  final String? hintText;

  const EditPasswortTextInput(
      {super.key,
      required this.passwordEditingControler,
      required this.hintText});

  @override
  State<EditPasswortTextInput> createState() => _EditPasswortTextInputState();
}

class _EditPasswortTextInputState extends State<EditPasswortTextInput> {
  //To toggel password visibility
  bool _isHidden = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.passwordEditingControler,
      cursorColor: AppTheme.textLightGrey,
      obscureText: _isHidden,
      autocorrect: false,
      enableInteractiveSelection: true,
      style: AppTheme.textStyleDefault,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          hintStyle: const TextStyle(color: AppTheme.textLightGrey),
          hintText: widget.hintText,
          prefixIcon: const Icon(
            Icons.lock,
            color: AppTheme.textLightGrey,
          ),
          suffixIcon: IconButton(
            onPressed: _togglePasswordVisibility,
            icon: _isHidden
                ? const Icon(
                    Icons.visibility_off,
                    color: AppTheme.textLightGrey,
                  )
                : const Icon(Icons.visibility),
            color: AppTheme.textLightGrey,
          )),
    );
  }

  void _togglePasswordVisibility() => setState(() {
        _isHidden = !_isHidden;
      });
}
