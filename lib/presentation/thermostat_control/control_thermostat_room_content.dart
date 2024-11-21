import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:wifi_smart_living/models/database/model_group_management.dart';
import 'package:wifi_smart_living/presentation/thermostat_control/temperature_mapping/temperature_mapping.dart';
import 'package:wifi_smart_living/presentation/thermostat_control/temperature_slider_widget.dart';

import '../../bloc/thermostat_interaction/thermostat_interaction_bloc.dart';
import '../../device_specification/thermostat_interface.dart';
import '../../dimens.dart';
import '../../helper/temperatureMapping/received_temperature_mapping.dart';
import '../../models/database/model_device_manaagement.dart';
import '../../mqtt/mqtt_broker/mqtt_callback_interface.dart';
import '../../mqtt/mqtt_topic_handler/topic_builder.dart';
import '../../mqtt/mqtt_topic_handler/topic_structure_helper.dart';
import '../../singelton/api_singelton.dart';
import '../../singelton/helper/api_singelton_helper.dart';
import '../../singelton/helper/mqtt_message_puffer.dart';
import '../../singelton/mqtt_singelton.dart';
import '../../theme.dart';
import '../../thermostat_attributes/flags.dart';
import '../thermostat_settings/widgets/checkbox_disbled_widget.dart';
import '../thermostat_settings/widgets/checkbox_widget.dart';

///Description
///
///Content of thermostat control view to see measured room temperature and to
///change target temperature and enable/disable heating profile option
///
///Author: J. Anders
///created: 30-11-2022
///changed: 31-01-2023
///
///History:
///31-01-2023 small progress animation during measerd temperature is detected
///
///Notes:
///todo optimierung kein interface nutzen sonden provider
class ControlThermostatRoomContent extends StatefulWidget {
  final ModelGroupManagement groupManagement;
  const ControlThermostatRoomContent(
      {super.key, required this.groupManagement});

  @override
  State<ControlThermostatRoomContent> createState() =>
      _ControlThermostatRoomContentState();
}

