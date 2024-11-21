import 'package:http/http.dart';
import 'package:wifi_smart_living/const/const_api.dart';
import 'package:wifi_smart_living/const/const_json_identifier.dart';
import 'package:wifi_smart_living/core/map_helper/map_builder.dart';
import 'package:wifi_smart_living/http_helper/http_handler/https_request_helper.dart';
import 'package:wifi_smart_living/http_helper/http_header/http_header_helper.dart';
import 'package:wifi_smart_living/http_helper/uri_helper/uri_parser.dart';

import '../../../connectivity/network_connection_helper.dart';
import '../../../jsonParser/messageParser/http_message_parser.dart';
import '../../../singelton/api_singelton.dart';
import '../../../validation/accessTokenValidation/access_token_validation.dart';
import '../../response_messages/api_message_response_helper.dart';
import '../login/login_helper.dart';

///Description
///create database entries to link a list of rooms to an existing heating profile
///
///Author: J. Anders
///created: 01-02-2023
///changed: 01-02-2023
///
///History:
///
///Notes:
///
class AddNewRoomsToScheduleHelper {
  Future<AddRoomsToScheduleHelperState> addNewRooms(
      {required List<String> groupIds, required String smPublicId}) async {
    AddRoomsToScheduleHelperState responseState =
        AddRoomsToScheduleHelperState.noInternetConnection;
    if (await NetworkStateHelper.networkConnectionEstablished()) {
      if (AccessTokenValidation(token: ApiSingelton().getModelAccessToken)
          .tokenNochValide()) {
        MapBuilder mapBuilder = MapBuilder();
        mapBuilder.addDynamicMapEntry(
            key: ConstJsonIdentifier.identifierScheduleManagerPublicId,
            value: smPublicId);
        mapBuilder.addDynamicMapEntry(key: 'group_ids', value: groupIds);
        Response response = await HttpRequestHelper.postDatabaseEntries(
            apiFunction: await UriParser.createUri(
                apiFunction: ConstApi.createScheduleGroupByList),
            httpHeader: await HttpHeaderHelper.createAccessTokenHeader(
                xaccesstoken: ApiSingelton().getModelAccessToken.tokenString),
            data: mapBuilder.getDynamicMap);
        if (response.statusCode == 200) {
          int messageId = ApiResponses()
              .getMessageCode(message: HttpMessageParser.getMessage(response));
          if (messageId == ApiResponses.entrySuccesfullCreated) {
            responseState = AddRoomsToScheduleHelperState.succesfullAdded;
          } else {
            responseState == AddRoomsToScheduleHelperState.generalerror;
          }
        }
      } else {
        LoginHelperState loginHelperState = await LoginHelper().databaseLogin(
            userName: ApiSingelton().getDatabaseUserModel.userMailAdress,
            userPassword: ApiSingelton().getDatabaseUserModel.userPassowrd);
        if (loginHelperState == LoginHelperState.tokenErmittelt) {
          responseState = AddRoomsToScheduleHelperState.determineTokenAgain;
          addNewRooms(groupIds: groupIds, smPublicId: smPublicId);
        } else {
          responseState = AddRoomsToScheduleHelperState.generalerror;
        }
      }
    }

    return responseState;
  }
}

enum AddRoomsToScheduleHelperState {
  noInternetConnection,
  generalerror,
  succesfullAdded,
  determineTokenAgain,
}
