import 'package:http/http.dart';
import 'package:wifi_smart_living/api_handler/api_treiber/login/login_helper.dart';
import 'package:wifi_smart_living/api_handler/response_messages/api_message_response_helper.dart';
import 'package:wifi_smart_living/connectivity/network_connection_helper.dart';
import 'package:wifi_smart_living/const/const_api.dart';
import 'package:wifi_smart_living/http_helper/http_handler/https_request_helper.dart';
import 'package:wifi_smart_living/http_helper/http_header/http_header_helper.dart';
import 'package:wifi_smart_living/http_helper/uri_helper/uri_parser.dart';
import 'package:wifi_smart_living/jsonParser/messageParser/http_message_parser.dart';

import '../../../singelton/api_singelton.dart';
import '../../../validation/accessTokenValidation/access_token_validation.dart';

class DeleteUserAccountHelper {
  Future<DeleteAccountState> deleteUserAccount() async {
    DeleteAccountState responseState = DeleteAccountState.accountDeletet;
    if (await NetworkStateHelper.networkConnectionEstablished()) {
      if (AccessTokenValidation(token: ApiSingelton().getModelAccessToken)
          .tokenNochValide()) {
        Response? response =
            await HttpRequestHelper.deletedatabaseWithoutEntries(
                apiFunction: await UriParser.createUri(
                    apiFunction: ConstApi.deleteUserDel),
                httpHeader: await HttpHeaderHelper.createAccessTokenHeader(
                    xaccesstoken:
                        ApiSingelton().getModelAccessToken.tokenString));
        if (response != null && response.statusCode == 200) {
          int messageId = ApiResponses()
              .getMessageCode(message: HttpMessageParser.getMessage(response));
          if (messageId != ApiResponses.databaseEntrySuccesfulDeleted) {
            responseState = DeleteAccountState.networkConnectionIssue;
          }
        } else {
          responseState = DeleteAccountState.networkConnectionIssue;
        }
      } else {
        LoginHelperState loginHelperState = await LoginHelper().databaseLogin(
            userName: ApiSingelton().getDatabaseUserModel.userMailAdress,
            userPassword: ApiSingelton().getDatabaseUserModel.userPassowrd);
        if (loginHelperState == LoginHelperState.tokenErmittelt) {
          deleteUserAccount();
        } else {
          responseState = DeleteAccountState.deleteAccountIssue;
        }
      }
    } else {
      responseState = DeleteAccountState.networkConnectionIssue;
    }
    return responseState;
  }
}

enum DeleteAccountState {
  accountDeletet,
  networkConnectionIssue,
  deleteAccountIssue,
}
