import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wifi_smart_living/bloc/edit_ui_structures/edit_ui_structures_bloc.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/presentation/edit_structures/edit_schedule/edit_schedule_change_image.dart';
import 'package:wifi_smart_living/presentation/edit_structures/edit_schedule/edit_schedule_change_name.dart';
import 'package:wifi_smart_living/presentation/general_widgets/back_button_widget/back_button_widget.dart';
import 'package:wifi_smart_living/theme.dart';

class EditSchedulePage extends StatefulWidget {
  static const routName = '/edit_schedule_page';
  const EditSchedulePage({super.key});

  @override
  State<EditSchedulePage> createState() => _EditSchedulePageState();
}

class _EditSchedulePageState extends State<EditSchedulePage> {
  //toggle views edit name, edit image
  bool editImage = false;
  late String subtitle;

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    subtitle = editImage ? local.selectSymbol : local.edit;
    return BlocProvider(
      create: (context) => EditUiStructuresBloc(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: const BackButtonWidget(),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(local.editSchedule),
              Text(
                subtitle,
                style: AppTheme.textStyleDefault,
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(Dimens.paddingDefault),
          child: editImage
              ? EditScheduleChangeImage(changeUi: changeUI)
              : EditScheduleChangeNamePage(changeUi: changeUI),
        ),
      ),
    );
  }

  void changeUI() {
    setState(() {
      editImage = !editImage;
    });
  }
}
