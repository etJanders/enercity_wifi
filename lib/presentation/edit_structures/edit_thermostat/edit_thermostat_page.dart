import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_smart_living/bloc/edit_ui_structures/edit_ui_structures_bloc.dart';
import 'package:wifi_smart_living/models/database/model_device_manaagement.dart';
import 'package:wifi_smart_living/presentation/edit_structures/edit_thermostat/edit_thermostat_content.dart';

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
class EditThermostatNamePage extends StatelessWidget {
  static const String routName = '/edit_thermostat_name';
  const EditThermostatNamePage({super.key});

  @override
  Widget build(BuildContext context) {
    ModelDeviceManagament managament =
        ModalRoute.of(context)!.settings.arguments as ModelDeviceManagament;
    return BlocProvider(
      create: (context) => EditUiStructuresBloc(),
      child: EditThermostatContent(
        managament: managament,
      ),
    );
  }
}
