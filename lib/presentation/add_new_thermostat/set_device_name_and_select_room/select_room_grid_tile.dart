import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/theme.dart';

class SelectRoomGridTile extends StatelessWidget {
  final String groupName;
  final String image;
  final Function onTapCallback;

  const SelectRoomGridTile(
      {super.key,
      required this.groupName,
      required this.image,
      required this.onTapCallback});

  @override
  Widget build(BuildContext context) {
    //um text neuen raum erstellen zu uebersetzen
    AppLocalizations local = AppLocalizations.of(context)!;
    return GridTile(
      footer: Container(
        padding: const EdgeInsets.all(Dimens.paddingDefault),
        child: GridTileBar(
          title: groupName.isEmpty
              ? Text(
                  local.createNewRoom,
                  textAlign: TextAlign.start,
                  style: AppTheme.textStyleWhite,
                )
              : Text(
                  groupName,
                  textAlign: TextAlign.start,
                  style: AppTheme.textStyleWhite,
                ),
        ),
      ),
      child: GestureDetector(
          onTap: () => onTapCallback(),
          child: Image.asset('assets/images/$image')),
    );
  }
}
