import 'package:http/http.dart';
import 'package:wifi_smart_living/connectivity/network_connection_helper.dart';
import 'package:wifi_smart_living/const/const_api.dart';
import 'package:wifi_smart_living/const/const_json_identifier.dart';
import 'package:wifi_smart_living/core/map_helper/map_builder.dart';
import 'package:wifi_smart_living/http_helper/http_handler/https_request_helper.dart';
import 'package:wifi_smart_living/http_helper/http_header/http_header_helper.dart';
import 'package:wifi_smart_living/http_helper/uri_helper/uri_parser.dart';
import 'package:wifi_smart_living/models/database/model_schedule_group.dart';
import 'package:wifi_smart_living/singelton/api_singelton.dart';
import 'package:wifi_smart_living/validation/accessTokenValidation/access_token_validation.dart';

import '../../../jsonParser/messageParser/http_message_parser.dart';
import '../../response_messages/api_message_response_helper.dart';
import '../login/login_helper.dart';

class DeleteRoomFromDatabaseHelper {
  Future<DeleteEntryState> deletRoomFromDatabase(
      {required String groupId}) async {

    DeleteEntryState state = DeleteEntryState.networkError;
    if (await NetworkStateHelper.networkConnectionEstablished()) {
      if (AccessTokenValidation(token: ApiSingelton().getModelAccessToken)
          .tokenNochValide()) {
        MapBuilder mapBuilder = MapBuilder();
        mapBuilder.addStingMapEntry(
            key: ConstJsonIdentifier.identifierGroupId, value: groupId);

        Response response = await HttpRequestHelper.deletedatabaseEntries(
            apiFunction:
                await UriParser.createUri(apiFunction: ConstApi.deleteRoomDel),
            httpHeader: await HttpHeaderHelper.createAccessTokenHeader(
                xaccesstoken: ApiSingelton().getModelAccessToken.tokenString),
            data: mapBuilder.getStringMap);
        if (response.statusCode == 200) {
          int messageId = ApiResponses()
              .getMessageCode(message: HttpMessageParser.getMessage(response));
          if (messageId == ApiResponses.databaseEntrySuccesfulDeleted) {
            state = DeleteEntryState.roomSuccesfulDeleted;
          } else if (messageId == ApiResponses.datasbaseNotAvaialable) {
            state = DeleteEntryState.databaseError;
          } else {
            state = DeleteEntryState.unknownError;
          }
        } else {
          state = DeleteEntryState.networkError;
        }
      } else {
        LoginHelperState loginHelperState = await LoginHelper().databaseLogin(
            userName: ApiSingelton().getDatabaseUserModel.userMailAdress,
            userPassword: ApiSingelton().getDatabaseUserModel.userPassowrd);
        if (loginHelperState == LoginHelperState.tokenErmittelt) {
          state = DeleteEntryState.tokenAbgelaufen;
          deletRoomFromDatabase(groupId: groupId);
        } else {
          state = DeleteEntryState.unknownError;
        }
      }
    }
    return state;
  }

  Future<DeleteEntryState> deleteDeviceFromDatabase(
      {required String mac}) async {
    DeleteEntryState state = DeleteEntryState.networkError;
    if (await NetworkStateHelper.networkConnectionEstablished()) {
      if (AccessTokenValidation(token: ApiSingelton().getModelAccessToken)
          .tokenNochValide()) {
        MapBuilder mapBuilder = MapBuilder();
        mapBuilder.addStingMapEntry(
            key: ConstJsonIdentifier.identifierDeviceMacAdress, value: mac);

        Response response = await HttpRequestHelper.deletedatabaseEntries(
            apiFunction: await UriParser.createUri(
                apiFunction: ConstApi.deleteDeviceDel),
            httpHeader: await HttpHeaderHelper.createAccessTokenHeader(
                xaccesstoken: ApiSingelton().getModelAccessToken.tokenString),
            data: mapBuilder.getStringMap);
        if (response.statusCode == 200) {
          int messageId = ApiResponses()
              .getMessageCode(message: HttpMessageParser.getMessage(response));
          if (messageId == ApiResponses.databaseEntrySuccesfulDeleted) {
            state = DeleteEntryState.roomSuccesfulDeleted;
          } else if (messageId == ApiResponses.datasbaseNotAvaialable) {
            state = DeleteEntryState.databaseError;
          } else {
            state = DeleteEntryState.unknownError;
          }
        } else {
          state = DeleteEntryState.networkError;
        }
      } else {
        LoginHelperState loginHelperState = await LoginHelper().databaseLogin(
            userName: ApiSingelton().getDatabaseUserModel.userMailAdress,
            userPassword: ApiSingelton().getDatabaseUserModel.userPassowrd);
        if (loginHelperState == LoginHelperState.tokenErmittelt) {
          deleteDeviceFromDatabase(mac: mac);
        } else {
          state = DeleteEntryState.unknownError;
        }
      }
    }
    return state;
  }

