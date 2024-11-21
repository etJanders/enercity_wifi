import 'package:http/http.dart';
import 'package:wifi_smart_living/api_handler/api_treiber/login/login_helper.dart';
import 'package:wifi_smart_living/api_handler/api_treiber/login/service_user_token.dart';
import 'package:wifi_smart_living/const/const_api.dart';
import 'package:wifi_smart_living/const/const_json_identifier.dart';
import 'package:wifi_smart_living/core/map_helper/map_builder.dart';
import 'package:wifi_smart_living/http_helper/http_handler/https_request_helper.dart';
import 'package:wifi_smart_living/http_helper/http_header/http_header_helper.dart';
import 'package:wifi_smart_living/http_helper/uri_helper/uri_parser.dart';
import 'package:wifi_smart_living/models/accessToken/model_access_token.dart';

import '../../../connectivity/network_connection_helper.dart';
import '../../../jsonParser/messageParser/http_message_parser.dart';
import '../../../singelton/api_singelton.dart';
import '../../../validation/accessTokenValidation/access_token_validation.dart';
import '../../response_messages/api_message_response_helper.dart';

///Description
///Start the mail changing process
///
///Author: J. Anders
///created: 05-01-2023
///changed: 05-01-2023
///
///History:
///
///Notes:
///
class ChangeUserMailHelper {
  late String newMailAdress = "";

  Future<ChangeUserMailState> setNewMailAdress(
      {required String newMail}) async {
    newMailAdress = newMail;
    ChangeUserMailState returnState = ChangeUserMailState.noInternetConnection;
    if (await NetworkStateHelper.networkConnectionEstablished()) {
      if (AccessTokenValidation(token: ApiSingelton().getModelAccessToken)
          .tokenNochValide()) {
        MapBuilder mapBuilder = MapBuilder();
        mapBuilder.addStingMapEntry(
            key: ConstJsonIdentifier.identifierUserMail, value: newMail);

        Response? httResponse = await HttpRequestHelper.putDatabaseEntries(
            apiFunction:
                await UriParser.createUri(apiFunction: ConstApi.updateSelfPut),
            httpHeader: await HttpHeaderHelper.createAccessTokenHeader(
                xaccesstoken: ApiSingelton().getModelAccessToken.tokenString),
            data: mapBuilder.getStringMap);
        if (httResponse != null && httResponse.statusCode == 200) {
          int messageId = ApiResponses().getMessageCode(
              message: HttpMessageParser.getMessage(httResponse));
          if (messageId == ApiResponses.mailAdressInUse) {
            returnState = ChangeUserMailState.mailAlreadyExists;
          } else if (messageId ==
              ApiResponses.updateMailVerificationTokenSent) {
            returnState = ChangeUserMailState.tokenSendToNewMail;
          } else if (messageId == ApiResponses.datasbaseNotAvaialable) {
            returnState = ChangeUserMailState.databaseIssue;
          } else {
            returnState = ChangeUserMailState.generalError;
          }
        } else {
          returnState = ChangeUserMailState.generalError;
        }
      } else {
        LoginHelperState loginHelperState = await LoginHelper().databaseLogin(
            userName: ApiSingelton().getDatabaseUserModel.userMailAdress,
            userPassword: ApiSingelton().getDatabaseUserModel.userPassowrd);
        if (loginHelperState == LoginHelperState.tokenErmittelt) {
          setNewMailAdress(newMail: newMail);
        } else {
          returnState = ChangeUserMailState.generalError;
        }
      }
    }
    return returnState;
  }

  Future<ChangeUserMailState> activateNewMailAdress(
      {required String activationToken}) async {
    ChangeUserMailState returnState = ChangeUserMailState.noInternetConnection;
    if (await NetworkStateHelper.networkConnectionEstablished()) {
      if (AccessTokenValidation(token: ApiSingelton().getModelAccessToken)
          .tokenNochValide()) {
        ModelAccessToken serviceuserToken =
            await ServiceUserTokenHelper().determineServiceUser();
        MapBuilder mapBuilder = MapBuilder();
        mapBuilder.addStingMapEntry(
            key: ConstJsonIdentifier.identifierUserMail,
            value: ApiSingelton().getDatabaseUserModel.userMailAdress);
        mapBuilder.addStingMapEntry(
            key: ConstJsonIdentifier.identifierUpdateToken,
            value: activationToken);

        Response response = await HttpRequestHelper.postDatabaseEntries(
            apiFunction: await UriParser.createUri(
                apiFunction: ConstApi.validateUserMail),
            httpHeader: await HttpHeaderHelper.createAccessTokenHeader(
                xaccesstoken: serviceuserToken.tokenString),
            data: mapBuilder.getStringMap);
        if (response.statusCode == 200) {
          int messageId = ApiResponses()
              .getMessageCode(message: HttpMessageParser.getMessage(response));
          if (messageId == ApiResponses.databaseEntrySuccesfulUpdated) {
            returnState = ChangeUserMailState.newMailActivated;
          } else if (messageId == ApiResponses.datasbaseNotAvaialable) {
            returnState = ChangeUserMailState.databaseIssue;
          } else {
            returnState = ChangeUserMailState.generalError;
          }
        } else {
          returnState = ChangeUserMailState.generalError;
        }
      } else {
        LoginHelperState loginHelperState = await LoginHelper().databaseLogin(
            userName: ApiSingelton().getDatabaseUserModel.userMailAdress,
            userPassword: ApiSingelton().getDatabaseUserModel.userPassowrd);
        if (loginHelperState == LoginHelperState.tokenErmittelt) {
          returnState = ChangeUserMailState.determineTokenAgain;
          activateNewMailAdress(activationToken: activationToken);
        } else {
          returnState = ChangeUserMailState.generalError;
        }
      }
    }
    return returnState;
  }

  Future<ChangeUserMailState> sendTokenAgain() async {
    return await setNewMailAdress(newMail: newMailAdress);
  }
}

enum ChangeUserMailState {
  generalError,
  databaseIssue,
  noInternetConnection,
  mailAlreadyExists,
  tokenSendToNewMail,
  newMailActivated,
  activationTokenWrong,
  activationTokenResent,
  determineTokenAgain,
}
