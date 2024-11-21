import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import 'package:wifi_smart_living/api_handler/api_treiber/delete_room_helper/delete_room_helper.dart';
import 'package:wifi_smart_living/api_handler/api_treiber/sync/sync_database_entries.dart';
import 'package:wifi_smart_living/bloc/delete_user_account/delete_user_account_bloc.dart';
import 'package:wifi_smart_living/const/const_schedule_id.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/helper/credentials_wrong/credentials_changed_helper.dart';
import 'package:wifi_smart_living/mqtt/broker_fallback/broker_url_helper.dart';
import 'package:wifi_smart_living/presentation/alert_dialogs/alert_dialog_credentials_changed.dart';
import 'package:wifi_smart_living/presentation/alert_dialogs/alert_dialog_information.dart';
import 'package:wifi_smart_living/presentation/alert_dialogs/alert_dialog_yes_no.dart';
import 'package:wifi_smart_living/presentation/edit_structures/edit_room/edit_room_page.dart';
import 'package:wifi_smart_living/presentation/general_widgets/loading_spinner/loading_circle.dart';
import 'package:wifi_smart_living/presentation/login/login_page.dart';
import 'package:wifi_smart_living/presentation/thermostat_control/control_thermostat_room_page.dart';
import 'package:wifi_smart_living/singelton/helper/api_singelton_helper.dart';
import 'package:wifi_smart_living/theme.dart';

import '../../../const/const_location.dart';
import '../../../models/database/model_group_management.dart';
import '../../../provider/edit_room_provider.dart';
import '../../../singelton/helper/mqtt_message_puffer.dart';
import '../../general_widgets/popup_menu/popup_menu_widget.dart';
import '../general_widgets/indoor_room_overview_grid_tile.dart';

///Description
///Show all rooms are orderd to indoor location
///
///Author: J. Anders
///created: 30-11-2022
///changed: 02-02-2023
///
///History:
///02-02-2023: Implement Swipe Refresh
///
///Notes:
///
class IndoorRoomOverviewGrid extends StatefulWidget {
  const IndoorRoomOverviewGrid({super.key});

  @override
  State<IndoorRoomOverviewGrid> createState() => _IndoorRoomOverviewGridState();
}