class _ControlThermostatRoomContentState
    extends State<ControlThermostatRoomContent>
    with WidgetsBindingObserver
    implements MqttCallback {
  ///Communication with mqtt broker
  final MqttSingelton mqttSingelton = MqttSingelton();

  ///convert temperature to a displayed value
  final TemperatureMapping mapping = TemperatureMapping();

  String istTemperatur = '--';
  String sollTemperatur = '°C';
  late String newSollTemperatur = '';

  late ThermostatFlags thermostatFlags;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    //Determine all devices of the room
    List<ModelDeviceManagament> list = ApiSingeltonHelper()
        .getDevicesByGroupId(groupId: widget.groupManagement.groupId);

    thermostatFlags =
        ApiSingeltonHelper().getFlags(groupId: widget.groupManagement.groupId);
    MqttConnectionState state = mqttSingelton.getMqttConnectionSate();
    if (state != MqttConnectionState.connected ||
        state != MqttConnectionState.connecting) {
      mqttSingelton.startConnection().then((value) {
        initMqttState(list);
      });
    } else {
      initMqttState(list);
    }
    sollTemperatur = MqttMessagePuffer().getTemperature(widget.groupManagement);

    super.initState();
  }

  @override
  void dispose() {
    mqttSingelton.removeCallback();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    sollTemperatur = context
        .watch<MqttMessagePuffer>()
        .getTemperature(widget.groupManagement);

    return BlocConsumer<ThermostatInteractionBloc, ThermostatInteractionState>(
      listener: (context, state) {
        if (state is MqttDeviceProfileSuccesfullSent) {
          var profileId = state.profileIdentifier;
          if (profileId == ThermostatInterface.targetTemperature) {
            ApiSingeltonHelper()
                .getRoomProfile(
                    groupId: widget.groupManagement.groupId,
                    profileIdentifier: profileId)
                .profileValue = newSollTemperatur;
            BlocProvider.of<ThermostatInteractionBloc>(context).add(
                UpdateRoomProfileEntrie(
                    roomProfile: ApiSingeltonHelper().getRoomProfile(
                        groupId: widget.groupManagement.groupId,
                        profileIdentifier: profileId)));
          } else if (profileId == ThermostatInterface.flags) {
            ApiSingeltonHelper()
                .getRoomProfile(
                    groupId: widget.groupManagement.groupId,
                    profileIdentifier: profileId)
                .profileValue = thermostatFlags.getFlagsForDatabaseUpdate();
            BlocProvider.of<ThermostatInteractionBloc>(context).add(
                UpdateRoomProfileEntrie(
                    roomProfile: ApiSingeltonHelper().getRoomProfile(
                        groupId: widget.groupManagement.groupId,
                        profileIdentifier: profileId)));
          }
        }
      },
      builder: (context, state) {
        String holdaiIndicatorValue = "";
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimens.borderRadius),
                  color: AppTheme.hintergrundHell),
              padding: const EdgeInsets.all(Dimens.paddingDefault),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    local.currentTemperature,
                    style: AppTheme.textStyleDefault,
                  ),
                  istTemperatur == '--'
                      ? const Row(
                          children: [
                            SizedBox(
                              width: Dimens.iconSize,
                              height: Dimens.iconSize,
                              child: CircularProgressIndicator(
                                color: AppTheme.violet,
                              ),
                            ),
                            Text(
                              ' °C',
                              style: AppTheme.textStyleDefault,
                            )
                          ],
                        )
                      : Text(
                          '$istTemperatur °C',
                          style: AppTheme.textStyleDefault,
                        )
                ],
              ),
            ),
            const SizedBox(
              height: Dimens.sizedBoxBigDefault,
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Dimens.paddingDefault),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimens.borderRadius),
                  color: AppTheme.hintergrundHell),
              child: Column(
                children: [
                  Text(
                    local.targetTemperature,
                    textAlign: TextAlign.center,
                    style: AppTheme.textStyleDefault,
                  ),
                  const SizedBox(
                    height: Dimens.sizedBoxDefault,
                  ),
                  TemperatureSliderWidget(
                      temperatureChanged: (value) async {
                        print("value callled is $value");

                        var macs = ApiSingeltonHelper().determineRoomDeviceMacs(
                            groupId: widget.groupManagement.groupId);
                        print(macs.length);
                        for (int j = 0; j < macs.length; j++) {
                          var room = ApiSingeltonHelper().getDeviceProfileValue(
                              mac: ApiSingeltonHelper().determineRoomDeviceMacs(
                                  groupId: widget.groupManagement.groupId)[j],
                              profile: ThermostatInterface
                                  .holidayProfileActiveIndicator);
                          if (room.profileValue.isNotEmpty &&
                              room.profileValue != "#") {
                            String value =
                                int.parse(room.profileValue, radix: 16)
                                    .toString();
                            print("value is $value");
                            holdaiIndicatorValue = int.parse(value, radix: 10)
                                .toRadixString(2)
                                .padLeft(16, "0");

                            if (holdaiIndicatorValue.isNotEmpty &&
                                holdaiIndicatorValue[10] == '1') {
                              var profileHoliday = ApiSingeltonHelper()
                                  .getRoomProfile(
                                      groupId: widget.groupManagement.groupId,
                                      profileIdentifier:
                                          ThermostatInterface.holidayProfile);
                              profileHoliday.profileValue = "#";
                              BlocProvider.of<ThermostatInteractionBloc>(
                                      context)
                                  .add(UpdateRoomProfileEntrie(
                                      roomProfile: profileHoliday));
                            }
                          }
                        }
                        newSollTemperatur = mapping.getTempToSend(value: value);
                        BlocProvider.of<ThermostatInteractionBloc>(context).add(
                            SendMqttToDeviceList(
                                macAdresses: ApiSingeltonHelper()
                                    .getDevicesByGroupId(
                                        groupId:
                                            widget.groupManagement.groupId),
                                profileIdentifier:
                                    ThermostatInterface.targetTemperature,
                                profileValue: newSollTemperatur));
                      },
                      temperature: MqttMessagePuffer()
                          .getHexTemperature(widget.groupManagement)
                          .toString()),
                ],
              ),
            ),
            const SizedBox(
              height: Dimens.sizedBoxBigDefault,
            ),
            (MqttMessagePuffer()
                    .getHolidayProfileActive(widget.groupManagement))
                ? CheckboxWidgetDisabled(
                    title: local.activateDeactivateHeatingprofile,
                    initState: !thermostatFlags.operationMode,
                    stateChanged: (value) {
                      setState(() {
                        thermostatFlags.setOperationMode(!value);
                      });
                      BlocProvider.of<ThermostatInteractionBloc>(context).add(
                          SendMqttToDeviceList(
                              macAdresses: ApiSingeltonHelper()
                                  .getDevicesByGroupId(
                                      groupId: widget.groupManagement.groupId),
                              profileIdentifier: ThermostatInterface.flags,
                              profileValue:
                                  thermostatFlags.getDatabaseFlagsForSent()));
                    })
                : CheckboxWidget(
                    title: local.activateDeactivateHeatingprofile,
                    initState: !thermostatFlags.operationMode,
                    isFromThermostatRoomContent: true,
                    stateChanged: (value) {
                      setState(() {
                        thermostatFlags.setOperationMode(!value);
                      });
                      BlocProvider.of<ThermostatInteractionBloc>(context).add(
                          SendMqttToDeviceList(
                              macAdresses: ApiSingeltonHelper()
                                  .getDevicesByGroupId(
                                      groupId: widget.groupManagement.groupId),
                              profileIdentifier: ThermostatInterface.flags,
                              profileValue:
                                  thermostatFlags.getDatabaseFlagsForSent()));
                    })
          ],
        );
      },
    );
  }

  @override
  void receivedMessage(String topic, String message) {
    TopicStructureHelper topicHelper =
        TopicStructureHelper(recivedTopic: topic);
    if (ApiSingeltonHelper()
        .determineRoomDeviceMacs(groupId: widget.groupManagement.groupId)
        .contains(topicHelper.getTopicMac)) {
      if (topicHelper.getIdentifier ==
          ThermostatInterface.measuredTemperature) {
        setState(() {
          istTemperatur =
              ReceivedTemperatureMapping().mapReceivedTemperature(message);
        });
      } else if (topicHelper.getIdentifier ==
          ThermostatInterface.targetTemperature) {
        setState(() {
          //Datenbank muss hier nicht aktualisiert werden, höchstens internen Puffer anpassen
          //  sollTemperatur = message;
          // ApiSingeltonHelper()
          //     .getRoomProfile(
          //         groupId: widget.groupManagement.groupId,
          //         profileIdentifier: ThermostatInterface.targetTemperature)
          //     .profileValue = message;
        });
      }
    }
  }

  void initMqttState(List<ModelDeviceManagament> devices) {
    MqttMessagePuffer().messageChanged(widget.groupManagement);
    mqttSingelton.initCallback(this);
    if (devices.isNotEmpty) {
      mqttSingelton.sendMqttMessage(
          topic: MqttTopicBuilder.buildCommunicationTopic(
              home: ApiSingelton().getDatabaseUserModel.mqttUserName,
              mac: devices[0].deviceMac,
              profielIdentifier: ThermostatInterface.getOrDeviceType,
              broker: ApiSingelton().getDatabaseUserModel.broker),
          message: '02000000');
    }
  }
}
