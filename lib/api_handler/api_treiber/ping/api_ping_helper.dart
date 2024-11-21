import 'dart:async';

import 'package:http/http.dart';
import 'package:wifi_smart_living/const/const_api.dart';
import 'package:wifi_smart_living/http_helper/http_handler/https_request_helper.dart';
import 'package:wifi_smart_living/http_helper/uri_helper/uri_parser.dart';

///
///Ping wird immer mit der default url durchgeführt. war ping erfolgreich:
///setze in use url auf default, andernfalls wechsel in use url
class PingHelper {
  Future<PingState> sendApiPing({required String baseUrl}) async {
    PingState pingState = PingState.apiDown;
    try{
      Response? response = await HttpRequestHelper.pingApi(
          pingUrl: UriParser.createUriByBase(
              baseUrl: baseUrl, apiFunction: ConstApi.pingGet))?.timeout(const Duration(minutes: 1));

      if (response != null) {
        if (response.statusCode == 200) {
          //Hier brauch ich keine Auswertung, da eine Response kam und die kann nur pong sein
          pingState = PingState.apiAvailable;
        }
      }
    }on TimeoutException catch (_) {
      print('Timed out @ PinhHelperPage');
      pingState = PingState.apiUnresponsive;

    }catch(e){
      print('Timed out due to non timeout error');
      pingState = PingState.apiUnresponsive;
    }
    return pingState;

  }
}

enum PingState {
  apiAvailable,
  apiDown,
  apiUnresponsive
}
