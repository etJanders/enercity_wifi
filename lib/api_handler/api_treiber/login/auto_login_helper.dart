import 'dart:async';

import 'package:wifi_smart_living/api_handler/api_treiber/login/login_helper.dart';
import 'package:wifi_smart_living/const/const_secured_storage_identifier.dart';
import 'package:wifi_smart_living/mqtt/broker_fallback/broker_url_helper.dart';
import 'package:wifi_smart_living/storage_helper/secured_storage_helper.dart';

///Description
///Logic for Auto Login
///
///Author: J. Anders
///created: 16-12-2022
///changed: 16-12-2022
///
///History:
///
///Notes:
class AutoLoginHelper {
  late String password = "";
  Future<AutoLoginState> autoLogin() async {
    AutoLoginState state = AutoLoginState.notDataStored;
    String determineUser = await SecuredStorageHelper()
        .readSecuredStorageData(key: ConstSecuredStoreageID.storedMailAdress);
    password = await SecuredStorageHelper().readSecuredStorageData(
        key: ConstSecuredStoreageID.storedPasswordAdress);
    if (determineUser.isNotEmpty && password.isNotEmpty) {
      try{
        LoginHelperState loginHelperState = await LoginHelper()
            .databaseLogin(userName: determineUser, userPassword: password)
            .timeout(const Duration(seconds: 8));
        state = checkLoginResponse(loginState: loginHelperState);
        await BrokerUrlHelper().clearDefaultUrl();
      }on TimeoutException catch (_) {
       return AutoLoginState.timeout;
      }

    }
    return state;
  }

  AutoLoginState checkLoginResponse({required LoginHelperState loginState}) {
    AutoLoginState state = AutoLoginState.notDataStored;
    if (LoginHelperState.tokenErmittelt == loginState) {
      state = AutoLoginState.autoLogginSuccessed;
    } else if (LoginHelperState.zugangsdatenFalsch == loginState) {
      state = AutoLoginState.credentialsWrong;
    }
    else{
      state = AutoLoginState.credentialsWrong;
    }
    return state;
  }
}

enum AutoLoginState {
  notDataStored, //Es sind keine Daten im Secured Storage abgelegt
  autoLogginSuccessed,
  credentialsWrong,
  timeout
}
enum PopUpState {
  popupPresent, //Es sind keine Daten im Secured Storage abgelegt
  popUpNotPresent,

}
