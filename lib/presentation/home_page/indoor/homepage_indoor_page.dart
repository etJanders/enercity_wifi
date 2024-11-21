import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mqtt_client/mqtt_client.dart';
import '../../../api_handler/api_treiber/sync/sync_database_entries.dart';
import '../../../bloc/delete_user_account/delete_user_account_bloc.dart';
import '../../../const/const_location.dart';
import '../../../main.dart';
import '../../../singelton/helper/mqtt_message_puffer.dart';
import '../../../singelton/mqtt_singelton.dart';
import '../../../theme.dart';
import '../../app_settings/app_settings_page.dart';
import '../../heatingProfile/heating_profile_overview/heating_profile_overview_page.dart';
import '../../holiday/overview/holiday_profile_overview_page.dart';
import '../../room_overview/indoor/indoor_room_overview_page.dart';

///Description
///Manage all bottom navigation menu option points of the main view
///
///Author: J. Anders
///created: 06-01-2023
///changed: 06-01-2023
///
///History:
///
///Notes:
/// WidgetsBindingObserver helps to control lifecycle
class HomepageIndoorPage extends StatefulWidget with WidgetsBindingObserver {
  static const String routName = "/homepage_indoor_page";

  const HomepageIndoorPage({super.key});

  @override
  State<HomepageIndoorPage> createState() => _HomepageIndoorPageState();
}

class _HomepageIndoorPageState extends State<HomepageIndoorPage>
    with WidgetsBindingObserver, RouteAware {
  //gibt an, welche view ueber die bottom navigation bar angezeigt wird
  int _currentIndex = 0;
  bool onPaused = false;

  late List<BottomNavigationBarItem> noRoomsBottomNavigation = [];
  late List<BottomNavigationBarItem> roomsAddedBottomNavigation = [];

  ///Widgets die angezeigt werden, wenn keine Räume in der Datenbank vorhanden sind
  final List<Widget> noRooms = [
    IndoorRoomOverviewPage(),
    AppSettingsPage(),
  ];

  ///Widgets die angezeigt werden, wenn Räume in der Datenbank vorhanden sind
  ///
  final List<Widget> roomsAdded = [
    IndoorRoomOverviewPage(),
    const HeatingprofileOverviewPage(),
    const HolidayProfileOverviewPage(),
    AppSettingsPage(),
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    //Rufe ein Datenbank sync auf
    context
        .read<DatabaseSync>()
        .syncDatabase(ConstLocationidentifier.locationidentifierIndoor);

    context.read<DatabaseSync>().fetchPopUpValues();

    MqttConnectionState state = MqttSingelton().getMqttConnectionSate();
    if (state != MqttConnectionState.connected ||
        state != MqttConnectionState.connecting) {
      MqttSingelton().startConnection().then((value) {});
    }

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    if (!onPaused) {
      context
          .read<DatabaseSync>()
          .syncDatabase(ConstLocationidentifier.locationidentifierIndoor);
      MqttConnectionState state = MqttSingelton().getMqttConnectionSate();

      if (state != MqttConnectionState.connected ||
          state != MqttConnectionState.connecting) {
        MqttSingelton().startConnection().then((value) {});
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      context
          .read<DatabaseSync>()
          .syncDatabase(ConstLocationidentifier.locationidentifierIndoor);
      onPaused = false;
      MqttConnectionState connectionState =
          MqttSingelton().getMqttConnectionSate();
      if (connectionState != MqttConnectionState.connected ||
          connectionState != MqttConnectionState.connecting) {
        MqttSingelton().startConnection().then((value) {});
      }
    } else if (state == AppLifecycleState.paused) {
      //context.read<DatabaseSync>().enableSyncAnimation();
      MqttSingelton().closeMqttConnection();
      MqttMessagePuffer().cleanPuffer();
      onPaused = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    noRoomsBottomNavigation = [
      BottomNavigationBarItem(
          icon: const ImageIcon(AssetImage("assets/images/home_ansicht.png")),
          label: local.atHomeMenu),
      BottomNavigationBarItem(
          icon: const ImageIcon(
            AssetImage("assets/images/einstellungen_ansicht.png"),
          ),
          label: local.settings)
    ];
    roomsAddedBottomNavigation = [
      BottomNavigationBarItem(
          icon: const ImageIcon(AssetImage("assets/images/home_ansicht.png")),
          label: local.atHomeMenu),
      BottomNavigationBarItem(
          icon:
              const ImageIcon(AssetImage("assets/images/heizprofil_menu.png")),
          label: local.timeSchedule),
      BottomNavigationBarItem(
          icon: const ImageIcon(AssetImage("assets/images/holiday_menu.png")),
          label: local.holidayProfile),
      BottomNavigationBarItem(
          icon: const ImageIcon(
            AssetImage("assets/images/einstellungen_ansicht.png"),
          ),
          label: local.settings)
    ];
    return BlocProvider(
      create: (context) => DeleteDatabaseEntriesBloc(),
      child: Scaffold(
        body: Stack(
          children: [
            IndexedStack(
              index: _currentIndex,
              children: context
                      .watch<DatabaseSync>()
                      .singelton
                      .getModelGroupManagement
                      .isEmpty
                  ? noRooms
                  : roomsAdded,
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppTheme.hintergrund,
          selectedItemColor: AppTheme.violet,
          unselectedItemColor: AppTheme.textDarkGrey,
          onTap: (value) {
            setState(() {
              _currentIndex = value;
            });
          },
          currentIndex: _currentIndex,
          items: context
                  .watch<DatabaseSync>()
                  .singelton
                  .getModelGroupManagement
                  .isEmpty
              ? noRoomsBottomNavigation
              : roomsAddedBottomNavigation,
        ),
      ),
    );
  }
}
