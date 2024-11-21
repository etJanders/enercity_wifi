import 'package:http/http.dart';
import 'package:wifi_smart_living/api_handler/api_treiber/api_base_url_helper/api_url_helper.dart';
import 'package:wifi_smart_living/api_handler/api_treiber/ping/api_ping_helper.dart';
import 'package:wifi_smart_living/api_handler/response_messages/api_message_respons_detection.dart';

import '../../../const/const_api.dart';
import '../../../core/platformHelper/platform_helper.dart';
import '../../../http_helper/http_handler/https_request_helper.dart';
import '../../../http_helper/http_header/http_header_helper.dart';
import '../../../http_helper/uri_helper/uri_parser.dart';
import '../../../jsonParser/accessToken/parse_access_token.dart';
import '../../../jsonParser/messageParser/http_message_parser.dart';
import '../../../singelton/api_singelton.dart';
import '../../response_messages/api_message_response_helper.dart';

///Description
///Helper class for database login
///
///Author: J. Anders
///created: 30-11-2022
///changed: 02-02-2023
///
///History:
///02-02-2023 change login function
///
///Notes:
///
class LoginHelper {
  Future<LoginHelperState> databaseLogin(
      {required String userName, required String userPassword}) async {
    LoginHelperState loginState = LoginHelperState.httpError;
    await _ping();
    Uri uri;
    if (PlatformHelper.getPlatformInf() == PlatformHelper.platformIdAndroid) {
      uri = await UriParser.createUri(
          apiFunction: ConstApi.loginAndroidFlutterGet);
    } else {
      uri = await UriParser.createUri(apiFunction: ConstApi.loginIosFlutterGet);
    }

    Response response = await HttpRequestHelper.getDatabaseEntries(
        apiFunction: uri,
        httpHeader: await HttpHeaderHelper.createBaseAuthHeader(
            mail: userName, password: userPassword));
    if (response.statusCode == 200) {
      if (ApiMessageresponseDetection().responeMessageEmpfangen(response)) {
        print(response.body);
        print(response.statusCode);
        print(ApiResponses());
        int messageId = ApiResponses()
            .getMessageCode(message: HttpMessageParser.getMessage(response));
        if (messageId == ApiResponses.userNotActivated) {
          loginState = LoginHelperState.benutzerNochNichtAktiviert;
        } else if (messageId == ApiResponses.loginRequired) {

          loginState = LoginHelperState.zugangsdatenFalsch;
        } else {
          loginState = LoginHelperState.httpError;
        }
      } else {
        ApiSingelton singelton = ApiSingelton();
        singelton.initModelAccessToken(
            token: ParseAccessToken.converteToken(
                receivedMessage: response, serviceUser: false));
        loginState = LoginHelperState.tokenErmittelt;
      }
    }

    return loginState;
  }

  Future<void> _ping() async {
    PingState state = await PingHelper()
        .sendApiPing(baseUrl: await ApiUrlHelper().getDefaultUrl());
    if (state == PingState.apiAvailable) {
      ApiUrlHelper().setUseableUrl(true);
    } else {
      ApiUrlHelper().setUseableUrl(false);
    }
  }
}

enum LoginHelperState {
  httpError,
  benutzerNochNichtAktiviert,
  zugangsdatenFalsch,
  tokenErmittelt,
}
