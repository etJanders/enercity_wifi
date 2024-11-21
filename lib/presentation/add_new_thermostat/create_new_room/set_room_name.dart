// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wifi_smart_living/api_handler/api_treiber/create_new_room/create_new_room_helper.dart';
import 'package:wifi_smart_living/bloc/add_new_thermostat/add_new_thermostat_bloc.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/presentation/alert_dialogs/alert_dialog_information.dart';
import 'package:wifi_smart_living/presentation/general_widgets/click_buttons/click_button_colored.dart';
import 'package:wifi_smart_living/presentation/general_widgets/editTextWidgets/edit_name_text_widget.dart';
import 'package:wifi_smart_living/presentation/general_widgets/loading_spinner/loading_circle.dart';
import 'package:wifi_smart_living/theme.dart';

import '../../../api_handler/api_treiber/sync/sync_database_entries.dart';
import '../../../const/const_location.dart';

class SetRoomNamePage extends StatelessWidget {
  final String roomImageName;
  final TextEditingController textEditingController = TextEditingController();
  late LoadingCicle loadingCicle;

  SetRoomNamePage({super.key, required this.roomImageName});

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    loadingCicle = LoadingCicle(context: context);
    return BlocConsumer<AddNewThermostatBloc, AddNewThermostatState>(
      listener: (context, state) {
        if (state is SaveRoomInDatabaseResponse) {
          loadingCicle.animationDismiss();
          CreateRoomState roomState = state.createRoomState;
          if (roomState == CreateRoomState.roomSuccesfullCreated) {
            //Datenbank Sync aufrufen
            Provider.of<DatabaseSync>(context, listen: false)
                .syncDatabase(ConstLocationidentifier.locationidentifierIndoor);

            InformationAlert().showAlertDialog(
                context: context,
                message: local.roomSuccesfulCreated,
                callback: () {
                  Navigator.of(context).pop();
                });
          } else if (roomState == CreateRoomState.noInternetConnection) {
            InformationAlert().showAlertDialog(
                context: context,
                message: local.noInternetConnectionAvaialable,
                callback: () {});
          } else {
            InformationAlert().showAlertDialog(
                context: context,
                message: local.oopsError,
                callback: () {
                  Navigator.of(context).pop();
                });
          }
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: Dimens.sizedBoxDefault,
            ),
            Text(
              local.setRoomName,
              style: AppTheme.textStyleColored,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: Dimens.sizedBoxBigDefault,
            ),
            Image.asset(
              'assets/images/$roomImageName',
              width: 180,
              height: 130,
            ),
            const SizedBox(
              height: Dimens.sizedBoxBigDefault,
            ),
            EditNameTextInput(
                emailController: textEditingController,
                hintText: local.hintKitchen),
            const Spacer(),
            ClickButtonFilled(
                buttonText: local.save,
                buttonFunktion: () {
                  if (textEditingController.text.isEmpty) {
                    InformationAlert().showAlertDialog(
                        context: context,
                        message: local.setRoomName,
                        callback: () {});
                  } else {
                    loadingCicle.showAnimation(local.createRoomInProgres);
                    BlocProvider.of<AddNewThermostatBloc>(context).add(
                        SaveNewRoomInDatabase(
                            roomName: textEditingController.text));
                  }
                },
                width: double.infinity),
            const SizedBox(
              height: 10,
            ),
          ],
        );
      },
    );
  }
}
