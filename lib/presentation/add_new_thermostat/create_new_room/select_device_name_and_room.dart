import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/ja/check_tablet.dart';
import 'package:wifi_smart_living/presentation/alert_dialogs/alert_dialog_information.dart';
import 'package:wifi_smart_living/presentation/general_widgets/back_button_widget/back_button_widget.dart';
import 'package:wifi_smart_living/presentation/general_widgets/editTextWidgets/edit_name_text_widget.dart';

import '../../../bloc/add_new_thermostat/add_new_thermostat_bloc.dart';
import '../../../theme.dart';

class SelectDeviceNameAndRoom extends StatefulWidget {
  final Function nextCallback;
  const SelectDeviceNameAndRoom({super.key, required this.nextCallback});

  @override
  State<SelectDeviceNameAndRoom> createState() =>
      _SelectDeviceNameAndRoomState();
}

class _SelectDeviceNameAndRoomState extends State<SelectDeviceNameAndRoom> {
  final TextEditingController deviceNameEditing = TextEditingController();
  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    bool tablet = TabletHelper().isTablet(context: context);
    return BlocConsumer<AddNewThermostatBloc, AddNewThermostatState>(
      listener: (context, state) {
        if (state is DeviceNameAdded) {
          widget.nextCallback();
        }
      },
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            leading: const BackButtonWidget(),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  local.addDevice,
                ),
                Text(
                  local.deviceAndRoomName,
                  style: AppTheme.textStyleDefault,
                )
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(Dimens.paddingDefault),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                SizedBox(
                  width: 150,
                  height: 100,
                  child: GridTile(
                    footer: Container(
                      padding: tablet
                          ? const EdgeInsets.only(bottom: 40, left: 20)
                          : const EdgeInsets.only(left: Dimens.paddingDefault),
                      child: GridTileBar(
                        title: Text(
                          local.createNewRoom,
                          textAlign: TextAlign.start,
                          style: tablet
                              ? AppTheme.textStyleWhiteTablet
                              : AppTheme.textStyleWhite,
                        ),
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        if (deviceNameEditing.text.isEmpty) {
                          InformationAlert().showAlertDialog(
                              context: context,
                              message: local.setThermostatName,
                              callback: () {});
                        } else {
                          BlocProvider.of<AddNewThermostatBloc>(context).add(
                              DeviceNameSelected(
                                  deviceName: deviceNameEditing.text));
                        }
                      },
                      child: Image.asset("assets/images/add_device.png"),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
