import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wifi_smart_living/bloc/thermostat_interaction/thermostat_interaction_bloc.dart';
import 'package:wifi_smart_living/models/database/model_device_manaagement.dart';
import 'package:wifi_smart_living/presentation/general_widgets/back_button_widget/back_button_widget.dart';
import 'package:wifi_smart_living/presentation/thermostat_settings/thermostat_settings_content.dart';
import 'package:wifi_smart_living/theme.dart';

///Description
///Display Thermostat attributes and help the user to change some specific settings
///
///Author: J. Anders
///created: 09-12-2022
///changed: 09-12-2022
///
///History:
///
///Notes:
class ThermostatSettingsPage extends StatefulWidget {
  final ModelDeviceManagament managament;

  const ThermostatSettingsPage({super.key, required this.managament});

  @override
  State<ThermostatSettingsPage> createState() => _ThermostatSettingsPageState();
}

class _ThermostatSettingsPageState extends State<ThermostatSettingsPage> {
  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (context) => ThermostatInteractionBloc(),
      child: Scaffold(
          backgroundColor: AppTheme.hintergrund,
          appBar: AppBar(
            leading: const BackButtonWidget(),
            backgroundColor: AppTheme.hintergrund,
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.managament.deviceName,
                  style: AppTheme.textStyleColored,
                ),
                Text(
                  local.settings,
                  style: AppTheme.textStyleDefault.copyWith(fontSize: 16.0),
                ),
              ],
            ),
          ),
          body: ThermostatSettingsContent(
            managament: widget.managament,
          )),
    );
  }
}
