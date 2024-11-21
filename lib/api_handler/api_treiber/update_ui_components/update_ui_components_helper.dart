import 'package:http/http.dart';
import 'package:wifi_smart_living/api_handler/api_treiber/login/login_helper.dart';
import 'package:wifi_smart_living/connectivity/network_connection_helper.dart';
import 'package:wifi_smart_living/const/const_api.dart';
import 'package:wifi_smart_living/const/const_json_identifier.dart';
import 'package:wifi_smart_living/core/map_helper/map_builder.dart';
import 'package:wifi_smart_living/http_helper/http_handler/https_request_helper.dart';
import 'package:wifi_smart_living/http_helper/http_header/http_header_helper.dart';
import 'package:wifi_smart_living/http_helper/uri_helper/uri_parser.dart';
import 'package:wifi_smart_living/models/database/datenbank_models.dart';
import 'package:wifi_smart_living/models/database/model_device_manaagement.dart';
import 'package:wifi_smart_living/models/database/model_group_management.dart';
import 'package:wifi_smart_living/models/database/model_schedule_manager.dart';
import 'package:wifi_smart_living/singelton/api_singelton.dart';
import 'package:wifi_smart_living/validation/accessTokenValidation/access_token_validation.dart';

import '../../../jsonParser/messageParser/http_message_parser.dart';
import '../../response_messages/api_message_response_helper.dart';

class UpdateUiComponentsHelper {
  Future<UpdateUIComponentState> updateDatabase(
      {required DatabaseModel databaseModel}) async {
    UpdateUIComponentState state = UpdateUIComponentState.noInternetConnection;
    if (await NetworkStateHelper.networkConnectionEstablished()) {
      if (AccessTokenValidation(token: ApiSingelton().getModelAccessToken)
          .tokenNochValide()) {
        Uri? uri = await _detectUri(model: databaseModel);
        if (uri != null) {
          Response? response = await HttpRequestHelper.putDatabaseEntries(
              apiFunction: uri,
              httpHeader: await HttpHeaderHelper.createAccessTokenHeader(
                  xaccesstoken: ApiSingelton().getModelAccessToken.tokenString),
              data: databaseModel.toJson());
          if (response != null && response.statusCode == 200) {
            int messageId = ApiResponses().getMessageCode(
                message: HttpMessageParser.getMessage(response));
            if (messageId == ApiResponses.databaseEntrySuccesfulUpdated) {
              state = UpdateUIComponentState.entrySuccesfulChanged;
            } else {
              state = UpdateUIComponentState.gerneralError;
            }
          }
        }
      } else {
        LoginHelperState loginHelperState = await LoginHelper().databaseLogin(
            userName: ApiSingelton().getDatabaseUserModel.userMailAdress,
            userPassword: ApiSingelton().getDatabaseUserModel.userPassowrd);

        if (loginHelperState == LoginHelperState.tokenErmittelt) {
          updateDatabase(databaseModel: databaseModel);
        } else {
          state = UpdateUIComponentState.gerneralError;
        }
      }
    }
    return state;
  }

  Future<UpdateUIComponentState> updateNotification(
      {required bool notification}) async {
    UpdateUIComponentState state = UpdateUIComponentState.noInternetConnection;
    if (await NetworkStateHelper.networkConnectionEstablished()) {
      if (AccessTokenValidation(token: ApiSingelton().getModelAccessToken)
          .tokenNochValide()) {
        MapBuilder mapBuilder = MapBuilder();
        mapBuilder.addDynamicMapEntry(
            key: ConstJsonIdentifier.identifierNotification,
            value: notification);
        Response? response = await HttpRequestHelper.putDatabaseEntries(
            apiFunction:
                await UriParser.createUri(apiFunction: ConstApi.updateSelfPut),
            httpHeader: await HttpHeaderHelper.createAccessTokenHeader(
                xaccesstoken: ApiSingelton().getModelAccessToken.tokenString),
            data: mapBuilder.getDynamicMap);
        if (response != null && response.statusCode == 200) {
          int messageId = ApiResponses()
              .getMessageCode(message: HttpMessageParser.getMessage(response));
          if (messageId == ApiResponses.databaseEntrySuccesfulUpdated) {
            state = UpdateUIComponentState.entrySuccesfulChanged;
          } else {
            state = UpdateUIComponentState.gerneralError;
          }
        }
      } else {
        LoginHelperState loginHelperState = await LoginHelper().databaseLogin(
            userName: ApiSingelton().getDatabaseUserModel.userMailAdress,
            userPassword: ApiSingelton().getDatabaseUserModel.userPassowrd);

        if (loginHelperState == LoginHelperState.tokenErmittelt) {
          state = UpdateUIComponentState.determineTokenAgain;
          updateNotification(notification: notification);
        } else {
          state = UpdateUIComponentState.gerneralError;
        }
      }
    }

    return state;
  }

  Future<Uri?> _detectUri({required DatabaseModel model}) async {
    if (model is ModelGroupManagement) {
      return await UriParser.createUri(
          apiFunction: ConstApi.updateGroupManagementPut);
    } else if (model is ModelDeviceManagament) {
      return await UriParser.createUri(
          apiFunction: ConstApi.updateDeviceManagementPut);
    } else if (model is ModelScheduleManager) {
      return await UriParser.createUri(
          apiFunction: ConstApi.updateAllScheduleManagerPut);
    } else {
      return null;
    }
  }
}

enum UpdateUIComponentState {
  noInternetConnection,
  gerneralError,
  entrySuccesfulChanged,
  determineTokenAgain
}
