import 'package:wifi_smart_living/api_handler/api_treiber/login/login_helper.dart';
import 'package:wifi_smart_living/connectivity/network_connection_helper.dart';
import 'package:wifi_smart_living/const/const_api.dart';
import 'package:wifi_smart_living/http_helper/http_handler/https_request_helper.dart';
import 'package:wifi_smart_living/http_helper/http_header/http_header_helper.dart';
import 'package:wifi_smart_living/http_helper/uri_helper/uri_parser.dart';

import '../../../models/init_heating_profile/model_init_heating_profile.dart';
import '../../../singelton/api_singelton.dart';
import '../../../validation/accessTokenValidation/access_token_validation.dart';

class HeatingProfileHelper {
  Future<HeatingProfileState> initHeatingProfile(
      {required ModelInitHeatingProfile data}) async {
    HeatingProfileState state = HeatingProfileState.noInternetConnection;
    if (await NetworkStateHelper.networkConnectionEstablished()) {
      if (AccessTokenValidation(token: ApiSingelton().getModelAccessToken)
          .tokenNochValide()) {
        await HttpRequestHelper.postDatabaseEntries(
            apiFunction: await UriParser.createUri(
                apiFunction: ConstApi.createNewScheduleDataPost),
            httpHeader: await HttpHeaderHelper.createAccessTokenHeader(
                xaccesstoken: ApiSingelton().getModelAccessToken.tokenString),
            data: data.toJson());
      } else {
        LoginHelperState loginHelperState = await LoginHelper().databaseLogin(
            userName: ApiSingelton().getDatabaseUserModel.userMailAdress,
            userPassword: ApiSingelton().getDatabaseUserModel.userPassowrd);
        if (loginHelperState == LoginHelperState.tokenErmittelt) {
          state = HeatingProfileState.determineTokenAgain;
          initHeatingProfile(data: data);
        } else if (loginHelperState == LoginHelperState.zugangsdatenFalsch) {
          state = HeatingProfileState.userCredentialsChanged;
        } else {
          state = HeatingProfileState.noInternetConnection;
        }
      }
    }
    return state;
  }
}

enum HeatingProfileState {
  noInternetConnection,
  userCredentialsChanged,
  determineTokenAgain
}
