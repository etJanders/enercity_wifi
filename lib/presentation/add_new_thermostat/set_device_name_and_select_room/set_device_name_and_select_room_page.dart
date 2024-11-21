// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wifi_smart_living/api_handler/api_treiber/sync/sync_database_entries.dart';
import 'package:wifi_smart_living/const/const_location.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/models/database/model_group_management.dart';
import 'package:wifi_smart_living/presentation/add_new_thermostat/set_device_name_and_select_room/select_room_grid.dart';
import 'package:wifi_smart_living/presentation/alert_dialogs/alert_dialog_information.dart';
import 'package:wifi_smart_living/presentation/general_widgets/click_buttons/click_button_colored.dart';
import 'package:wifi_smart_living/presentation/general_widgets/loading_spinner/loading_circle.dart';
import 'package:wifi_smart_living/theme.dart';

import '../../../api_handler/api_treiber/create_new_room/create_new_room_helper.dart';
import '../../../bloc/add_new_thermostat/add_new_thermostat_bloc.dart';
import '../../general_widgets/editTextWidgets/edit_name_text_widget.dart';

class SetDeviceNameAndSelectRoomPage extends StatefulWidget {
  final Function nextCallback;

  const SetDeviceNameAndSelectRoomPage({super.key, required this.nextCallback});

  @override
  State<SetDeviceNameAndSelectRoomPage> createState() =>
      _SetDeviceNameAndSelectRoomPageState();
}

class _SetDeviceNameAndSelectRoomPageState
    extends State<SetDeviceNameAndSelectRoomPage> {
  final TextEditingController deviceNameEditing = TextEditingController();

  ModelGroupManagement? groupManagement;

  late LoadingCicle loadingCicle;

  late BuildContext buildContext;

  late AppLocalizations local;

  @override
  void initState() {
    loadingCicle = LoadingCicle(context: context);
    BlocProvider.of<AddNewThermostatBloc>(context).add(IntroduceDelay());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    AppLocalizations local = AppLocalizations.of(context)!;

    var provider = Provider.of<DatabaseSync>(context);
    return BlocConsumer<AddNewThermostatBloc, AddNewThermostatState>(
      listener: (context, state) {
        if (state is DeviceNameAdded) {
          widget.nextCallback();
        } else if (state is DelayState) {
          loadingCicle.showAnimation(local.loading);
        } else if (state is DelayFinished) {
          loadingCicle.animationDismiss();
        } else if (state is SaveRoomInDatabaseResponse) {
          loadingCicle.animationDismiss();
          CreateRoomState responseState = state.createRoomState;
          if (responseState == CreateRoomState.deviceSuccessfullAdded) {
            InformationAlert().showAlertDialog(
                context: context,
                message: local.thermostatSuccesfulAdded,
                callback: () {
                  provider.syncDatabase(
                      ConstLocationidentifier.locationidentifierIndoor);
                  Navigator.of(context).pop();
                });
          } else if (responseState == CreateRoomState.noInternetConnection) {
            InformationAlert().showAlertDialog(
                context: context,
                message: local.noInternetConnectionAvaialable,
                callback: () {});
          } else {
            //Todo error handling
            print("In else part");
            print(responseState);
          }
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(Dimens.paddingDefault),
          child: Column(
            children: [
              const SizedBox(
                height: Dimens.sizedBoxDefault,
              ),
              Text(
                local.setDeviceName,
                style: AppTheme.textStyleColored,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: Dimens.sizedBoxDefault,
              ),
              EditNameTextInput(
                  emailController: deviceNameEditing, hintText: 'Comet WiFi'),
              const SizedBox(
                height: Dimens.sizedBoxBigDefault,
              ),
              Expanded(child: SelectRoomGrid(roomSelected: roomSelected)),
              const SizedBox(
                height: Dimens.sizedBoxDefault,
              ),
              ClickButtonFilled(
                  buttonText: local.save,
                  buttonFunktion: () {
                    if (deviceNameEditing.text.isEmpty) {
                      InformationAlert().showAlertDialog(
                          context: context,
                          message: local.setDeviceNameError,
                          callback: () {});
                    } else if (groupManagement == null) {
                      InformationAlert().showAlertDialog(
                          context: context,
                          message: local.selectRoom,
                          callback: () {});
                    } else {
                      loadingCicle.showAnimation(local.addThermostat);
                      BlocProvider.of<AddNewThermostatBloc>(context).add(
                          AddDeviceToARoom(
                              groupId: groupManagement!.groupId,
                              deviceName: deviceNameEditing.text));
                    }
                  },
                  width: double.infinity)
            ],
          ),
        );
      },
    );
  }

  void roomSelected(ModelGroupManagement management) {
    AppLocalizations local = AppLocalizations.of(buildContext)!;

    if (management.groupId.isEmpty) {
      if (deviceNameEditing.text.isEmpty) {
        try {
          InformationAlert().showAlertDialog(
              context: buildContext,
              message: local.setDeviceNameError,
              callback: () {});
        } catch (e) {
          print(e);
        }
      } else {
        //Erstelle einen neuen Raum in der Datenbank
        BlocProvider.of<AddNewThermostatBloc>(buildContext)
            .add(DeviceNameSelected(deviceName: deviceNameEditing.text));
      }
    } else {
      //Ein bestehender Raum wurde ausgrwählt
      groupManagement = management;
    }
  }

  void addDelay() {}
}
