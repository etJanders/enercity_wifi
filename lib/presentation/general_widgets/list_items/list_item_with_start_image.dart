import 'package:flutter/material.dart';

import '../../../dimens.dart';
import '../../../theme.dart';

class ListItemStartImage extends StatelessWidget {
  final Function onClick;
  final String title;
  final String assetName;

  const ListItemStartImage(
      {super.key,
      required this.onClick,
      required this.title,
      required this.assetName});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onClick(),
      child: Row(
        children: [
          Image.asset(
            "assets/images/$assetName",
            height: Dimens.smallImageSize,
            width: Dimens.smallImageSize,
          ),
          const SizedBox(
            width: Dimens.sizedBoxDefault,
          ),
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
    );
  }
}
