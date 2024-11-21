// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wifi_smart_living/api_handler/api_treiber/sync/sync_database_entries.dart';
import 'package:wifi_smart_living/bloc/edit_ui_structures/edit_ui_structures_bloc.dart';
import 'package:wifi_smart_living/const/const_location.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/models/database/model_device_manaagement.dart';
import 'package:wifi_smart_living/presentation/alert_dialogs/alert_dialog_information.dart';
import 'package:wifi_smart_living/presentation/general_widgets/back_button_widget/back_button_widget.dart';
import 'package:wifi_smart_living/presentation/general_widgets/click_buttons/click_button_colored.dart';
import 'package:wifi_smart_living/presentation/general_widgets/editTextWidgets/edit_name_text_widget.dart';
import 'package:wifi_smart_living/presentation/general_widgets/image_container/home_image.dart';
import 'package:wifi_smart_living/presentation/general_widgets/loading_spinner/loading_circle.dart';
import 'package:wifi_smart_living/singelton/helper/api_name_helper.dart';
import 'package:wifi_smart_living/theme.dart';

import '../../../api_handler/api_treiber/update_ui_components/update_ui_components_helper.dart';

class EditThermostatContent extends StatelessWidget {
  late TextEditingController textEditingController;
  final ModelDeviceManagament managament;

  EditThermostatContent({
    super.key,
    required this.managament,
  });

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    textEditingController = TextEditingController();
    textEditingController.text = managament.deviceName;
    LoadingCicle loadingCicle = LoadingCicle(context: context);
    return BlocConsumer<EditUiStructuresBloc, EditUiStructuresState>(
      listener: (context, state) {
        loadingCicle.animationDismissWithDelay();
        if (state is UpdateUiComponentBlocState) {
          UpdateUIComponentState updateState = state.state;
          if (updateState == UpdateUIComponentState.entrySuccesfulChanged) {
            context
                .read<DatabaseSync>()
                .syncDatabase(ConstLocationidentifier.locationidentifierIndoor);
            InformationAlert().showAlertDialog(
                context: context,
                message: local.thermostatNameSuccesfulChanged,
                callback: () {
                  Navigator.of(context).pop();
                });
          } else if (updateState ==
              UpdateUIComponentState.noInternetConnection) {
            InformationAlert().showAlertDialog(
                context: context,
                message: local.noInternetConnectionAvaialable,
                callback: () {});
          } else {
            InformationAlert().showAlertDialog(
                context: context, message: local.oopsError, callback: () {});
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            leading: const BackButtonWidget(),
            title: Text(local.changeThermostatName),
          ),
          body: Padding(
            padding: const EdgeInsets.all(Dimens.paddingDefault),
            child: Column(
              children: [
                const SizedBox(
                  height: Dimens.sizedBoxDefault,
                ),
                const HomeImage(),
                const SizedBox(
                  height: Dimens.sizedBoxBigDefault,
                ),
                Text(
                  local.changeNameOfThermostat,
                  style: AppTheme.textStyleDefault,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: Dimens.sizedBoxBigDefault,
                ),
                EditNameTextInput(
                    emailController: textEditingController,
                    hintText: 'Comet WiFi'),
                const Spacer(),
                ClickButtonFilled(
                    buttonText: local.save,
                    buttonFunktion: () {
                      if (textEditingController.text.isNotEmpty) {
                        if (ApiNameHelper().deviceNameInUse(
                            newDeviceName: textEditingController.text)) {
                          //thermostatNameInUse
                          InformationAlert().showAlertDialog(
                              context: context,
                              message: local.thermostatNameInUse,
                              callback: () {});
                        } else {
                          loadingCicle.showAnimation(
                              local.changeThermostatNameInProgress);
                          managament.deviceName = textEditingController.text;
                          BlocProvider.of<EditUiStructuresBloc>(context).add(
                              UpdateUiComponents(databaseModel: managament));
                        }
                      } else {
                        InformationAlert().showAlertDialog(
                            context: context,
                            message: local.thermostatNameMissing,
                            callback: () {});
                      }
                    },
                    width: double.infinity),
              ],
            ),
          ),
        );
      },
    );
  }
}
