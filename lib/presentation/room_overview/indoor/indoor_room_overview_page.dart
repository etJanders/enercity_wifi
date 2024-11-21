// ignore_for_file: must_be_immutable, use_build_context_synchronously
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wifi_smart_living/presentation/add_new_thermostat/add_new_thermostat.dart';
import 'package:wifi_smart_living/presentation/alert_dialogs/alert_dialog_information.dart';
import 'package:wifi_smart_living/presentation/general_widgets/add_button_app_bar/app_bar_add_widget.dart';
import 'package:wifi_smart_living/presentation/room_overview/indoor/indoor_room_overview_grid.dart';
import 'package:wifi_smart_living/singelton/api_singelton.dart';
import 'package:wifi_smart_living/theme.dart';

import '../../../api_handler/api_treiber/sync/sync_database_entries.dart';
import '../../../const/const_sharedpreference_storage.dart';
import '../../../helper/userSpecificPopUpHelper/user_pop_up_helper.dart';
import '../../alert_dialogs/alert_dialog_with_title_yes_no.dart';
import '../../general_widgets/loading_spinner/loading_circle.dart';

///Description
///Show all rooms are ordert to location indoor
///
///Author: J. Anders
///created: 30-11-2022
///changed: 30-11-2022
///
///History:
///
///
///Notes:
///
///26:5a:4c:14:1a:f (ios mac example)
///
class IndoorRoomOverviewPage extends StatelessWidget {
  late LoadingCicle loadingCicle;
  IndoorRoomOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    loadingCicle = LoadingCicle(context: context);
    AppLocalizations local = AppLocalizations.of(context)!;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var popUpHelper = PopUpHelper();
// TODO: changed by tismo to fix error on 01 Aug 2024
      if (popUpHelper.popUpDisplayStatus &&
          !(Provider.of<DatabaseSync>(context, listen: false)
                  .getDatabaseSyncState ==
              DatabaseSyncState.syncInProgress)) {
        if (await getPopUpStatus() && popUpHelper.popUpStatus == true) {
          setPopUpValues(popUpHelper.titleGerman, popUpHelper.titleEnglish,
              popUpHelper.messageGerman, popUpHelper.messageEnglish);
          popUpHelper.popUpDisplayStatus = false;
          AlertDialogTitleYesNo()
              .zeigeDialogs(
                  context: context,
                  title: local.languageCode == 'de'
                      ? popUpHelper.titleGerman
                      : popUpHelper.titleEnglish,
                  message: local.languageCode == 'de'
                      ? popUpHelper.messageGerman
                      : popUpHelper.messageEnglish,
                  positiveButtontext: local.okay,
                  doNotShow: local.doNotShowAgain)
              .then((value) {
            setPopUpStatus(PopUpHelper().statusIntermediateCheckbox);
          });
        } else if (await getPopUpStatus() == false &&
            (await comparePopUpValues(
                    popUpHelper.titleEnglish, popUpHelper.messageEnglish) ==
                true)) {
          setPopUpValues(popUpHelper.titleGerman, popUpHelper.titleEnglish,
              popUpHelper.messageGerman, popUpHelper.messageEnglish);
          popUpHelper.popUpDisplayStatus = false;

          AlertDialogTitleYesNo()
              .zeigeDialogs(
            context: context,
            title: local.languageCode == 'de'
                ? popUpHelper.titleGerman
                : popUpHelper.titleEnglish,
            message: local.languageCode == 'de'
                ? popUpHelper.messageGerman
                : popUpHelper.messageEnglish,
            positiveButtontext: local.okay,
            doNotShow: local.doNotShowAgain,
          )
              .then((value) {
            setPopUpStatus(popUpHelper.statusIntermediateCheckbox);
          });
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(local.myHome),
            Text(
              local.targetTemperature,
              style: const TextStyle(
                color: AppTheme.textDarkGrey,
                fontSize: 14,
              ),
            )
          ],
        ),
        actions: [
          AddWidget(onPressCallback: () {
            permissionHandling(context, local.allawLocationPermission);
          }),
        ],
      ),
      body: context.watch<DatabaseSync>().getDatabaseSyncState ==
                  DatabaseSyncState.syncInProgress &&
              ApiSingelton().getModelGroupManagement.isEmpty
          ? loadingCicle.showAlertDialog(local.databaseSynchronisation)
          : const IndoorRoomOverviewGrid(),
    );
  }

  void permissionHandling(BuildContext context, String locationMessage) async {
    AppLocalizations local = AppLocalizations.of(context)!;
    void showAlertDialog(List<Widget> actions) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(local.allawLocationPermission),
            actions: actions,
          );
        },
      );
    }

    PermissionStatus permissionStatus = await Permission.location.status;

    if (permissionStatus == PermissionStatus.granted) {
      bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();

      if (isLocationEnabled) {
        if (Platform.isIOS) {
          try {
            var deviceIp = await NetworkInfo().getWifiIP();
            await Socket.connect(deviceIp, 80,
                timeout: const Duration(milliseconds: 100));
          } catch (e) {
            print('Exception..');
          }
        }
        Navigator.of(context).pushNamed(AddNewThermostatViewPage.routName);
      } else {
        showAlertDialog(
          [
            TextButton(
              child: Text(local.openSettings),
              onPressed: () {
                Geolocator.openLocationSettings();
              },
            ),
            TextButton(
              child: Text(local.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    } else {
      PermissionStatus newStatus = await Permission.location.request();

      if (newStatus == PermissionStatus.granted) {
        bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();

        if (isLocationEnabled) {
          if (Platform.isIOS) {
            try {
              var deviceIp = await NetworkInfo().getWifiIP();
              await Socket.connect(deviceIp, 80,
                  timeout: const Duration(milliseconds: 100));
            } catch (e) {
              print('Exception..');
            }
          }
          Navigator.of(context).pushNamed(AddNewThermostatViewPage.routName);
        } else {
          showAlertDialog(
            [
              TextButton(
                child: Text(local.openSettings),
                onPressed: () {
                  Geolocator.openLocationSettings();
                },
              ),
              TextButton(
                child: Text(local.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
      } else if (newStatus == PermissionStatus.denied) {
        InformationAlert().showAlertDialog(
          context: context,
          message: locationMessage,
          callback: () {},
        );
      } else if (newStatus == PermissionStatus.permanentlyDenied) {
        showAlertDialog(
          [
            TextButton(
              child: Text(local.openSettings),
              onPressed: () {
                openAppSettings();
              },
            ),
            TextButton(
              child: Text(local.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    }
  }

  Future<bool> getPopUpStatus() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    bool popUpPreference =
        sp.getBool(ConstSharedPreferenceNames.keySpecific) ?? false;
    //sp.setBool(ConstSharedPreferenceNames.keySpecific,false);

    return !popUpPreference;
  }

  void setPopUpStatus(bool status) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setBool(ConstSharedPreferenceNames.keySpecific, status);
  }

  void setPopUpValues(
      String titleDe, String title, String messageDe, String message) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setString(ConstSharedPreferenceNames.titleGermanSpecific, titleDe);
    await sp.setString(ConstSharedPreferenceNames.titleEnglishSpecific, title);
    await sp.setString(
        ConstSharedPreferenceNames.messageGermanSpecific, messageDe);
    await sp.setString(
        ConstSharedPreferenceNames.messageEnglishSpecific, message);
  }

  Future<bool> comparePopUpValues(String messageFromApi, titleFromApi) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String title =
        sp.getString(ConstSharedPreferenceNames.titleEnglishSpecific) ?? "";
    String message =
        sp.getString(ConstSharedPreferenceNames.messageEnglishSpecific) ?? "";
    if ((titleFromApi == title) && (messageFromApi == message)) {
      return true;
    }

    return false;
  }
}
