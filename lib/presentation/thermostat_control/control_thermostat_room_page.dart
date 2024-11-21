import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_smart_living/bloc/thermostat_interaction/thermostat_interaction_bloc.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/models/database/model_group_management.dart';
import 'package:wifi_smart_living/presentation/general_widgets/back_button_widget/back_button_widget.dart';
import 'package:wifi_smart_living/presentation/room_thermostat_overview/room_thermostat_overview_page.dart';
import 'package:wifi_smart_living/presentation/thermostat_control/control_thermostat_room_content.dart';
import 'package:wifi_smart_living/singelton/mqtt_singelton.dart';
import 'package:wifi_smart_living/theme.dart';

///Description
///Show
class ControlThermostatRoomPage extends StatefulWidget {
  static const routName = '/control_thermostat_page';

  const ControlThermostatRoomPage({super.key});

  @override
  State<ControlThermostatRoomPage> createState() =>
      _ControlThermostatRoomPageState();
}

class _ControlThermostatRoomPageState extends State<ControlThermostatRoomPage>
    with WidgetsBindingObserver {
  late ModelGroupManagement management;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    MqttSingelton().removeCallback();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      //beende die ansicht, falls die app in den Hintergrund gedrückt wird
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    management =
        ModalRoute.of(context)!.settings.arguments as ModelGroupManagement;
    return BlocProvider(
      create: (context) => ThermostatInteractionBloc()
        ..add(GroupOrganizer(groupId: management.groupId)),
      child: Scaffold(
        backgroundColor: AppTheme.hintergrund,
        appBar: AppBar(
          leading: const BackButtonWidget(),
          backgroundColor: AppTheme.hintergrund,
          title: (Text(management.groupName)),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) =>
                              const RoomThermostatOverviewPage()),
                          settings:
                              RouteSettings(arguments: management.groupId)));
                },
                icon: const Icon(
                  Icons.menu,
                  color: AppTheme.violet,
                ))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(Dimens.paddingDefault),
          child: ControlThermostatRoomContent(groupManagement: management),
        ),
      ),
    );
  }
}
