// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:wifi_smart_living/api_handler/api_treiber/create_new_room/create_new_room_helper.dart';
import 'package:wifi_smart_living/connectivity/connectivity_state_helper.dart';
import 'package:wifi_smart_living/connectivity/wifi_settings_helper.dart';
import 'package:wifi_smart_living/core/macAdresshelper/mac_helper.dart';
import 'package:wifi_smart_living/core/stringSplitter/string_splitter_builder.dart';
import 'package:wifi_smart_living/device_specification/thermostat_interface.dart';
import 'package:wifi_smart_living/helper/add_new_device_helper/add_new_device_helper.dart';
import 'package:wifi_smart_living/mqtt/mqtt_topic_handler/topic_builder.dart';
import 'package:wifi_smart_living/sap_interaction/gw_sap_data_builder.dart';
import 'package:wifi_smart_living/sap_interaction/sap_handler.dart';
import 'package:wifi_smart_living/singelton/api_singelton.dart';
import 'package:wifi_smart_living/singelton/mqtt_singelton.dart';

import '../../const/const_api.dart';
import '../../http_helper/http_handler/https_request_helper.dart';
import '../../http_helper/http_header/http_header_helper.dart';
import '../../http_helper/uri_helper/uri_parser.dart';

part 'add_new_thermostat_event.dart';
part 'add_new_thermostat_state.dart';

class AddNewThermostatBloc
    extends Bloc<AddNewThermostatEvent, AddNewThermostatState> {
  AddNewDeviceHelper deviceHelper = AddNewDeviceHelper();
  MqttSingelton mqttSingelton = MqttSingelton();

  AddNewThermostatBloc() : super(AddNewThermostatInitial()) {
    on<DetermineSsidName>((event, emit) async {
      ConnectivityStateHelper stateHelper = ConnectivityStateHelper();
      ConnectivityStates states = await stateHelper.checkConnectionState();
      if (states == ConnectivityStates.wifiConnectionEstablished) {
        String? ssid = await WiFiSettingsHelper().determineSsidName();
        if (ssid != null && Platform.isAndroid) {
          ssid = ssid.substring(1, ssid.length - 1);
        }

        Response response = await HttpRequestHelper.getDatabaseEntries(
            apiFunction:
                await UriParser.createUri(apiFunction: ConstApi.getSeparator),
            httpHeader: await HttpHeaderHelper.createAccessTokenHeader(
                xaccesstoken: ApiSingelton().getModelAccessToken.tokenString));
        final parsedJson = jsonDecode(response.body);
        var seperator = parsedJson["separator"][0]["new_separator"];
        if (seperator == null) {
          deviceHelper.seperator = false;
          emit(SeparatorFetchStatusFail());
          return;
        }
        deviceHelper.seperator = seperator;
        emit(DeterminedSsid(ssid: ssid!));
      } else {
        emit(DetectSsidError(errorState: states));
      }
    });

    on<SsidAndPasswordSelected>((event, emit) async {
      deviceHelper.wifiName = event.ssid;
      deviceHelper.wifiPassword = event.password;
      emit(NextState());
    });

    on<IntroduceDelay>(((event, emit) async {
      emit(DelayState());
      await Future.delayed(const Duration(milliseconds: 3000));
      emit(DelayFinished());
    }));

    on<ConfigDevice>((event, emit) async {
      try {
        if (deviceHelper.getMacAdress().isEmpty) {
          String? macAdress = await WiFiSettingsHelper().getDeviceMacAdress();

          if (MacAdressHelper()
                  .generateUsableMacAdress(macAdress!.toUpperCase()) ==
              "00") {
            emit(SapConfigState(state: SapState.socketConnectionNotWorking));
          } else {
            deviceHelper.setMacAdress(MacAdressHelper()
                .generateUsableMacAdress(macAdress.toUpperCase()));
            SapState state = await SapHandler().openPortAndSendData(
                sapConfig: BuildSapData.buildSapData1233(
                    wifiName: deviceHelper.wifiName,
                    wifiPassword: deviceHelper.wifiPassword,
                    mqttUserName:
                        ApiSingelton().getDatabaseUserModel.mqttUserName,
                    mqttuserPassword:
                        ApiSingelton().getDatabaseUserModel.mqttUserPassword,
                    seperator: deviceHelper.seperator,
                    broker: ApiSingelton().getDatabaseUserModel.broker),
                port: event.devicePort);

            if (event.mode == 0) {
              emit(SapConfigState(state: state));
            }
          }
        } else {
          print("Coming to final else part");
        }
      } catch (e) {
        print(e);
      }
    });

    on<DeviceNameSelected>((event, emit) {
      deviceHelper.deviceName = event.deviceName;
      emit(DeviceNameAdded());
    });

    on<SetImageName>((event, emit) {
      List<String> list = SplitStringHelper.splitStringOnCharacter(
          character: "/", dataString: event.imageName);
      deviceHelper.imageName = list[list.length - 1];
      emit(ImageNameAdded());
    });

    on<SaveNewRoomInDatabase>((event, emit) async {
      deviceHelper.roomName = event.roomName;

      CreateRoomState createRoomState = await CreateNewRoomHelper()
          .createNewRoom(addNewDeviceHelper: deviceHelper);

      MqttConnectionState state = mqttSingelton.getMqttConnectionSate();
      if (state != MqttConnectionState.connecting ||
          state != MqttConnectionState.connected) {
        mqttSingelton.startConnection().then((value) => {
              mqttSingelton.sendMqttMessage(
                  topic: MqttTopicBuilder.buildCommunicationTopic(
                      home: ApiSingelton().getDatabaseUserModel.mqttUserName,
                      mac: deviceHelper.getMacAdress(),
                      profielIdentifier: ThermostatInterface.getOrDeviceType,
                      broker: ApiSingelton().getDatabaseUserModel.broker),
                  message: '49000E20')
            });
      }

      emit(SaveRoomInDatabaseResponse(createRoomState: createRoomState));
    });

    on<AddDeviceToARoom>((event, emit) async {
      deviceHelper.deviceName = event.deviceName;

      CreateRoomState createRoomState = await CreateNewRoomHelper()
          .addThermostatToNewRoom(
              addNewDeviceHelper: deviceHelper, groupId: event.groupId);

      MqttConnectionState state = mqttSingelton.getMqttConnectionSate();
      if (state != MqttConnectionState.connecting ||
          state != MqttConnectionState.connected) {
        mqttSingelton.startConnection().then((value) => {
              mqttSingelton.sendMqttMessage(
                  topic: MqttTopicBuilder.buildCommunicationTopic(
                      home: ApiSingelton().getDatabaseUserModel.mqttUserName,
                      mac: deviceHelper.getMacAdress(),
                      profielIdentifier: ThermostatInterface.getOrDeviceType,
                      broker: ApiSingelton().getDatabaseUserModel.broker),
                  message: '49000E20')
            });
      }

      emit(SaveRoomInDatabaseResponse(createRoomState: createRoomState));
    });
  }
}
