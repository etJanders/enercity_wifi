import 'package:http/http.dart';
import 'package:wifi_smart_living/api_handler/api_treiber/login/service_user_token.dart';
import 'package:wifi_smart_living/const/const_api.dart';

import '../../../const/const_json_identifier.dart';
import '../../../core/map_helper/map_builder.dart';
import '../../../http_helper/http_handler/https_request_helper.dart';
import '../../../http_helper/http_header/http_header_helper.dart';
import '../../../http_helper/uri_helper/uri_parser.dart';
import '../../../jsonParser/messageParser/http_message_parser.dart';
import '../../../models/accessToken/model_access_token.dart';
import '../../response_messages/api_message_response_helper.dart';

class UserAccountActivationHelper {
  Future<AccountActivationState> refreshActivationToken(
      {required String mail}) async {
    AccountActivationState state =
        AccountActivationState.accountActivationIssue;
    ModelAccessToken token =
        await ServiceUserTokenHelper().determineServiceUser();
    MapBuilder mapBuilder = MapBuilder();
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierUserMail, value: mail);
    Response response = await HttpRequestHelper.postDatabaseEntries(
        apiFunction: await UriParser.createUri(
            apiFunction: ConstApi.refreshActivationToken),
        httpHeader: await HttpHeaderHelper.createAccessTokenHeader(
            xaccesstoken: token.tokenString),
        data: mapBuilder.getDynamicMap);
    if (response.statusCode == 200) {
      int messageId = ApiResponses()
          .getMessageCode(message: HttpMessageParser.getMessage(response));

      if (messageId == ApiResponses.activationTokenSent) {
        state = AccountActivationState.tokenHasResent;
      } else {
        state = AccountActivationState.accountActivationIssue;
      }
    }
    return state;
  }

  Future<AccountActivationState> activateUserAccount(
      {required String mail, required String activationToken}) async {
    AccountActivationState state =
        AccountActivationState.accountActivationIssue;
    ModelAccessToken token =
        await ServiceUserTokenHelper().determineServiceUser();
    MapBuilder mapBuilder = MapBuilder();
    mapBuilder.addStingMapEntry(
        key: ConstJsonIdentifier.identifierUserMail, value: mail);
    mapBuilder.addStingMapEntry(
        key: ConstJsonIdentifier.identifierToken, value: activationToken);
    Response response = await HttpRequestHelper.postDatabaseEntries(
        apiFunction: await UriParser.createUri(
            apiFunction: ConstApi.activateNewUserPost),
        httpHeader: await HttpHeaderHelper.createAccessTokenHeader(
            xaccesstoken: token.tokenString),
        data: mapBuilder.getStringMap);
    if (response.statusCode == 200) {
      int messageId = ApiResponses()
          .getMessageCode(message: HttpMessageParser.getMessage(response));
      if (messageId == ApiResponses.userSuccessfullActivated) {
        state = AccountActivationState.accountSuccesfulActivated;
      } else if (messageId == ApiResponses.tokenInvalde) {
        state = AccountActivationState.enteredTokenIsNotCorrect;
      } else {
        state = AccountActivationState.accountActivationIssue;
      }
    }
    return state;
  }
}

enum AccountActivationState {
  accountSuccesfulActivated,
  tokenHasResent,
  databaseIssue,
  accountActivationIssue,
  enteredTokenIsNotCorrect
}
