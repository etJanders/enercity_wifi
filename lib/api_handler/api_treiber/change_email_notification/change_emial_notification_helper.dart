import 'package:http/http.dart';
import 'package:wifi_smart_living/api_handler/response_messages/api_message_response_helper.dart';
import 'package:wifi_smart_living/const/const_api.dart';
import 'package:wifi_smart_living/const/const_json_identifier.dart';
import 'package:wifi_smart_living/core/map_helper/map_builder.dart';
import 'package:wifi_smart_living/http_helper/http_handler/https_request_helper.dart';
import 'package:wifi_smart_living/http_helper/http_header/http_header_helper.dart';
import 'package:wifi_smart_living/http_helper/uri_helper/uri_parser.dart';
import 'package:wifi_smart_living/jsonParser/messageParser/http_message_parser.dart';
import 'package:wifi_smart_living/models/accessToken/model_access_token.dart';

///Description
///Change Email Notification state
///
///Author: J. Anders
///created: 01-12-2022
///changed: 01-12-2022
///
///History:
///
///Notes:
class ChangeEmailNotifictaionHelper {
  Future<ChangeMailNotificationState> updateNotificationState(
      {required String email,
      required bool notificationState,
      required ModelAccessToken token}) async {
    ChangeMailNotificationState state = ChangeMailNotificationState.updateError;
    MapBuilder mapBuilder = MapBuilder();
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierNotification,
        value: notificationState);

    Response? response = await HttpRequestHelper.putDatabaseEntries(
        apiFunction:
            await UriParser.createUri(apiFunction: ConstApi.updateSelfPut),
        httpHeader: await HttpHeaderHelper.createAccessTokenHeader(
            xaccesstoken: token.tokenString),
        data: mapBuilder.getDynamicMap);

    if (response != null && response.statusCode == 200) {
      int messageId = ApiResponses()
          .getMessageCode(message: HttpMessageParser.getMessage(response));
      if (messageId == ApiResponses.databaseEntrySuccesfulUpdated) {
        state = ChangeMailNotificationState.notificationSuccesfullUpdated;
      }
    }
    return state;
  }
}

enum ChangeMailNotificationState { notificationSuccesfullUpdated, updateError }
