import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wifi_smart_living/bloc/add_new_thermostat/add_new_thermostat_bloc.dart';
import 'package:wifi_smart_living/connectivity/connectivity_state_helper.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/presentation/alert_dialogs/alert_dialog_information.dart';
import 'package:wifi_smart_living/presentation/general_widgets/click_buttons/click_button_colored.dart';
import 'package:wifi_smart_living/presentation/general_widgets/editTextWidgets/edit_password_text_widget.dart';
import 'package:wifi_smart_living/presentation/general_widgets/editTextWidgets/locked_text_input_widget.dart';
import 'package:wifi_smart_living/storage_helper/secured_storage_helper.dart';
import 'package:wifi_smart_living/theme.dart';

///Description
///Check the connected Wifi network of the smartphone and get wifi password
///
///Author: J. Anders
///created: 14-12-2022
///changed: 14-12-2022
///
///History:
///
///Notes:
///
///
///Todo pruefe Wlan name und passwort, da beides kein Komma enthalten darf
class DetectWiFiNetworcPage extends StatefulWidget {
  final Function callback;

  const DetectWiFiNetworcPage({super.key, required this.callback});

  @override
  State<DetectWiFiNetworcPage> createState() => _DetectWiFiNetworcPageState();
}

class _DetectWiFiNetworcPageState extends State<DetectWiFiNetworcPage> {
  late String ssidString = "";
  bool ssidDetermined = false;
  bool errorFoundInSeparator = false;
  TextEditingController wifiPasswordEditingControler = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    if (ssidString.isEmpty || !ssidDetermined) {
      ssidDetermined = true;
      BlocProvider.of<AddNewThermostatBloc>(context).add(DetermineSsidName());
    }
    return BlocConsumer<AddNewThermostatBloc, AddNewThermostatState>(
      listener: (context, state) {
        if (state is DeterminedSsid) {
          setSSid(state.ssid);
        } else if (state is DetectSsidError) {
          //Fehler, beim Ermitteln des SSID Namens
          ConnectivityStates connectivity = state.errorState;
          if (connectivity == ConnectivityStates.noNetworcConnection) {
          } else if (connectivity == ConnectivityStates.permissionError) {
          } else if (connectivity == ConnectivityStates.connectionError) {}
        } else if (state is NextState) {
          widget.callback();
        } else if (state is SeparatorFetchStatusFail) {
          errorFoundInSeparator = true;
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(Dimens.paddingDefault),
          child: Column(
            children: [
              const SizedBox(
                height: Dimens.sizedBoxBigDefault,
              ),
              Text(
                local.connectYourSmartphoneWithYourWiFi,
                style: AppTheme.textStyleDefault,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: Dimens.paddingDefault,
              ),
              Text(
                local.noteMessage,
                style: AppTheme.textStyleDefault,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: Dimens.sizedBoxBigDefault,
              ),
              LockedEditTextInput(text: ssidString),
              const SizedBox(
                height: Dimens.paddingDefault,
              ),
              EditPasswortTextInput(
                  passwordEditingControler: wifiPasswordEditingControler,
                  hintText: local.password),
              const Spacer(),
              ClickButtonFilled(
                  buttonText: local.next,
                  buttonFunktion: () {
                    ///Close keyboard of opened
                    FocusScope.of(context).unfocus();
                    if (errorFoundInSeparator) {
                      InformationAlert().showAlertDialog(
                          context: context,
                          message: local.oopsError,
                          callback: () {});
                    } else if (ssidString.isEmpty) {
                      InformationAlert().showAlertDialog(
                          context: context,
                          message: local.networkNotDetected,
                          callback: () {});
                    } else if (wifiPasswordEditingControler.text.isEmpty) {
                      InformationAlert().showAlertDialog(
                          context: context,
                          message: local.enterWifiPassword,
                          callback: () {});
                    } else if (wifiPasswordEditingControler.text
                            .contains("\\") ||
                        wifiPasswordEditingControler.text.contains("'") ||
                        wifiPasswordEditingControler.text.contains("‘") ||
                        wifiPasswordEditingControler.text.contains("’") ||
                        wifiPasswordEditingControler.text.contains("'") ||
                        wifiPasswordEditingControler.text.contains("`"))
                    //  else if(utf8.encode(wifiPasswordEditingControler.text).length +  utf8.encode(ssidString).length> 64) // Future implementation of maximum byte restriction.
                    {
                      InformationAlert().showAlertDialog(
                          context: context,
                          //  message: local.byteLimitExceeded, // Future implementation of maximum byte restriction.
                          message: local.invalidCharater,
                          callback: () {});
                    } else {
                      saveSsidAnPassword(
                          ssid: ssidString,
                          password: wifiPasswordEditingControler.text);
                      BlocProvider.of<AddNewThermostatBloc>(context).add(
                          SsidAndPasswordSelected(
                              ssid: ssidString,
                              password: wifiPasswordEditingControler.text));
                    }
                  },
                  width: double.infinity),
            ],
          ),
        );
      },
    );
  }

  void saveSsidAnPassword(
      {required String ssid, required String password}) async {
    SecuredStorageHelper helper = SecuredStorageHelper();
    helper.storeData(key: ssid, value: password);
  }

  void setSSid(String ssid) async {
    SecuredStorageHelper helper = SecuredStorageHelper();
    String storedPassword = await helper.readSecuredStorageData(key: ssid);
    setState(() {
      ssidString = ssid;
      if (storedPassword.isNotEmpty) {
        wifiPasswordEditingControler.text = storedPassword;
      }
    });
  }
}
