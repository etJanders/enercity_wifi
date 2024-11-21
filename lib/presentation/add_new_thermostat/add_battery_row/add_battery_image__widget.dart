import 'package:flutter/material.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/theme.dart';

class AddBatyImageWidget extends StatelessWidget {
  final String number;
  final String imageName;

  const AddBatyImageWidget(
      {super.key, required this.number, required this.imageName});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          number,
          style: AppTheme.textStyleDefault,
        ),
        const SizedBox(
          width: Dimens.sizedBoxHalf,
        ),
        Image.asset(
          imageName,
          width: Dimens.insertBatteryWidth,
          height: Dimens.insertBatteriesHight,
        ),
      ],
    );
  }
}
