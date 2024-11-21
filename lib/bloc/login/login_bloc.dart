// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wifi_smart_living/api_handler/api_treiber/login/login_helper.dart';
import 'package:wifi_smart_living/const/const_secured_storage_identifier.dart';
import 'package:wifi_smart_living/storage_helper/secured_storage_helper.dart';
import '../../api_handler/api_treiber/user_management/get_self_helper.dart';
import '../../models/accessToken/model_access_token.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  late String password = "";
  LoginBloc() : super(LoginInitial()) {
    on<StartLoginEvent>((event, emit) async {
      password = event.password;
      LoginHelperState state = await LoginHelper()
          .databaseLogin(userName: event.email, userPassword: event.password);
      if (event.stayLoggedIn && state == LoginHelperState.tokenErmittelt) {
        SecuredStorageHelper helper = SecuredStorageHelper();
        await helper.storeData(
            key: ConstSecuredStoreageID.storedMailAdress, value: event.email);
        await helper.storeData(
            key: ConstSecuredStoreageID.storedPasswordAdress,
            value: event.password);
      }
      emit(LoginResponse(loginState: state));
    });

    on<DetermineSelfEvent>((event, emit) async {
      GetSelfHelper getSelfHelper = GetSelfHelper();
      GetSelfState state = await getSelfHelper.callGetSelf(
          token: event.token, password: password);
      emit(GetSelfResponseState(getSelfResponse: state));
    });
  }
}
