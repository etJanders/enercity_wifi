// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_smart_living/presentation/home_page/indoor/homepage_indoor_page.dart';
import 'package:wifi_smart_living/presentation/room_thermostat_overview/room_thermostat_overview_content.dart';
import '../../bloc/delete_user_account/delete_user_account_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../general_widgets/back_button_widget/back_button_widget.dart';

class RoomThermostatOverviewPage extends StatefulWidget {
  static const routName = "/room_overview_thermostat";
  const RoomThermostatOverviewPage({super.key});

  @override
  State<RoomThermostatOverviewPage> createState() =>
      _RoomThermostatOverviewPageState();
}

class _RoomThermostatOverviewPageState extends State<RoomThermostatOverviewPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      //beende die ansicht, falls die app in den Hintergrund gedrückt wird
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: ((context) => const HomepageIndoorPage())),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    final groupId = ModalRoute.of(context)!.settings.arguments as String;
    return BlocProvider(
      create: (context) => DeleteDatabaseEntriesBloc(),
      child: Scaffold(
        appBar: AppBar(
          leading: const BackButtonWidget(),
          title: Text(local.deviceControl),
        ),
        body: RoomThermostatOverviewContent(
          groupId: groupId,
        ),
      ),
    );
  }
}
