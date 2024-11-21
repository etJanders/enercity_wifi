import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:wifi_smart_living/api_handler/api_treiber/update_database_entries/update_database_entry_helper.dart';
import 'package:wifi_smart_living/const/const_api.dart';
import 'package:wifi_smart_living/converter/hex_bin_converter.dart';
import 'package:wifi_smart_living/device_specification/thermostat_interface.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/models/database/model_device_manaagement.dart';
import 'package:wifi_smart_living/mqtt/mqtt_broker/mqtt_callback_interface.dart';
import 'package:wifi_smart_living/mqtt/mqtt_topic_handler/topic_builder.dart';
import 'package:wifi_smart_living/mqtt_treiber/mqtt_commands/const_mqtt_commands.dart';
import 'package:wifi_smart_living/presentation/alert_dialogs/alert_dialog_information.dart';
import 'package:wifi_smart_living/presentation/delegator/grid_delegator.dart';
import 'package:wifi_smart_living/presentation/thermostat_settings/widgets/batterie_value.dart';
import 'package:wifi_smart_living/presentation/thermostat_settings/widgets/checkbox_info_widget.dart';
import 'package:wifi_smart_living/presentation/thermostat_settings/widgets/checkbox_widget.dart';
import 'package:wifi_smart_living/presentation/thermostat_settings/widgets/container_widgets.dart';
import 'package:wifi_smart_living/presentation/thermostat_settings/widgets/device_mac_widget.dart';
import 'package:wifi_smart_living/presentation/thermostat_settings/widgets/fenster_offen_widget.dart';
import 'package:wifi_smart_living/presentation/thermostat_settings/widgets/offset_infowidget.dart';
import 'package:wifi_smart_living/singelton/api_singelton.dart';
import 'package:wifi_smart_living/singelton/helper/api_singelton_helper.dart';
import 'package:wifi_smart_living/singelton/mqtt_singelton.dart';
import 'package:wifi_smart_living/thermostat_attributes/flags.dart';
import 'package:wifi_smart_living/thermostat_attributes/window_open_detection.dart';

import '../../api_handler/api_treiber/sync/sync_database_entries.dart';
import '../../bloc/thermostat_interaction/thermostat_interaction_bloc.dart';
import '../../models/database/model_device_profile.dart';
import '../../mqtt/mqtt_topic_handler/topic_structure_helper.dart';
import '../../theme.dart';
import '../general_widgets/click_buttons/click_button_colored.dart';
import '../general_widgets/click_buttons/click_button_empty.dart';
import '../home_page/indoor/homepage_indoor_page.dart';
import 'offset_mapping/offset_mapping.dart';

class ThermostatSettingsContent extends StatefulWidget {
  final ModelDeviceManagament managament;
  const ThermostatSettingsContent({super.key, required this.managament});

  @override
  State<ThermostatSettingsContent> createState() =>
      _ThermostatSettingsContentState();
}

