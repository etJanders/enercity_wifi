import 'package:flutter/material.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/theme.dart';

///Description
///Singel Listview icon without a start icon
///
///Author: J. Anders
///created: 15-12-2022
///changed: 15-12-2022
///
///History:
///
///Notes:
class SingelListItemWidget extends StatelessWidget {
  final String title;
  final Function itemClickedCallback;
  const SingelListItemWidget(
      {super.key, required this.title, required this.itemClickedCallback});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => itemClickedCallback(),
      child: SizedBox(
        width: double.infinity,
        child: Container(
          margin: const EdgeInsets.only(
              bottom: Dimens.paddingDefault, top: Dimens.paddingDefault),
          child: Row(
            children: [
              Text(
                title,
                style: AppTheme.textStyleDefault,
              ),
              const Spacer(),
              const Icon(
                Icons.chevron_right,
                size: Dimens.iconSize,
                color: AppTheme.violet,
              )
            ],
          ),
        ),
      ),
    );
  }
}
