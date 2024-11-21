import 'package:http/http.dart';
import 'package:wifi_smart_living/api_handler/api_treiber/login/service_user_token.dart';
import 'package:wifi_smart_living/connectivity/network_connection_helper.dart';
import 'package:wifi_smart_living/const/const_api.dart';
import 'package:wifi_smart_living/const/const_json_identifier.dart';
import 'package:wifi_smart_living/core/map_helper/map_builder.dart';
import 'package:wifi_smart_living/http_helper/http_handler/https_request_helper.dart';
import 'package:wifi_smart_living/http_helper/http_header/http_header_helper.dart';
import 'package:wifi_smart_living/http_helper/uri_helper/uri_parser.dart';
import 'package:wifi_smart_living/models/accessToken/model_access_token.dart';

import '../../../jsonParser/messageParser/http_message_parser.dart';
import '../../response_messages/api_message_response_helper.dart';

///Description
///check if a user account is activated
///
///Author: J. Anders
///created: 17-01-2023
///changed: 17-01-2023
///
///History:
///
///Notes:
///
class ActivationStateHelper {
  Future<UserAccountActivationState> determineActivationstate(
      {required String userMailAdress}) async {
    UserAccountActivationState state =
        UserAccountActivationState.noInternetConnection;
    if (await NetworkStateHelper.networkConnectionEstablished()) {
      ModelAccessToken serviceToken =
          await ServiceUserTokenHelper().determineServiceUser();
      if (serviceToken.tokenString.isNotEmpty) {
        MapBuilder mapBuilder = MapBuilder();
        mapBuilder.addStingMapEntry(
            key: ConstJsonIdentifier.identifierUserMail, value: userMailAdress);
        Response httpResponse = await HttpRequestHelper.postDatabaseEntries(
            apiFunction: await UriParser.createUri(
                apiFunction: ConstApi.getActivationstatePost),
            httpHeader: await HttpHeaderHelper.createAccessTokenHeader(
                xaccesstoken: serviceToken.tokenString),
            data: mapBuilder.getStringMap);
        if (httpResponse.statusCode == 200) {
          int messageId = ApiResponses().getMessageCode(
              message: HttpMessageParser.getMessage(httpResponse));
          if (messageId == ApiResponses.userAlreadyActivated) {
            state = UserAccountActivationState.accountActivated;
          } else if (messageId == ApiResponses.userNotActivated) {
            state = UserAccountActivationState.accountNotActivated;
          } else if (messageId == ApiResponses.userDoseNotExists) {
            state = UserAccountActivationState.userDoseNotExists;
          }
        }
      } else {
        state = UserAccountActivationState.generalError;
      }
    }
    return state;
  }
}

enum UserAccountActivationState {
  noInternetConnection,
  accountNotActivated,
  accountActivated,
  userDoseNotExists,
  generalError,
}
