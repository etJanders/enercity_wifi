import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_smart_living/presentation/add_new_thermostat/sap_config_pages/sap_mode_config_content.dart';
import '../../../bloc/add_new_thermostat/add_new_thermostat_bloc.dart';

class SapModeConfigPage extends StatelessWidget {
  final Function nextCallback;
  final Function tryAgainCallback;

  const SapModeConfigPage(
      {super.key, required this.nextCallback, required this.tryAgainCallback});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AddNewThermostatBloc>(context)
        .add(ConfigDevice(devicePort: 1233, mode: 0));
    return SapModeConfigContent(
      next: nextCallback,
      tryAgain: tryAgainCallback,
    );
  }
}
