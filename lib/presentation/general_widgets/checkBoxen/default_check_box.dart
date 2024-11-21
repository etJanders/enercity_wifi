// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../../../theme.dart';

class CustomeCheckBox extends StatefulWidget {
  bool initState;
  final Function callback;

  CustomeCheckBox({Key? key, required this.initState, required this.callback})
      : super(key: key);

  @override
  State<CustomeCheckBox> createState() => _CustomeCheckBoxState();
}

class _CustomeCheckBoxState extends State<CustomeCheckBox> {
  late bool checkedState;

  @override
  initState() {
    checkedState = widget.initState;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        unselectedWidgetColor: AppTheme.schriftfarbe,
      ),
      child: Checkbox(
        value: checkedState,
        checkColor: AppTheme.schriftfarbe,
        activeColor: AppTheme.textDarkGrey,
        onChanged: ((value) {
          setState(() {
            checkedState = value!;
            widget.callback(checkedState);
          });
        }),
        side: const BorderSide(color: AppTheme.textDarkGrey),
      ),
    );
  }
}
