import 'package:http/http.dart';
import 'package:wifi_smart_living/api_handler/api_treiber/login/login_helper.dart';
import 'package:wifi_smart_living/const/const_api.dart';
import 'package:wifi_smart_living/const/const_json_identifier.dart';
import 'package:wifi_smart_living/core/map_helper/map_builder.dart';
import 'package:wifi_smart_living/http_helper/http_handler/https_request_helper.dart';
import 'package:wifi_smart_living/http_helper/http_header/http_header_helper.dart';
import 'package:wifi_smart_living/http_helper/uri_helper/uri_parser.dart';
import 'package:wifi_smart_living/singelton/api_singelton.dart';
import 'package:wifi_smart_living/validation/accessTokenValidation/access_token_validation.dart';

import '../../../connectivity/network_connection_helper.dart';
import '../../../helper/add_new_device_helper/add_new_device_helper.dart';
import '../../../jsonParser/messageParser/http_message_parser.dart';
import '../../response_messages/api_message_response_helper.dart';

class CreateNewRoomHelper {
  Future<CreateRoomState> createNewRoom(
      {required AddNewDeviceHelper addNewDeviceHelper}) async {
    try {
      CreateRoomState responseState = CreateRoomState.noInternetConnection;
      if (await NetworkStateHelper.networkConnectionEstablished()) {
        if (AccessTokenValidation(token: ApiSingelton().getModelAccessToken)
            .tokenNochValide()) {
          Response response = await HttpRequestHelper.postDatabaseEntries(
              apiFunction: await UriParser.createUri(
                  apiFunction: ConstApi.createRoomWithDevicePost),
              httpHeader: await HttpHeaderHelper.createAccessTokenHeader(
                  xaccesstoken: ApiSingelton().getModelAccessToken.tokenString),
              data: _createDataMap(addNewDeviceHelper));
          if (response.statusCode == 200) {
            int messageId = ApiResponses().getMessageCode(
                message: HttpMessageParser.getMessage(response));
            if (messageId == ApiResponses.entrySuccesfullCreated) {
              responseState = CreateRoomState.roomSuccesfullCreated;
            } else {
              responseState = CreateRoomState.error;
            }
          }
        } else {
          LoginHelperState loginHelperState = await LoginHelper().databaseLogin(
              userName: ApiSingelton().getDatabaseUserModel.userMailAdress,
              userPassword: ApiSingelton().getDatabaseUserModel.userPassowrd);

          if (loginHelperState == LoginHelperState.tokenErmittelt) {
            createNewRoom(addNewDeviceHelper: addNewDeviceHelper);
          } else {
            responseState = CreateRoomState.error;
          }
        }
      }
      return responseState;
    } catch (e) {
      print('Unknown exception {$e}');
      return CreateRoomState.noInternetConnection;
    }
  }

  Future<CreateRoomState> addThermostatToNewRoom(
      {required AddNewDeviceHelper addNewDeviceHelper,
      required String groupId}) async {
    CreateRoomState responseState = CreateRoomState.noInternetConnection;
    if (await NetworkStateHelper.networkConnectionEstablished()) {
      if (AccessTokenValidation(token: ApiSingelton().getModelAccessToken)
          .tokenNochValide()) {
        Response response = await HttpRequestHelper.postDatabaseEntries(
            apiFunction: await UriParser.createUri(
                apiFunction: ConstApi.addDeviceToRoomPost),
            httpHeader: await HttpHeaderHelper.createAccessTokenHeader(
                xaccesstoken: ApiSingelton().getModelAccessToken.tokenString),
            data: _createAddThermostatDataMap(addNewDeviceHelper, groupId));
        if (response.statusCode == 200) {
          int messageId = ApiResponses()
              .getMessageCode(message: HttpMessageParser.getMessage(response));
          if (messageId == ApiResponses.entrySuccesfullCreated) {
            responseState = CreateRoomState.deviceSuccessfullAdded;
          } else {
            responseState = CreateRoomState.error;
          }
        }
      } else {
        LoginHelperState loginHelperState = await LoginHelper().databaseLogin(
            userName: ApiSingelton().getDatabaseUserModel.userMailAdress,
            userPassword: ApiSingelton().getDatabaseUserModel.userPassowrd);
        {
          if (loginHelperState == LoginHelperState.tokenErmittelt) {
            responseState = CreateRoomState.determineTokenAgain;
            createNewRoom(addNewDeviceHelper: addNewDeviceHelper);
          } else if (loginHelperState == LoginHelperState.zugangsdatenFalsch) {
            responseState == CreateRoomState.userCredentialsChanged;
          } else {
            responseState = CreateRoomState.error;
          }
        }
      }
    }
    return responseState;
  }

  Map<String, dynamic> _createDataMap(AddNewDeviceHelper addNewDeviceHelper) {
    MapBuilder mapBuilder = MapBuilder();
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierDeviceMacAdress,
        value: addNewDeviceHelper.getMacAdress());
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierUiPosition,
        value: ApiSingelton().getModelGroupManagement.length + 1);
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierDeviceName,
        value: addNewDeviceHelper.deviceName);
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierDeviceTypeId,
        value: addNewDeviceHelper.deviceTypeId);
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierSsid,
        value: addNewDeviceHelper.wifiName);
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierGroupName,
        value: addNewDeviceHelper.roomName);
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierGroupImage,
        value: addNewDeviceHelper.imageName);
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierLocation,
        value: addNewDeviceHelper.location);
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierGroupOwner,
        value: ApiSingelton().getDatabaseUserModel.entryPublicId);
    return mapBuilder.getDynamicMap;
  }

  Map<String, dynamic> _createAddThermostatDataMap(
      AddNewDeviceHelper addNewDeviceHelper, String groupId) {
    MapBuilder mapBuilder = MapBuilder();

    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierGroupId, value: groupId);
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierDeviceMacAdress,
        value: addNewDeviceHelper.getMacAdress());
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierDeviceName,
        value: addNewDeviceHelper.deviceName);
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierDeviceTypeId,
        value: addNewDeviceHelper.deviceTypeId);
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierSsid,
        value: addNewDeviceHelper.wifiName);
    return mapBuilder.getDynamicMap;
  }
}

enum CreateRoomState {
  noInternetConnection,
  error,
  userCredentialsChanged,
  roomSuccesfullCreated,
  deviceSuccessfullAdded,
  determineTokenAgain,
}
