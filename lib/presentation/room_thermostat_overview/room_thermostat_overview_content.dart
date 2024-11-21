// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:wifi_smart_living/presentation/edit_structures/edit_thermostat/edit_thermostat_page.dart';
import 'package:wifi_smart_living/presentation/general_widgets/popup_menu/popup_menu_widget.dart';
import 'package:wifi_smart_living/presentation/room_thermostat_overview/room_thermostat_grid_tile.dart';
import 'package:wifi_smart_living/theme.dart';

import '../../api_handler/api_treiber/delete_room_helper/delete_room_helper.dart';
import '../../api_handler/api_treiber/sync/sync_database_entries.dart';
import '../../bloc/delete_user_account/delete_user_account_bloc.dart';
import '../../connectivity/network_connection_helper.dart';
import '../../const/const_location.dart';
import '../../dimens.dart';
import '../../models/database/model_device_manaagement.dart';
import '../../singelton/helper/api_singelton_helper.dart';
import '../../singelton/helper/mqtt_message_puffer.dart';
import '../alert_dialogs/alert_dialog_information.dart';
import '../alert_dialogs/alert_dialog_yes_no.dart';
import '../general_widgets/loading_spinner/loading_circle.dart';
import '../thermostat_settings/thermostat_settings_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

///Description
///Overview of all thermostats inside a room
///
///Author: J. Anders
///created: 17-01-2023
///changed: 17-01-2023
///
///History:
///
///Notes:
///
class RoomThermostatOverviewContent extends StatelessWidget {
  final String groupId;

  late List<ModelDeviceManagament> devices = [];

  RoomThermostatOverviewContent({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    LoadingCicle loadingCicle = LoadingCicle(context: context);
    var syncProvider = Provider.of<DatabaseSync>(context);
    devices = syncProvider.helper.getDevicesByGroupId(groupId: groupId);
    return BlocConsumer<DeleteDatabaseEntriesBloc, DeleteDatabaseEntriesState>(
      listener: (context, state) {
        if (state is ShowLoadingSpinner) {
          if (state.showLoadingSpinner) {
            loadingCicle.showAnimation(local.deleteDevice);
          } else {
            loadingCicle.animationDismissWithDelay();
          }
        } else if (state is DeleteDeviceFromDatabaseState) {
          DeleteEntryState responseState = state.state;
          if (responseState == DeleteEntryState.roomSuccesfulDeleted) {
            Provider.of<DatabaseSync>(context, listen: false)
                .syncDatabase(ConstLocationidentifier.locationidentifierIndoor);
          } else {
            InformationAlert().showAlertDialog(
                context: context, message: local.oopsError, callback: () {});
          }
        }
      },
      builder: (context, state) {
        return devices.isEmpty
            ? Center(
                child: Text(
                  local.noThermostatInTheRoom,
                  style: AppTheme.textStyleDefault,
                ),
              )
            : GridView.builder(
                padding: const EdgeInsets.all(Dimens.paddingDefault),
                itemCount: devices.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    childAspectRatio: 3 / 2,
                    mainAxisSpacing: 10),
                itemBuilder: ((context, index) => ThermostatOverviewGridTile(
                      thermostatName: devices[index].deviceName,
                      onTapCallback: () {
                        NetworkStateHelper.networkConnectionEstablished()
                            .then((value) {
                          if (value) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ThermostatSettingsPage(
                                        managament: devices[index])));
                          } else {
                            InformationAlert().showAlertDialog(
                                context: context,
                                message: local.noInternetConnectionAvaialable,
                                callback: () {});
                          }
                        });
                      },
                      batteryEmpty: ApiSingeltonHelper()
                          .batteryEmpty(mac: devices[index].deviceMac),
                    errorProfile: context
                        .watch<MqttMessagePuffer>().getErrorProfileDeviceLevel(devices[index]),
                    windowOpen : context
                        .watch<MqttMessagePuffer>().getWindowDetectionProfileDeviceLevel(devices[index]),
                      menuOptionCalled: (id) {
                        editOrRemoveThermostat(context, id, index);
                      },
                    )),
              );
      },
    );
  }

  void editOrRemoveThermostat(
      BuildContext context, PopupMenuOption id, int index) async {
    AppLocalizations local = AppLocalizations.of(context)!;
    if (devices.isNotEmpty) {
      if (id == PopupMenuOption.editOption) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => const EditThermostatNamePage()),
                settings: RouteSettings(arguments: devices[index])));
      } else if (id == PopupMenuOption.deleteOption) {
        if(devices.length>1) {
          bool response = await AlertDialogYesNo().zeigeDialog(
              context: context,
              message: local.deleteDeviceConfirm,
              positiveButtontext: local.delete,
              negativeButtonText: local.cancel);
          if (response) {
            // ignore: use_build_context_synchronously
            BlocProvider.of<DeleteDatabaseEntriesBloc>(context).add(
                DeleteDeviceFromDatabase(macAdress: devices[index].deviceMac));
          }
        }else{
          InformationAlert().showAlertDialog(
              context: context,
              message: local.minimumRoomRequired,
              callback: () {});
        }
      }
    }
  }
}