class _IndoorRoomOverviewGridState extends State<IndoorRoomOverviewGrid> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  late List<ModelGroupManagement> meineRaeume = [];
  late LoadingCicle loadingCicle;

  @override
  Widget build(BuildContext context) {
    loadingCicle = LoadingCicle(context: context);
    meineRaeume = context
        .watch<DatabaseSync>()
        .helper
        .groupManagementsByLocation(
            ConstLocationidentifier.locationidentifierIndoorInt);
    AppLocalizations local = AppLocalizations.of(context)!;
    return BlocConsumer<DeleteDatabaseEntriesBloc, DeleteDatabaseEntriesState>(
      listener: (context, state) {
        if (state is ShowLoadingSpinner) {
          if (state.showLoadingSpinner) {
            loadingCicle.showAnimation(local.deleteRoom);
          } else {
            loadingCicle.animationDismissWithDelay();
          }
        } else if (state is DeleteRoomFromDatabaseState) {
          DeleteEntryState responseState = state.state;
          if (responseState == DeleteEntryState.roomSuccesfulDeleted) {
            Provider.of<DatabaseSync>(context, listen: false)
                .syncDatabase(ConstLocationidentifier.locationidentifierIndoor);
          } else if (responseState == DeleteEntryState.userCredentialsChanged) {
            InformationAlert().showAlertDialog(
                context: context,
                message: local.loginDataChanged,
                callback: () {
                  CredentialsChangedHelper().crdentialsChanged(context);
                });
          } else {
            InformationAlert().showAlertDialog(
                context: context, message: local.oopsError, callback: () {});
          }
        }
      },
      builder: (context, state) {
        return context.watch<DatabaseSync>().getDatabaseSyncState ==
                DatabaseSyncState.credentialsWrong
            ? Center(
                child: AlertDialogCredentialsChanged()
                    .showAlertDialogWidget(context, () {
                  Navigator.of(context).popAndPushNamed(LoginPage.routName);
                }),
              )
            : context
                    .watch<DatabaseSync>()
                    .helper
                    .groupManagementsByLocation(
                        ConstLocationidentifier.locationidentifierIndoorInt)
                    .isEmpty
                ? Center(
                    child: Text(
                      local.noThermostatAdded,
                      style: AppTheme.textStyleDefault,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(Dimens.paddingDefault),
                    child: RefreshIndicator(
                      key: _refreshIndicatorKey,
                      onRefresh: () async {
                        final databaseSync = context.read<DatabaseSync>();
                        await BrokerUrlHelper().clearDefaultUrl();
                        return databaseSync.syncDatabase(
                            ConstLocationidentifier.locationidentifierIndoor);
                      },
                      child: ReorderableGridView.builder(
                        itemCount: meineRaeume.length,
                        onReorder: ((oldIndex, newIndex) {
                          context
                              .read<DatabaseSync>()
                              .updateRoomUiPosition(oldIndex, newIndex);
                        }),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 3 / 2,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20),
                        itemBuilder: ((context, index) => RoomOverviewGridTile(
                            key: ValueKey(meineRaeume[index].entryPublicId),
                            groupName: meineRaeume[index].groupName,
                            image: meineRaeume[index].groupImage,
                            //image: 'add_device.png',
                            onTapCallback: () {
                              if (context
                                  .read<DatabaseSync>()
                                  .helper
                                  .getDevicesByGroupId(
                                      groupId: meineRaeume[index].groupId)
                                  .isNotEmpty) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            const ControlThermostatRoomPage()),
                                        settings: RouteSettings(
                                            arguments: meineRaeume[index])));
                              } else {
                                InformationAlert().showAlertDialog(
                                    context: context,
                                    message: local.noThermostatInTheRoom,
                                    callback: () {});
                              }
                            },
                            menuOptionCalled: (value) {
                              _editOrRemoveRoom(context, value, index);
                            },
                            batterie: meineRaeume.isNotEmpty
                                ? ApiSingeltonHelper().batterieEmpty(
                                    groupId: meineRaeume[index].groupId)
                                : false,
                            //warum wird hier nur auf mqtt gehorcht?
                            sollTemperatur: meineRaeume.isNotEmpty
                                ? context
                                    .watch<MqttMessagePuffer>()
                                    .getTemperature(meineRaeume[index])
                                : 'NA',
                            heatingProfile: meineRaeume.isNotEmpty
                                ? context.watch<DatabaseSync>().helper.roomWithScheduledProfile(
                                    scheduleId:
                                        ConstScheduleId.timeScheduleProfileId,
                                    groupid: meineRaeume[index].groupId)
                                : false,
                            holidayProfile: meineRaeume.isNotEmpty
                                ? (context.watch<DatabaseSync>().helper.roomWithScheduledProfile(
                                        scheduleId: ConstScheduleId
                                            .holidayProfileScheduleId,
                                        groupid: meineRaeume[index].groupId)) &&
                                    (context
                                        .watch<MqttMessagePuffer>()
                                        .getHolidayProfileActive(
                                            meineRaeume[index]))
                                : false,
                            activeHeatingProfile: ApiSingeltonHelper()
                                .getFlags(groupId: meineRaeume[index].groupId)
                                .operationMode,
                            errorProfile: context
                                .watch<MqttMessagePuffer>()
                                .getErrorProfile(meineRaeume[index]),
                            windowOpen: context
                                .watch<MqttMessagePuffer>()
                                .getWindowDetectionProfile(meineRaeume[index]))),
                      ),
                    ),
                  );
      },
    );
  }

  void _editOrRemoveRoom(
      BuildContext context, PopupMenuOption id, int index) async {
    AppLocalizations local = AppLocalizations.of(context)!;
    if (id == PopupMenuOption.editOption) {
      context
          .read<EditRoomProvider>()
          .initEditRoomProvider(management: meineRaeume[index]);
      Navigator.of(context).pushNamed(EditRoomStructurePage.routName);
    } else if (id == PopupMenuOption.deleteOption) {
      await AlertDialogYesNo()
          .zeigeDialog(
              context: context,
              message: local.deleteRoomText,
              positiveButtontext: local.delete,
              negativeButtonText: local.cancel)
          .then((value) {
        if (value) {
          BlocProvider.of<DeleteDatabaseEntriesBloc>(context)
              .add(DeleteRoomFromDatabase(groupId: meineRaeume[index].groupId));
        }
      });
    }
  }
}
