import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wifi_smart_living/bloc/edit_ui_structures/edit_ui_structures_bloc.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/presentation/edit_structures/edit_room/edit_room_image.dart';
import 'package:wifi_smart_living/theme.dart';

import '../../../provider/edit_room_provider.dart';
import '../../general_widgets/back_button_widget/back_button_widget.dart';
import 'edit_room_content.dart';

///Description
///Change displayed  Name of a thermostat
///
///Author: J. Anders
///created: 17-01-2023
///changed: 17-01-2023
///
///History:
///
///Notes:
///
class EditRoomStructurePage extends StatefulWidget {
  static const String routName = '/edit_room_name';
  const EditRoomStructurePage({super.key});

  @override
  State<EditRoomStructurePage> createState() => _EditRoomStructurePageState();
}

class _EditRoomStructurePageState extends State<EditRoomStructurePage> {
  bool changeImage = false;
  late String subtitle;

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    subtitle = changeImage ? local.selectSymbol : local.edit;
    return BlocProvider(
      create: (context) => EditUiStructuresBloc(),
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            leading: const BackButtonWidget(),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    '${local.edit} ${context.read<EditRoomProvider>().getGroupManagement.groupName}'),
                Text(
                  subtitle,
                  style: AppTheme.textStyleDefault,
                ),
              ],
            ),
          ),
          body: Padding(
              padding: const EdgeInsets.all(Dimens.paddingDefault),
              child: changeImage
                  ? EditRoomImagePage(
                      changeUiCallback: changeUI,
                    )
                  : EditRoomStructureContent(
                      changeUI: changeUI,
                    ))),
    );
  }

  void changeUI() {
    setState(() {
      changeImage = !changeImage;
    });
  }
}
