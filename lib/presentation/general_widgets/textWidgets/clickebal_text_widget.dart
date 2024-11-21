import 'package:flutter/material.dart';

class ClickedText extends StatelessWidget {
  final Function onClick;
  final String text;
  final Color textColor;

  const ClickedText(
      {Key? key,
      required this.text,
      required this.textColor,
      required this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onClick(),
      child: Text(
        text,
        style: TextStyle(color: textColor, decoration: TextDecoration.none),
      ),
    );
  }
}
