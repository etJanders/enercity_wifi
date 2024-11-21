import 'package:http/http.dart';
import 'package:wifi_smart_living/connectivity/network_connection_helper.dart';
import 'package:wifi_smart_living/const/const_api.dart';
import 'package:wifi_smart_living/http_helper/http_handler/https_request_helper.dart';
import 'package:wifi_smart_living/http_helper/http_header/http_header_helper.dart';
import 'package:wifi_smart_living/http_helper/uri_helper/uri_parser.dart';
import 'package:wifi_smart_living/singelton/api_singelton.dart';
import 'package:wifi_smart_living/validation/accessTokenValidation/access_token_validation.dart';

import '../../../helper/create_heating_profile/create_heating_profile_helper.dart';
import '../../../jsonParser/messageParser/http_message_parser.dart';
import '../../response_messages/api_message_response_helper.dart';
import '../login/login_helper.dart';

class CreateScheduleHelper {
  Future<CreateScheduleState> createNewSchedule(
      {required CreateHeatingProfileHelper helper}) async {
    CreateScheduleState state = CreateScheduleState.noInternetConnection;
    if (await NetworkStateHelper.networkConnectionEstablished()) {
      if (AccessTokenValidation(token: ApiSingelton().getModelAccessToken)
          .tokenNochValide()) {
        Response response = await HttpRequestHelper.postDatabaseEntries(
            apiFunction: await UriParser.createUri(
                apiFunction: ConstApi.createNewScheduleDataPost),
            httpHeader: await HttpHeaderHelper.createAccessTokenHeader(
                xaccesstoken: ApiSingelton().getModelAccessToken.tokenString),
            data: helper.toJson());
        if (response.statusCode == 200) {
          int messageId = ApiResponses()
              .getMessageCode(message: HttpMessageParser.getMessage(response));
          if (messageId == ApiResponses.entrySuccesfullCreated) {
            state = CreateScheduleState.succesfullCreated;
          } else {
            state = CreateScheduleState.generalError;
          }
        }
      } else {
        LoginHelperState loginHelperState = await LoginHelper().databaseLogin(
            userName: ApiSingelton().getDatabaseUserModel.userMailAdress,
            userPassword: ApiSingelton().getDatabaseUserModel.userPassowrd);
        if (loginHelperState == LoginHelperState.tokenErmittelt) {
          createNewSchedule(helper: helper);
        } else if (loginHelperState == LoginHelperState.zugangsdatenFalsch) {
          state = CreateScheduleState.userCredentialsChanged;
        } else {
          state = CreateScheduleState.generalError;
        }
      }
    }
    return state;
  }

  Future<CreateScheduleState> createNewHolidayProfile(
      {required CreateHeatingProfileHelper helper}) async {
    CreateScheduleState state = CreateScheduleState.noInternetConnection;
    if (await NetworkStateHelper.networkConnectionEstablished()) {
      if (AccessTokenValidation(token: ApiSingelton().getModelAccessToken)
          .tokenNochValide()) {
        Response response = await HttpRequestHelper.postDatabaseEntries(
            apiFunction: await UriParser.createUri(
                apiFunction: ConstApi.createNewScheduleDataPost),
            httpHeader: await HttpHeaderHelper.createAccessTokenHeader(
                xaccesstoken: ApiSingelton().getModelAccessToken.tokenString),
            data: helper.toHolidayJson());
        if (response.statusCode == 200) {
          int messageId = ApiResponses()
              .getMessageCode(message: HttpMessageParser.getMessage(response));
          if (messageId == ApiResponses.entrySuccesfullCreated) {
            state = CreateScheduleState.succesfullCreated;
          } else {
            state = CreateScheduleState.generalError;
          }
        }
      } else {
        LoginHelperState loginHelperState = await LoginHelper().databaseLogin(
            userName: ApiSingelton().getDatabaseUserModel.userMailAdress,
            userPassword: ApiSingelton().getDatabaseUserModel.userPassowrd);
        if (loginHelperState == LoginHelperState.tokenErmittelt) {
          state = CreateScheduleState.determineTokenAgain;
          createNewHolidayProfile(helper: helper);
        } else if (loginHelperState == LoginHelperState.zugangsdatenFalsch) {
          state = CreateScheduleState.userCredentialsChanged;
        } else {
          state = CreateScheduleState.generalError;
        }
      }
    }
    return state;
  }
}

enum CreateScheduleState {
  noInternetConnection,
  generalError,
  databaseError,
  succesfullCreated,
  userCredentialsChanged,
  determineTokenAgain,
}
