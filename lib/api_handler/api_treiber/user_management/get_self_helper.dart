import 'package:http/http.dart';
import 'package:wifi_smart_living/api_handler/api_treiber/login/login_helper.dart';
import 'package:wifi_smart_living/api_handler/api_treiber/user_management/update_self_helper.dart';
import 'package:wifi_smart_living/const/const_api.dart';
import 'package:wifi_smart_living/models/database/model_database_user.dart';
import 'package:wifi_smart_living/validation/accessTokenValidation/access_token_validation.dart';

import '../../../http_helper/http_handler/https_request_helper.dart';
import '../../../http_helper/http_header/http_header_helper.dart';
import '../../../http_helper/uri_helper/uri_parser.dart';
import '../../../jsonParser/databaseUser/parse_database_user.dart';
import '../../../jsonParser/messageParser/http_message_parser.dart';
import '../../../models/accessToken/model_access_token.dart';
import '../../../singelton/api_singelton.dart';
import '../../response_messages/api_message_respons_detection.dart';
import '../../response_messages/api_message_response_helper.dart';

///Description
/// Get Self handler to determine user data from database
///
/// Author: J. Anders
///created: 11-11-2022
///changed: 11-11-2022
///
///History:
///
///Notes:
///
class GetSelfHelper {
  late String password = "";

  Future<GetSelfState> callGetSelf(
      {required ModelAccessToken token, required String password}) async {
    this.password = password;
    GetSelfState state = GetSelfState.getSelfError;
    if (AccessTokenValidation(token: token).tokenNochValide()) {
      state = _determineGetSelfState(
          response: await _getSelf(token: token), token: token);
    } else {
      LoginHelperState loginState = await LoginHelper().databaseLogin(
          userName: ApiSingelton().getDatabaseUserModel.userMailAdress,
          userPassword: ApiSingelton().getDatabaseUserModel.userPassowrd);
      if (loginState == LoginHelperState.tokenErmittelt) {
        state = _determineGetSelfState(
            response: await _getSelf(token: token), token: token);
      } else {
        state = GetSelfState.determineTokenError;
      }
    }
    return state;
  }

  Future<Response> _getSelf({required ModelAccessToken token}) async {
    Response response = await HttpRequestHelper.getDatabaseEntries(
        apiFunction:
            await UriParser.createUri(apiFunction: ConstApi.getSelfGet),
        httpHeader: await HttpHeaderHelper.createAccessTokenHeader(
            xaccesstoken: token.tokenString));

    return response;
  }

  GetSelfState _determineGetSelfState(
      {required Response response, required ModelAccessToken token}) {
    print(response.body);
    GetSelfState state = GetSelfState.userNotFound;
    if (response.statusCode == 200) {
      if (ApiMessageresponseDetection().responeMessageEmpfangen(response)) {
        int messageResponse = ApiResponses()
            .getMessageCode(message: HttpMessageParser.getMessage(response));
        if (messageResponse == ApiResponses.userDoseNotExists) {
          state = GetSelfState.userNotFound;
        } else {
          state = GetSelfState.determineTokenError;
        }
      } else {
        ModelDatabaseUser user = ParseDatabaseUser.converteDatabaseUser(
          receivedMessage: response,
          password: password,
        );
        ApiSingelton singelton = ApiSingelton();
        singelton.initModeldatabaseUser(user: user);
        UpdateSelfHelper().updateSelf(user: user, token: token);
        state = GetSelfState.getSelfDetermined;
      }
    } else {
      state = GetSelfState.getSelfError;
    }
    return state;
  }
}

enum GetSelfState {
  getSelfDetermined,
  userNotFound,
  determineTokenError,
  getSelfError
}
