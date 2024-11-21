import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wifi_smart_living/dimens.dart';

import '../../../theme.dart';

class EditImageWidget extends StatelessWidget {
  final String imageName;
  final Function onClickCallback;
  const EditImageWidget(
      {super.key, required this.imageName, required this.onClickCallback});

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () => onClickCallback(),
      child: SizedBox(
          width: 200,
          height: 150,
          child: GridTile(
            header: const GridTileBar(
              trailing: Icon(
                Icons.edit,
                color: AppTheme.schriftfarbe,
                size: 24,
              ),
            ),
            footer: Container(
              padding: const EdgeInsets.only(left: Dimens.paddingDefault),
              child: GridTileBar(
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Text(
                    local.symbol,
                    style: const TextStyle(
                      fontSize: 17,
                      color: AppTheme.schriftfarbe,
                    ),
                  ),
                ),
                subtitle: Text(
                  local.bearbeitenSmall,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 17,
                    color: AppTheme.schriftfarbe,
                  ),
                ),
              ),
            ),
            child: Image.asset("assets/images/$imageName"),
          )),
    );
  }
}
