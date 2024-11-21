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
import 'package:wifi_smart_living/singelton/api_singelton.dart';

import '../../core/platformHelper/platform_helper.dart';
import '../../jsonParser/accessToken/parse_access_token.dart';
import '../../jsonParser/messageParser/http_message_parser.dart';
import '../response_messages/api_message_respons_detection.dart';
import '../response_messages/api_message_response_helper.dart';
import 'login/login_helper.dart';

class PasswordResetApiHelper {
  Future<PasswordResetRespnseState> determineResetToken(
      {required String userMail}) async {
    PasswordResetRespnseState resetState =
        PasswordResetRespnseState.noInternetConnection;
    if (await NetworkStateHelper.networkConnectionEstablished()) {
      ModelAccessToken accessToken =
          await ServiceUserTokenHelper().determineServiceUser();
      if (accessToken.tokenString.isNotEmpty) {
        MapBuilder mapBuilder = MapBuilder();
        mapBuilder.addDynamicMapEntry(
            key: ConstJsonIdentifier.identifierUserMail, value: userMail);

        Response response = await HttpRequestHelper.postDatabaseEntries(
            apiFunction:
                await UriParser.createUri(apiFunction: ConstApi.passwordReset),
            httpHeader: await HttpHeaderHelper.createAccessTokenHeader(
                xaccesstoken: accessToken.tokenString),
            data: mapBuilder.getDynamicMap);
        if (response.statusCode == 200) {
          int messageId = ApiResponses()
              .getMessageCode(message: HttpMessageParser.getMessage(response));
          if (messageId == ApiResponses.passwordResetTokenSent) {
            resetState = PasswordResetRespnseState.resetTokenSent;
          } else if (messageId == ApiResponses.userDoseNotExists) {
            resetState = PasswordResetRespnseState.userNotExists;
          } else {
            resetState = PasswordResetRespnseState.generalError;
          }
        } else {
          resetState = PasswordResetRespnseState.generalError;
        }
      } else {
        resetState = PasswordResetRespnseState.generalError;
      }
    }
    return resetState;
  }

  Future<ResetTokenGeneration> determienLoginToken(
      {required String mail, required String resetToken}) async {
    PasswordResetRespnseState state = PasswordResetRespnseState.idleState;
    ModelAccessToken token = ModelAccessToken(
        tokenString: '',
        tokenDescription: '',
        serviceToken: false,
        tokenCreatedTime: 0);
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
            mail: mail, password: resetToken));
    if (response.statusCode == 200) {
      if (!ApiMessageresponseDetection().responeMessageEmpfangen(response)) {
        state = PasswordResetRespnseState.tokenAccepted;
        token = ParseAccessToken.converteToken(
            receivedMessage: response, serviceUser: false);
      } else {
        state = PasswordResetRespnseState.tokenError;
      }
    }
    return ResetTokenGeneration(state: state, accessToken: token);
  }

  Future<PasswordResetRespnseState> changeUserPasswordReset(
      {required ModelAccessToken token, required String password}) async {
    PasswordResetRespnseState state =
        PasswordResetRespnseState.noInternetConnection;
    if (await NetworkStateHelper.networkConnectionEstablished()) {
      MapBuilder mapBuilder = MapBuilder();
      mapBuilder.addDynamicMapEntry(
          key: ConstJsonIdentifier.identifierUserPassword, value: password);
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
          state = PasswordResetRespnseState.passwordChanged;
        } else if (messageId == ApiResponses.newPasswordEqualsOldPassword) {
          state = PasswordResetRespnseState.passwordKnown;
        } else {
          state = PasswordResetRespnseState.generalError;
        }
      }
    }
    return state;
  }

  Future<PasswordResetRespnseState> changeUserPassword(
      {required String password,required String oldPassword}) async {


    PasswordResetRespnseState state =
        PasswordResetRespnseState.noInternetConnection;

    if (await NetworkStateHelper.networkConnectionEstablished()) {

      LoginHelperState loginHelperState = await LoginHelper().databaseLogin(
          userName: ApiSingelton().getDatabaseUserModel.userMailAdress,
          userPassword: oldPassword);
      if (loginHelperState == LoginHelperState.tokenErmittelt) {
        MapBuilder mapBuilder = MapBuilder();
        mapBuilder.addDynamicMapEntry(
            key: ConstJsonIdentifier.identifierUserPassword, value: password);
        Response? response = await HttpRequestHelper.putDatabaseEntries(
            apiFunction:
            await UriParser.createUri(apiFunction: ConstApi.updateSelfPut),
            httpHeader: await HttpHeaderHelper.createAccessTokenHeader(
                xaccesstoken: ApiSingelton().getModelAccessToken.tokenString),
            data: mapBuilder.getDynamicMap);
        if (response != null && response.statusCode == 200) {
          int messageId = ApiResponses()
              .getMessageCode(message: HttpMessageParser.getMessage(response));
          if (messageId == ApiResponses.databaseEntrySuccesfulUpdated) {
            state = PasswordResetRespnseState.passwordChanged;
          } else if (messageId == ApiResponses.newPasswordEqualsOldPassword) {
            state = PasswordResetRespnseState.passwordKnown;
          } else {
            state = PasswordResetRespnseState.generalError;
          }
        }
      } else if (loginHelperState == LoginHelperState.zugangsdatenFalsch){
        state = PasswordResetRespnseState.wrongOldPassword;
      }
      else{
        state = PasswordResetRespnseState.generalError;
      }
    }
    return state;
  }
}

enum PasswordResetRespnseState {
  noInternetConnection,
  userNotExists,
  resetTokenSent,
  generalError,
  passwordKnown,
  passwordChanged,
  tokenAccepted,
  idleState,
  tokenError,
  wrongOldPassword,
}

class ResetTokenGeneration {
  final PasswordResetRespnseState state;
  final ModelAccessToken accessToken;

  ResetTokenGeneration({required this.state, required this.accessToken});
}