  Future<DeleteEntryState> deleteScheduleFromDatabase(
      {required String smPublicId}) async {
    DeleteEntryState state = DeleteEntryState.networkError;
    if (await NetworkStateHelper.networkConnectionEstablished()) {
      if (AccessTokenValidation(token: ApiSingelton().getModelAccessToken)
          .tokenNochValide()) {
        MapBuilder mapBuilder = MapBuilder();
        mapBuilder.addStingMapEntry(
            key: ConstJsonIdentifier.identifierScheduleManagerPublicId,
            value: smPublicId);

        Response response = await HttpRequestHelper.deletedatabaseEntries(
            apiFunction: await UriParser.createUri(
                apiFunction: ConstApi.deleteScheduleDel),
            httpHeader: await HttpHeaderHelper.createAccessTokenHeader(
                xaccesstoken: ApiSingelton().getModelAccessToken.tokenString),
            data: mapBuilder.getStringMap);
        if (response.statusCode == 200) {
          int messageId = ApiResponses()
              .getMessageCode(message: HttpMessageParser.getMessage(response));
          if (messageId == ApiResponses.databaseEntrySuccesfulDeleted) {
            state = DeleteEntryState.scheduleSuccesfulDeleted;
          } else if (messageId == ApiResponses.datasbaseNotAvaialable) {
            state = DeleteEntryState.databaseError;
          } else {
            state = DeleteEntryState.unknownError;
          }
        } else {
          state = DeleteEntryState.networkError;
        }
      } else {
        LoginHelperState loginHelperState = await LoginHelper().databaseLogin(
            userName: ApiSingelton().getDatabaseUserModel.userMailAdress,
            userPassword: ApiSingelton().getDatabaseUserModel.userPassowrd);
        if (loginHelperState == LoginHelperState.tokenErmittelt) {
          deleteScheduleFromDatabase(smPublicId: smPublicId);
        } else if (loginHelperState == LoginHelperState.zugangsdatenFalsch) {
          state = DeleteEntryState.userCredentialsChanged;
        } else {
          state = DeleteEntryState.unknownError;
        }
      }
    }
    return state;
  }

  ///Entferne einen Raum aus einem bestehenden Heizprofil
  Future<DeleteEntryState> deleteSingelRoomFromSchedule(
      ModelScheduleGroup scheduleGroup) async {
    DeleteEntryState state = DeleteEntryState.networkError;
    if (await NetworkStateHelper.networkConnectionEstablished()) {
      if (AccessTokenValidation(token: ApiSingelton().getModelAccessToken)
          .tokenNochValide()) {
        MapBuilder mapBuilder = MapBuilder();
        mapBuilder.addDynamicMapEntry(
            key: ConstJsonIdentifier.identifierScheduleGroupPublicId,
            value: scheduleGroup.entryPublicId);
        Response response = await HttpRequestHelper.deletedatabaseEntries(
            apiFunction: await UriParser.createUri(
                apiFunction: ConstApi.deleteScheduleGroup),
            httpHeader: await HttpHeaderHelper.createAccessTokenHeader(
                xaccesstoken: ApiSingelton().getModelAccessToken.tokenString),
            data: mapBuilder.getDynamicMap);
        if (response.statusCode == 200) {
          int messageId = ApiResponses()
              .getMessageCode(message: HttpMessageParser.getMessage(response));
          if (messageId == ApiResponses.databaseEntrySuccesfulDeleted) {
            state = DeleteEntryState.roomSuccesfulDeleted;
          } else if (messageId == ApiResponses.datasbaseNotAvaialable) {
            state = DeleteEntryState.databaseError;
          } else {
            state = DeleteEntryState.unknownError;
          }
        } else {
          state = DeleteEntryState.unknownError;
        }
      } else {
        LoginHelperState loginHelperState = await LoginHelper().databaseLogin(
            userName: ApiSingelton().getDatabaseUserModel.userMailAdress,
            userPassword: ApiSingelton().getDatabaseUserModel.userPassowrd);
        if (loginHelperState == LoginHelperState.tokenErmittelt) {
          deleteSingelRoomFromSchedule(scheduleGroup);
        } else if (loginHelperState == LoginHelperState.zugangsdatenFalsch) {
          state = DeleteEntryState.userCredentialsChanged;
        } else {
          state = DeleteEntryState.unknownError;
        }
      }
    }

    return state;
  }

  resetHeatingProfileByScheduleGroup(ModelScheduleGroup scheduleGroup) {}
}

enum DeleteEntryState {
  unknownError,
  roomSuccesfulDeleted,
  scheduleSuccesfulDeleted,
  networkError,
  databaseError,
  deleteError,
  userCredentialsChanged,
  tokenAbgelaufen,
}
