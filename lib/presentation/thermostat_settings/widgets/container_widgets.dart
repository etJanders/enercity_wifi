import 'package:flutter/material.dart';
import 'package:wifi_smart_living/dimens.dart';

import '../../../theme.dart';

///Description
///Rectancle Box to show information
///
///Author: J. Anders
///created: 06-01-2023
///changed: 06-01-2023
///
///History:
///
///Notes:
///
class ContainerTextWidget extends StatelessWidget {
  final String title;
  final String value;

  const ContainerTextWidget(
      {Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimens.borderRadius),
      height: 200,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimens.borderRadius),
          color: AppTheme.violet),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTheme.textStyleWhite,
          ),
          const SizedBox(height: Dimens.paddingDefault),
          Text(
            setValue(value),
            style: AppTheme.textStyleWhite,
          ),
        ],
      ),
    );
  }

  String setValue(String data) {
    String output = '--';
    if (data.isNotEmpty && data != '#') {
      output = data;
    }
    return output;
  }
}