///Description
///Control specific thermostat and show thermostat information
///
///Author: J. Anders
///created: 30-11-2022
///changed: 30-11-2022
///
///History:
///
///Notes:
///
class _ThermostatSettingsContentState extends State<ThermostatSettingsContent>
    with WidgetsBindingObserver
    implements MqttCallback {
  final ApiSingeltonHelper singeltonHelper = ApiSingeltonHelper();
  late String batteriValue;
  bool isWindowDetectionValueChanged = false;
  late ThermostatFlags thermostatFlags;
  late WindowOpenDetectionHelper windowOpenDetectionHelper;
  String temperature = "00";
  late List<Widget> containerWidgets;
  bool animation = true;
  @override
  void initState() {
    isWindowDetectionValueChanged = false;
    WidgetsBinding.instance.addObserver(this);
    batteriValue = singeltonHelper
        .getDeviceProfileValue(
            mac: widget.managament.deviceMac,
            profile: ThermostatInterface.battery)
        .profileValue;
    thermostatFlags = ThermostatFlags(singeltonHelper
        .getDeviceProfileValue(
            mac: widget.managament.deviceMac,
            profile: ThermostatInterface.flags)
        .profileValue);

    windowOpenDetectionHelper = WindowOpenDetectionHelper(singeltonHelper
        .getDeviceProfileValue(
            mac: widget.managament.deviceMac,
            profile: ThermostatInterface.windowOpenDetection)
        .profileValue);

    MqttSingelton singelton = MqttSingelton();
    singelton.initCallback(this);
    if (singelton.getMqttConnectionSate() == MqttConnectionState.connected) {
      singelton.sendMqttMessage(
          topic: MqttTopicBuilder.buildCommunicationTopic(
              home: ApiSingelton().getDatabaseUserModel.mqttUserName,
              mac: widget.managament.deviceMac,
              profielIdentifier: ThermostatInterface.getOrDeviceType,
              broker: ApiSingelton().getDatabaseUserModel.broker),
          message: ConstMqttCommands.getDeviceType);
    }

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void deactivate() {
    if (isWindowDetectionValueChanged) {
      isWindowDetectionValueChanged = false;
      BlocProvider.of<ThermostatInteractionBloc>(context).add(SendMqttData(
          macAdresses: widget.managament.deviceMac,
          profileIdentifier: ThermostatInterface.windowOpenDetection,
          profileValue:
              windowOpenDetectionHelper.getDatabaseFlagsForSentAndUpdate()));
    }
    WidgetsBinding.instance.removeObserver(this);
    super.deactivate();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      //beende die ansicht, falls die app in den Hintergrund gedrückt wird
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: ((context) => const HomepageIndoorPage())),
          (route) => false);
    }
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive) {
      if (isWindowDetectionValueChanged) {
        isWindowDetectionValueChanged = false;
        //isWindowDetectionValueChanged = !isWindowDetectionValueChanged;
        BlocProvider.of<ThermostatInteractionBloc>(context).add(SendMqttData(
            macAdresses: widget.managament.deviceMac,
            profileIdentifier: ThermostatInterface.windowOpenDetection,
            profileValue:
                windowOpenDetectionHelper.getDatabaseFlagsForSentAndUpdate()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    containerWidgets = [
      ContainerTextWidget(
          title: local.wifiSettings,
          value: singeltonHelper
              .getDeviceProfileValue(
                  mac: widget.managament.deviceMac,
                  profile: ThermostatInterface.rssi)
              .profileValue),
      ContainerTextWidget(
          title: local.networkName, value: widget.managament.ssidName),
      ContainerTextWidget(
          title: local.baseSoftware,
          value: singeltonHelper
              .getDeviceProfileValue(
                  mac: widget.managament.deviceMac,
                  profile: ThermostatInterface.baseSoftwareVersion)
              .profileValue),
      ContainerTextWidget(
          title: local.radioSoftware,
          value: singeltonHelper
              .getDeviceProfileValue(
                  mac: widget.managament.deviceMac,
                  profile: ThermostatInterface.radioSoftwareVersion)
              .profileValue),
    ];
    return Padding(
      padding: const EdgeInsets.all(Dimens.paddingDefault),
      child: SingleChildScrollView(
        child:
            BlocConsumer<ThermostatInteractionBloc, ThermostatInteractionState>(
          listener: (context, state) {
            if (state is MqttDeviceProfileSuccesfullSent) {
              var profileId = state.profileIdentifier;
              if (profileId == ThermostatInterface.flags) {
                //Update den internen Puffer
                ModelDeviceProfile profile =
                    singeltonHelper.updateDeviceProfile(
                        macAdress: widget.managament.deviceMac,
                        profileId: profileId,
                        profileValue:
                            thermostatFlags.getFlagsForDatabaseUpdate());
                //sende neue Daten an Datenbank
                BlocProvider.of<ThermostatInteractionBloc>(context)
                    .add(UpdateDeviceProfileEntrie(deviceProfile: profile));
              } else if (profileId == ThermostatInterface.windowOpenDetection) {
                ModelDeviceProfile profile =
                    singeltonHelper.updateDeviceProfile(
                        macAdress: widget.managament.deviceMac,
                        profileId: profileId,
                        profileValue: windowOpenDetectionHelper
                            .getDatabaseFlagsForSentAndUpdate());
                //sende neue Daten an Datenbank
                BlocProvider.of<ThermostatInteractionBloc>(context)
                    .add(UpdateDeviceProfileEntrie(deviceProfile: profile));

                //isWindowDetectionValueChanged = false;
                //print("===51");
              } else if (profileId == ThermostatInterface.offset) {
                ModelDeviceProfile profile =
                    singeltonHelper.updateDeviceProfile(
                        macAdress: widget.managament.deviceMac,
                        profileId: profileId,
                        profileValue:
                            OffsetMapping().getOffsetHashValue(temperature));
                //sende neue Daten an Datenbank
                BlocProvider.of<ThermostatInteractionBloc>(context)
                    .add(UpdateDeviceProfileEntrie(deviceProfile: profile));
              }
            } else if (state is MqttTransmissionError) {}
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  DeviceMacWidget(macAdress: widget.managament.deviceMac),
                  const SizedBox(
                    height: Dimens.sizedBoxDefault,
                  ),
                  BatterieWidget(batterieValue: batteriValue),
                  const SizedBox(
                    height: Dimens.sizedBoxDefault,
                  ),
                  CheckboxWidget(
                      title: local.keyLock,
                      initState: thermostatFlags.keyLock,
                      stateChanged: (stateChanged) {
                        thermostatFlags.setTastensperre(stateChanged);
                        BlocProvider.of<ThermostatInteractionBloc>(context).add(
                            SendMqttData(
                                macAdresses: widget.managament.deviceMac,
                                profileIdentifier: ThermostatInterface.flags,
                                profileValue:
                                    thermostatFlags.getDatabaseFlagsForSent()));
                      }),
                  const SizedBox(
                    height: Dimens.sizedBoxDefault,
                  ),
                  CheckboxInfoWidget(
                      title: local.advancedKeyLock,
                      initState: thermostatFlags.advancedKeyLock,
                      stateChanged: (stateChanged) {
                        thermostatFlags.setAdvancedKeyLock(stateChanged);
                        BlocProvider.of<ThermostatInteractionBloc>(context).add(
                            SendMqttData(
                                macAdresses: widget.managament.deviceMac,
                                profileIdentifier: ThermostatInterface.flags,
                                profileValue:
                                    thermostatFlags.getDatabaseFlagsForSent()));
                      },
                      infoCallback: () {
                        InformationAlert().showAlertDialog(
                            context: context,
                            message: local.keyLockPlus,
                            callback: () {});
                      }),
                  const SizedBox(
                    height: Dimens.sizedBoxDefault,
                  ),
                  CheckboxWidget(
                      title: local.rotateDisplay,
                      initState: thermostatFlags.rotateDisplay,
                      stateChanged: (stateChanged) {
                        print(stateChanged);
                        thermostatFlags.setAnzeigeDrehen(stateChanged);
                        BlocProvider.of<ThermostatInteractionBloc>(context).add(
                            SendMqttData(
                                macAdresses: widget.managament.deviceMac,
                                profileIdentifier: ThermostatInterface.flags,
                                profileValue:
                                    thermostatFlags.getDatabaseFlagsForSent()));
                      }),
                  const SizedBox(
                    height: Dimens.sizedBoxDefault,
                  ),
                  CheckboxInfoWidget(
                      title: local.dstChange,
                      initState: thermostatFlags.dst,
                      stateChanged: (stateChanged) {
                        thermostatFlags.setDstMode(stateChanged);
                        BlocProvider.of<ThermostatInteractionBloc>(context).add(
                            SendMqttData(
                                macAdresses: widget.managament.deviceMac,
                                profileIdentifier: ThermostatInterface.flags,
                                profileValue:
                                    thermostatFlags.getDatabaseFlagsForSent()));
                      },
                      infoCallback: () {
                        InformationAlert().showAlertDialog(
                            context: context,
                            message: local.dstInstruction,
                            callback: () {});
                      }),
                  const SizedBox(
                    height: Dimens.sizedBoxDefault,
                  ),
                  FensterOffenWidget(
                      model: windowOpenDetectionHelper,
                      stateChanged: (callbackmodel) {
                        windowOpenDetectionHelper = callbackmodel;
                        isWindowDetectionValueChanged = true;
                        ModelDeviceProfile profile =
                            singeltonHelper.updateDeviceProfile(
                                macAdress: widget.managament.deviceMac,
                                profileId:
                                    ThermostatInterface.windowOpenDetection,
                                profileValue: windowOpenDetectionHelper
                                    .getDatabaseFlagsForSentAndUpdate());
                        //sende neue Daten an Datenbank
                        BlocProvider.of<ThermostatInteractionBloc>(context).add(
                            UpdateDeviceProfileEntrie(deviceProfile: profile));
                        // BlocProvider.of<ThermostatInteractionBloc>(context).add(
                        //     SendMqttData(
                        //         macAdresses: widget.managament.deviceMac,
                        //         profileIdentifier:
                        //             ThermostatInterface.windowOpenDetection,
                        //         profileValue: windowOpenDetectionHelper
                        //             .getDatabaseFlagsForSentAndUpdate()));
                      }),
                  const SizedBox(
                    height: Dimens.sizedBoxDefault,
                  ),

                  // OffsetWidget(offsetChanged:offsetChanged),
                  OffsetInfoWidget(
                      title: "offset",
                      initState: true,
                      offsetvalue: context
                          .watch<DatabaseSync>()
                          .helper
                          .getOffsetprfoile(widget.managament.deviceMac)

                      // .watch<MqttMessagePuffer>()
                      //  .getOffsetvalue(widget.managament.deviceMac),

                      ,
                      stateChanged: (stateChanged) {
                        print("State changes");
                        // thermostatFlags.setAdvancedKeyLock(stateChanged);
                      },
                      infoCallback: () {
                        //
                        sliderPopUp(context, stateChanged: (stateChanged) {
                          BlocProvider.of<ThermostatInteractionBloc>(context)
                              .add(SendMqttData(
                                  macAdresses: widget.managament.deviceMac,
                                  profileIdentifier: ThermostatInterface.offset,
                                  profileValue: OffsetMapping()
                                      .getOffsetHashValue(temperature)));
                        });
                      }),

                  const SizedBox(
                    height: Dimens.sizedBoxDefault,
                  ),

                  const SizedBox(
                    height: Dimens.sizedBoxDefault,
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        GridDelegate.createDoubleDelegate(aspectRatio: 3 / 1.5),
                    itemBuilder: ((context, index) => containerWidgets[index]),
                    itemCount: containerWidgets.length,
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void receivedMessage(String topic, String message) async {
    TopicStructureHelper helper = TopicStructureHelper(recivedTopic: topic);
    if (helper.getTopicMac == widget.managament.deviceMac &&
        helper.getIdentifier == ThermostatInterface.flags) {
      print(message);
      print(thermostatFlags.getFlagsForDatabaseUpdate());
      if (message != thermostatFlags.getFlagsForDatabaseUpdate()) {
        setState(() {
          thermostatFlags = ThermostatFlags(message);
        });

        ModelDeviceProfile profile = singeltonHelper.updateDeviceProfile(
            macAdress: widget.managament.deviceMac,
            profileId: helper.getIdentifier,
            profileValue: message);
        await UpdateDatabaseEntryHelper().updateDatabaseEntry(
            model: profile, api: ConstApi.updateDeviceProfilesPut);
      }
      // else{
      //   ModelDeviceProfile profile = singeltonHelper.updateDeviceProfile(
      //       macAdress: widget.managament.deviceMac,
      //       profileId: helper.getIdentifier,
      //       profileValue: message);
      //   await UpdateDatabaseEntryHelper().updateDatabaseEntry(
      //       model: profile, api: ConstApi.updateDeviceProfilesPut);
      // }
    } else if (helper.getTopicMac == widget.managament.deviceMac &&
        helper.getIdentifier == ThermostatInterface.battery) {
      setState(() {
        batteriValue = HexBinConverter.convertHexStringToInt(hexString: message)
            .toString();
      });

      ModelDeviceProfile profile = singeltonHelper.updateDeviceProfile(
          macAdress: widget.managament.deviceMac,
          profileId: helper.getIdentifier,
          profileValue: batteriValue);
      await UpdateDatabaseEntryHelper().updateDatabaseEntry(
          model: profile, api: ConstApi.updateDeviceProfilesPut);
    }
  }

  bool offsetChanged() {
    return true;
  }

  void sliderPopUp(BuildContext context, {required stateChanged}) {
    showDialog(
        context: context,
        builder: (context) {
          AppLocalizations local = AppLocalizations.of(context)!;

          return AlertDialog(
            backgroundColor: AppTheme.hintergrund,
            content: SleekCircularSlider(
              initialValue: ApiSingeltonHelper()
                  .getOffsetUIprfoile(widget.managament.deviceMac),
              max: 12,
              onChange: (value) {},
              onChangeEnd: (value) {
                temperature = percentageModifier(value);
              },
              appearance: CircularSliderAppearance(
                // animationEnabled: animation,
                size: 200,
                customColors: CustomSliderColors(
                    trackColor: AppTheme.schriftfarbe,
                    progressBarColor: AppTheme.violet,
                    dotColor: AppTheme.violet,
                    hideShadow: true),
                customWidths: CustomSliderWidths(
                    trackWidth: 5, progressBarWidth: 6, handlerSize: 10),
                infoProperties: InfoProperties(
                  mainLabelStyle: AppTheme.textStyleDefault,
                  modifier: (percentage) => percentageModifier(percentage),
                ),
              ),
            ),
            actions: <Widget>[
              ClickButton(
                  buttonText: local.close,
                  buttonFunktion: () async {
                    try {
                      Navigator.of(context).pop();
                    } catch (e) {
                      print(e);
                    }
                  },
                  width: 122),
              const SizedBox(
                height: Dimens.sizedBoxDefault,
              ),
              ClickButtonFilled(
                  buttonText: local.save,
                  buttonFunktion: () async {
                    try {
                      ApiSingeltonHelper().updateDeviceProfile(
                          macAdress: widget.managament.deviceMac,
                          profileId: ThermostatInterface.offset,
                          profileValue:
                              OffsetMapping().getOffsetHashValue(temperature));
                      var room = ApiSingeltonHelper()
                          .getOffsetUIprfoile(widget.managament.deviceMac);
                      stateChanged(temperature);
                      setState(() {});
                      Navigator.of(context).pop();
                    } catch (e) {
                      print(e);
                    }
                  },
                  width: 122),
            ],
          );
        });
  }

  String percentageModifier(double value) {
    animation = false;
    final roundedValue = value.round();
    return "${OffsetMapping().getOffsetValue(progress: roundedValue)}°C";
  }
}
