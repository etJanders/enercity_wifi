import 'package:http/http.dart';
import 'package:wifi_smart_living/api_handler/api_treiber/api_base_url_helper/api_url_helper.dart';
import 'package:wifi_smart_living/api_handler/api_treiber/ping/api_ping_helper.dart';
import 'package:wifi_smart_living/const/const_api.dart';
import 'package:wifi_smart_living/core/platformHelper/platform_helper.dart';
import 'package:wifi_smart_living/http_helper/http_handler/https_request_helper.dart';
import 'package:wifi_smart_living/http_helper/http_header/http_header_helper.dart';
import 'package:wifi_smart_living/http_helper/uri_helper/uri_parser.dart';
import 'package:wifi_smart_living/jsonParser/accessToken/parse_access_token.dart';

import '../../../models/accessToken/model_access_token.dart';

///Description
///Determine a service user token for api interaction
///
///Author: J. Anders
///created: 09-11-2022
///changed: 09-11-2022
///
///History:
///
///Nodes:
///
///Description
///Determine a service user token for api interaction
///
///Author: J. Anders
///created: 09-11-2022
///changed: 02-02-2023
///
///History:
///02-02-2023 change login function
///
///Nodes:
///
class ServiceUserTokenHelper {
  Future<ModelAccessToken> determineServiceUser() async {
    ModelAccessToken token;
    await _ping();
    Uri uri;
    if (PlatformHelper.getPlatformInf() == PlatformHelper.platformIdAndroid) {
      uri = await UriParser.createUri(
          apiFunction: ConstApi.loginAndroidFlutterGet);
    } else {
      uri = await UriParser.createUri(apiFunction: ConstApi.loginIosFlutterGet);
    }
    Response databaseResponse = await HttpRequestHelper.getDatabaseEntries(
        apiFunction: uri,
        httpHeader: await HttpHeaderHelper.createBaseAuthHeader(
            mail: ConstApi.serviceUserName,
            password: ConstApi.serviceUserPassword));
    if (databaseResponse.statusCode == 200) {
      token = ParseAccessToken.converteToken(
          receivedMessage: databaseResponse, serviceUser: true);
    } else {
      token = ModelAccessToken(
          tokenString: "",
          tokenDescription: "",
          serviceToken: true,
          tokenCreatedTime: 0);
    }
    return token;
  }

  Future<void> _ping() async {
    PingState state = await PingHelper()
        .sendApiPing(baseUrl: await ApiUrlHelper().getDefaultUrl());

    ///prüefe ob aktuell zu nutzende API erreichbar ist, falls nicht wechsel die API
    ///check whether the currently used API is available, if not change the API
    if (state == PingState.apiDown) {
      await ApiUrlHelper().setUseableUrl(false);
    } else {
      await ApiUrlHelper().setUseableUrl(true);
    }
  }
}
