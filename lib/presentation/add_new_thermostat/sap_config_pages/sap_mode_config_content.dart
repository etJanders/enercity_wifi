import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/presentation/add_new_thermostat/sap_config_pages/sap_mode_config_error.dart';
import 'package:wifi_smart_living/presentation/add_new_thermostat/sap_config_pages/sap_mode_config_in_progress.dart';
import 'package:wifi_smart_living/presentation/general_widgets/click_buttons/click_button_colored.dart';
import 'package:wifi_smart_living/sap_interaction/sap_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../bloc/add_new_thermostat/add_new_thermostat_bloc.dart';
import '../../alert_dialogs/alert_dialog_information.dart';

class SapModeConfigContent extends StatefulWidget {
  final Function next;
  final Function tryAgain;

  const SapModeConfigContent(
      {super.key, required this.next, required this.tryAgain});

  @override
  State<SapModeConfigContent> createState() => _SapModeConfigContentState();
}

class _SapModeConfigContentState extends State<SapModeConfigContent> {
  //Wenn daten gesendet wurden, blende weiterbuttun ein
  bool dataSent = false;
  //Falls es einen Fehler gab, rufe sap fehler ansicht auf
  bool error = false;
  late String buttonText = "";

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    return BlocConsumer<AddNewThermostatBloc, AddNewThermostatState>(
      listener: (context, state) {

        if (state is SapConfigState) {
          SapState sapState = state.state;
          if (sapState == SapState.deviceSuccesfulConfigurated) {
            setState(() {
              buttonText = local.next;
              dataSent = true;
            });
          } else if (sapState == SapState.disableMobileData) {
            InformationAlert().showAlertDialog(
                context: context,
                message: local.turnOffMobileData,
                callback: () {
                  widget.tryAgain();
                });
          }

          else if (sapState == SapState.socketConnectionNotWorking) {
            setState(() {
              buttonText = local.startAgain;
              dataSent = true;
              error = true;
            });
          }


          else {
            setState(() {
              buttonText = local.tryAgain;
              dataSent = true;
              error = true;
            });
          }
        }else{
          print(state);
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(Dimens.paddingDefault),
          child: Column(
            children: [
              error
                  ? const SapModeConfigErrorView()
                  : SapModeConfigInProgress(
                      dataSent: dataSent,
                    ),
              const Spacer(),
              if (dataSent)
                ClickButtonFilled(
                    buttonText: buttonText,
                    buttonFunktion: () {
                      if (error) {
                        widget.tryAgain();
                      } else {
                        widget.next();
                      }
                    },
                    width: double.infinity)
            ],
          ),
        );
      },
    );
  }
}
