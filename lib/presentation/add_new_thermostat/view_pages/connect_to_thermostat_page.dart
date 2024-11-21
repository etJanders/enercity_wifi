import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:wifi_smart_living/connectivity/wifi_settings_helper.dart';
import 'package:wifi_smart_living/const/const_wifi_name.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/presentation/general_widgets/click_buttons/click_button_colored.dart';
import 'package:wifi_smart_living/presentation/general_widgets/click_buttons/click_button_empty.dart';
import 'package:wifi_smart_living/presentation/general_widgets/components/thermostat_connection_information_box.dart';
import 'package:wifi_smart_living/theme.dart';

import '../../general_widgets/loading_spinner/loading_circle.dart';

class ConnectToThermostat extends StatefulWidget {
  final Function nextCallback;
  const ConnectToThermostat({super.key, required this.nextCallback});

  @override
  State<ConnectToThermostat> createState() => _ConnectToThermostatState();
}

class _ConnectToThermostatState extends State<ConnectToThermostat>
    with WidgetsBindingObserver {
  bool connectedWithThermostat = false;
  bool showEurotronic = false;
  late LoadingCicle loadingCicle;
  static const wifiChannel =
      MethodChannel('org/eurotronic/smartLiving/wificonnect');
  late String? connectedWiFiNetwork;

  static const delayDuration = 5000;

// TODO - changed by tismo on 1 Aug 2024 to fix error.
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    _initWifiSettings();
  }

  void _initWifiSettings() async {
    connectedWiFiNetwork = await WiFiSettingsHelper().determineSsidName();
    if (connectedWiFiNetwork != null && connectedWiFiNetwork!.isNotEmpty) {
      if (Platform.isAndroid) {
        connectedWiFiNetwork = connectedWiFiNetwork!
            .substring(1, connectedWiFiNetwork!.length - 1);
      }
      if (connectedWiFiNetwork == ConstWifiName.cometWifi ||
          connectedWiFiNetwork == ConstWifiName.eurotronicWifi) {
        changeThermostatConnection();
      }
    } else if (Platform.isIOS) {
      final info = NetworkInfo();

      final wifiName = await info.getWifiName();
      if (wifiName == ConstWifiName.cometWifi ||
          wifiName == ConstWifiName.eurotronicWifi) {
        changeThermostatConnection();
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      connectedWiFiNetwork = await WiFiSettingsHelper().determineSsidName();
      if (connectedWiFiNetwork != null && connectedWiFiNetwork!.isNotEmpty) {
        if (Platform.isAndroid) {
          connectedWiFiNetwork = connectedWiFiNetwork!
              .substring(1, connectedWiFiNetwork!.length - 1);
        }
        //  else{
        if (connectedWiFiNetwork == ConstWifiName.cometWifi ||
            connectedWiFiNetwork == ConstWifiName.eurotronicWifi) {
          changeThermostatConnection();
        }
      } else if (Platform.isIOS) {
        final info = NetworkInfo();

        final wifiName = await info.getWifiName();
        if (wifiName == ConstWifiName.cometWifi ||
            wifiName == ConstWifiName.eurotronicWifi) {
          changeThermostatConnection();
        }
      }
    }
  }

  Future<void> _connectToWiFi(String ssid, String password) async {
    try {
      if (Platform.isIOS) {
        int connectionStatus = await wifiChannel.invokeMethod('connectToWiFi', {
          'ssid': ssid,
          'password': password,
        });
        print('Wifi Connection status is: $connectionStatus');
        if (connectionStatus == 1) {
          connectedWiFiNetwork = await WiFiSettingsHelper().determineSsidName();
          if (connectedWiFiNetwork != null &&
              connectedWiFiNetwork!.isNotEmpty) {
            if (Platform.isAndroid) {
              connectedWiFiNetwork = connectedWiFiNetwork!
                  .substring(1, connectedWiFiNetwork!.length - 1);
            }
            //  else{
            if (connectedWiFiNetwork == ConstWifiName.cometWifi ||
                connectedWiFiNetwork == ConstWifiName.eurotronicWifi) {
              if (Platform.isIOS) {
                changeThermostatConnectionWithDelay();
              } else {
                loadingCicle.animationDismiss();
                changeThermostatConnection();
              }
            } else {
              loadingCicle.animationDismiss();
            }
          } else if (Platform.isIOS) {
            final info = NetworkInfo();

            final wifiName = await info.getWifiName();
            if (wifiName == ConstWifiName.cometWifi ||
                wifiName == ConstWifiName.eurotronicWifi) {
              changeThermostatConnectionWithDelay();
            } else {
              loadingCicle.animationDismiss();
            }
          }
        } else {
          loadingCicle.animationDismiss();
        }
      } else {
        loadingCicle.animationDismiss();

        //Code To call the android native method
        // await wifiChannel.invokeMethod('connectToWiFi', {
        //   'ssid': ssid,
        //   'password': password,
        // });
        // print('Connected to Wi-Fi: $ssid');
      }
    } on PlatformException catch (e) {
      print('Error connecting to Wi-Fi: ${e.message}');
      loadingCicle.animationDismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    loadingCicle = LoadingCicle(context: context);
    return Padding(
      padding: const EdgeInsets.all(Dimens.paddingDefault),
      child: Column(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: Dimens.sizedBoxBigDefault,
                ),
                Text(
                  local.changeToWiFiSettings,
                  style: AppTheme.textStyleDefault,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: Dimens.paddingDefault,
                ),
                WiFiInformationBox(
                    buttonText: 'Comet WiFi',
                    subTitle: local.password,
                    devicePassword: '11223344'),
                const SizedBox(
                  height: Dimens.sizedBoxDefault,
                ),
                if (showEurotronic)
                  Text(
                    local.or,
                    style: AppTheme.textStyleDefault,
                  ),
                if (showEurotronic)
                  const SizedBox(
                    height: Dimens.sizedBoxDefault,
                  ),
                if (showEurotronic)
                  WiFiInformationBox(
                      buttonText: 'Eurotronic',
                      subTitle: local.password,
                      devicePassword: '22222222'),
                const SizedBox(
                  height: Dimens.sizedBoxBigDefault,
                ),
                Text(
                  local.goBackToTheApp,
                  style: AppTheme.textStyleDefault,
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
          const Spacer(),
          connectedWithThermostat && Platform.isAndroid //for Android
              ? ClickButton(
                  buttonText: local.openWiFiSettings,
                  buttonFunktion: null,
                  width: double.infinity)
              : Platform.isAndroid ////for Android
                  ? ClickButtonFilled(
                      buttonText: local.openWiFiSettings,
                      buttonFunktion: () async {
                        if (Platform.isAndroid) {
                          await AppSettings.openAppSettings(
                              type: AppSettingsType.wifi);
                        } else {
                          await AppSettings.openAppSettings(
                              type: AppSettingsType.wifi);
                        }
                      },
                      width: double.infinity)
                  : connectedWithThermostat
                      ? ClickButton(
                          buttonText: local.connectToWifi,
                          buttonFunktion: null,
                          width: double.infinity)
                      : ClickButtonFilled(
                          buttonText: local.connectToWifi,
                          buttonFunktion: () async {
                            loadingCicle
                                .showAnimation(local.connectingToCometWifi);
                            // changeThermostatConnection();
                            _connectToWiFi('', '');
                          },
                          width: double.infinity),
          const SizedBox(
            height: Dimens.paddingDefault,
          ),
          connectedWithThermostat
              ? ClickButtonFilled(
                  buttonText: local.next,
                  buttonFunktion: () {
                    widget.nextCallback();
                  },
                  width: double.infinity)
              : ClickButton(
                  buttonText: local.next,
                  buttonFunktion: null,
                  width: double.infinity)
        ],
      ),
    );
  }

  void changeThermostatConnection() {
    setState(() {
      connectedWithThermostat = !connectedWithThermostat;
    });
  }

  void changeThermostatConnectionWithDelay() {
    Future.delayed(const Duration(milliseconds: delayDuration), () {
      setState(() {
        connectedWithThermostat = !connectedWithThermostat;
        loadingCicle.animationDismiss();
      });
    });
  }

  void changeShowEurotronic() {
    //Toggle via blocprovider event
    setState(() {
      showEurotronic != showEurotronic;
    });
  }

  Future<void> openiOSWifiSettings() async {
    const url = 'App-Prefs:Wi-Fi';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not open Wi-Fi settings.';
    }
  }
}
