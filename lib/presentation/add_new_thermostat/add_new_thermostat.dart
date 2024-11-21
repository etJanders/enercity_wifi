import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wifi_smart_living/bloc/add_new_thermostat/add_new_thermostat_bloc.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/presentation/add_new_thermostat/set_device_name_and_select_room/set_device_name_and_select_room_page.dart';
import 'package:wifi_smart_living/presentation/add_new_thermostat/view_pages/connect_to_thermostat_page.dart';
import 'package:wifi_smart_living/presentation/add_new_thermostat/view_pages/insert_batteries_page.dart';
import 'package:wifi_smart_living/presentation/add_new_thermostat/view_pages/mount_and_adap.dart';
import 'package:wifi_smart_living/presentation/add_new_thermostat/view_pages/pairing_mode_information_page.dart';
import 'package:wifi_smart_living/presentation/add_new_thermostat/view_pages/sap_mode_config_page.dart';
import 'package:wifi_smart_living/presentation/add_new_thermostat/view_pages/wifi_network_detection_page.dart';
import 'package:wifi_smart_living/presentation/general_widgets/back_button_widget/back_button_widget.dart';
import 'package:wifi_smart_living/theme.dart';

import 'create_new_room/create_new_room_page.dart';

///Description
///Managed the Add new device Progress
///
///Author: J. Anders
///created: 20-12-2022
///changed: 20-12-2022
///
///History:
///
///Notes:
///
class AddNewThermostatViewPage extends StatefulWidget {
  static const routName = '/add_new_thermostat_page';
  const AddNewThermostatViewPage({super.key});

  @override
  State<AddNewThermostatViewPage> createState() =>
      _AddNewThermostatViewPageState();
}

class _AddNewThermostatViewPageState extends State<AddNewThermostatViewPage> {
  int _pageState = 0;
  static const int _pageSize = 8;
  final PageController _pageController = PageController(initialPage: 0);
  bool pairingModeActivation = true;

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (context) => AddNewThermostatBloc(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: const BackButtonWidget(),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(local.addDevice),
              Text(
                setSubtitleText(local),
                style: AppTheme.textStyleDefault.copyWith(fontSize: 16.0),
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            Container(
              margin:
                  const EdgeInsets.only(bottom: Dimens.pageControlBottomMargin),
              child: PageView(
                pageSnapping: false,
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                onPageChanged: (value) {},
                children: [
                  //bearbeitet
                  DetectWiFiNetworcPage(callback: _changePage),
                  InsertBatteriesPage(nextCallback: _changePage),
                  PairingModeInformationPage(
                    nextPageFunction: _changePage,
                    pairingModeActivation: _changePairingMode,
                  ),
                  ConnectToThermostat(
                    nextCallback: _changePage,
                  ),
                  SapModeConfigPage(
                    nextCallback: _changePage,
                    tryAgainCallback: _tryAgain,
                  ),
                  MountAndAdapPage(nextCallback: _changePage),
                  SetDeviceNameAndSelectRoomPage(
                    nextCallback: _changePage,
                  ),
                  //noch zu bearbeiten scaffold)

                  const CreateNewRoomPage(),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(Dimens.paddingDefault),
                  child: Center(
                    child: Column(
                      children: [
                        SmoothPageIndicator(
                          controller: _pageController,
                          count: _pageSize,
                          // effect: const SlideEffect(
                          //   dotWidth: Dimens.pageNavigationDotSize,
                          //   dotHeight: Dimens.pageNavigationDotSize,
                          //   dotColor: AppTheme.schriftfarbe,
                          //   activeDotColor: AppTheme.violet,
                          // ),
                          effect: const CustomizableEffect(
                              activeDotDecoration: DotDecoration(
                                  height: Dimens.pageNavigationDotSize,
                                  width: Dimens.pageNavigationDotSize,
                                  color: AppTheme.violet,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(Dimens.borderRadius))),
                              dotDecoration: DotDecoration(
                                  height: Dimens.pageNavigationDotSize,
                                  width: Dimens.pageNavigationDotSize,
                                  color: AppTheme.schriftfarbe,
                                  dotBorder: DotBorder(color: AppTheme.violet),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(Dimens.borderRadius)))),
                          onDotClicked: (index) {},
                        ),
                        Platform.isIOS
                            ? const SizedBox(height: 12)
                            : const SizedBox(height: 0)
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _changePage() {
    if (_pageState != _pageSize) {
      setState(() {
        _pageState++;
        _pageController.animateToPage(_pageState,
            duration: const Duration(
                microseconds: Dimens.changePageViewDurationMicroSeconds),
            curve: Curves.bounceInOut);
      });
    }
  }

  String setSubtitleText(AppLocalizations local) {
    String subtitle = '';
    if (_pageState == 0) {
      subtitle = local.detectNetworc;
    } else if (_pageState == 1) {
      subtitle = local.insertBatteriesTitle;
    } else if (_pageState == 2) {
      if (pairingModeActivation) {
        subtitle = local.activatePairingMode;
      } else {
        subtitle = local.pairingModeActive;
      }
    } else if (_pageState == 3) {
      subtitle = local.connectToDevise;
    } else if (_pageState == 4) {
      subtitle = local.configurateDevice;
    } else if (_pageState == 5) {
      subtitle = local.mountAndAdap;
    } else if (_pageState == 6) {
      subtitle = local.deviceAndRoomName;
    } else if (_pageState == 7) {
      subtitle = local.selectSymbolAndName;
    }
    return subtitle;
  }

  void _changePairingMode(bool state) {
    setState(() {
      pairingModeActivation = state;
    });
  }

  void _tryAgain() {
    setState(() {
      Navigator.pop(context);
    });
  }
}
