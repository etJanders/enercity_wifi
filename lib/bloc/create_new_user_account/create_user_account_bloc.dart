// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:wifi_smart_living/api_handler/api_treiber/login/login_helper.dart';
import 'package:wifi_smart_living/api_handler/api_treiber/user_management/update_self_helper.dart';
import 'package:wifi_smart_living/singelton/api_singelton.dart';
import '../../api_handler/api_treiber/change_email_notification/change_emial_notification_helper.dart';
import '../../api_handler/api_treiber/create_user_account/create_user_account_helper.dart';
import '../../const/const_api.dart';
import '../../const/const_secured_storage_identifier.dart';
import '../../http_helper/http_handler/https_request_helper.dart';
import '../../http_helper/http_header/http_header_helper.dart';
import '../../http_helper/uri_helper/uri_parser.dart';
import '../../jsonParser/databaseUser/parse_database_user.dart';
import '../../storage_helper/secured_storage_helper.dart';

part 'create_user_account_event.dart';
part 'create_user_account_state.dart';

///Description
///Bloc to control user account creation events
///
///Author: J. Anders
///created: 30-11-2022
///changed: 30-11-2022
///
///History:
///
///Notes:
class CreateUserAccountBloc
    extends Bloc<CreateUserAccountEvent, CreateUserAccountState> {
  CreateUserAccountHelper helper = CreateUserAccountHelper();

  late String userMail = "";
  late String userPassword = "";

  CreateUserAccountBloc() : super(CreateUserAccountInitial()) {
    on<CreateAccountEvent>((event, emit) async {
      userMail = event.userMail;
      userPassword = event.userPassword;
      CreateAccountState state = await helper.createUserAccount(
          mail: event.userMail, password: event.userPassword);
      if (state == CreateAccountState.successfulCreated) {

        emit(AccountCreated());
      } else {
        emit(AccountCreatedError(state: state));
      }
    });

    on<EnterTokenEvent>((event, emit) async {
      CreateAccountState state =
          await helper.activateUserAccount(token: event.activationToken);
      if (state == CreateAccountState.accountSuccesfulActivated) {

        HttpRequestHelper.getDatabaseEntries(
            apiFunction:
            await UriParser.createUri(apiFunction: ConstApi.getSelfGet),
            httpHeader: await HttpHeaderHelper.createAccessTokenHeader(
                xaccesstoken:event.activationToken));
        emit(AccountActivated());
      } else {
        emit(AccountCreatedError(state: state));
      }
    });

    on<RefreshActivationToken>((event, emit) async {
      CreateAccountState state = await helper.refreshActivationToken();
      if (state == CreateAccountState.activationTokenRefreshed) {
        emit(RefreshTokenSent());
      } else {
        emit(AccountCreatedError(state: state));
      }
    });

    on<SaveDataAndNext>((event, emit) async {
      if (userMail.isNotEmpty && userPassword.isNotEmpty) {
        LoginHelperState loginState = await LoginHelper()
            .databaseLogin(userName: userMail, userPassword: userPassword);
        if (loginState == LoginHelperState.tokenErmittelt) {
          ApiSingelton singelton = ApiSingelton();
          ChangeMailNotificationState state =
          await ChangeEmailNotifictaionHelper().updateNotificationState(
              email: userMail,
              notificationState: true,
              token: singelton.getModelAccessToken);

          Response response = await HttpRequestHelper.getDatabaseEntries(
            apiFunction: await UriParser.createUri(
                apiFunction: ConstApi.getSelfGet),
            httpHeader: await HttpHeaderHelper.createAccessTokenHeader(
                xaccesstoken: ApiSingelton().getModelAccessToken.tokenString),
          );
          await UpdateSelfHelper().updateSelfMulti(
              token: ApiSingelton().getModelAccessToken.tokenString);
          await UpdateSelfHelper().updateSelfUsedClient(
              token: ApiSingelton().getModelAccessToken.tokenString);
          singelton.initModeldatabaseUser(
              user: ParseDatabaseUser.converteDatabaseUser(
                  receivedMessage: response, password: userPassword));
        }
      }
      SecuredStorageHelper helper = SecuredStorageHelper();
      await helper.storeData(
          key: ConstSecuredStoreageID.storedMailAdress, value: userMail);
      await helper.storeData(
          key: ConstSecuredStoreageID.storedPasswordAdress,
          value: userPassword);
      Response response = await HttpRequestHelper.getDatabaseEntries(
        apiFunction: await UriParser.createUri(
            apiFunction: ConstApi.getSelfGet),
        httpHeader: await HttpHeaderHelper.createAccessTokenHeader(
            xaccesstoken: ApiSingelton().getModelAccessToken.tokenString),
      );

      emit(CallIntroductionScreen());
    });

    on<EnableEmailNotification>((event, emit) async {
      if (userMail.isNotEmpty && userPassword.isNotEmpty) {
        LoginHelperState loginState = await LoginHelper()
            .databaseLogin(userName: userMail, userPassword: userPassword);
        if (loginState == LoginHelperState.tokenErmittelt) {
          ApiSingelton singelton = ApiSingelton();
          ChangeMailNotificationState state =
              await ChangeEmailNotifictaionHelper().updateNotificationState(
                  email: userMail,
                  notificationState: true,
                  token: singelton.getModelAccessToken);

          Response response = await HttpRequestHelper.getDatabaseEntries(
            apiFunction: await UriParser.createUri(
                apiFunction: ConstApi.getSelfGet),
            httpHeader: await HttpHeaderHelper.createAccessTokenHeader(
                xaccesstoken: ApiSingelton().getModelAccessToken.tokenString),
          );
          singelton.initModeldatabaseUser(
              user: ParseDatabaseUser.converteDatabaseUser(
                  receivedMessage: response, password:userPassword));
          if (state ==
              ChangeMailNotificationState.notificationSuccesfullUpdated) {
            emit(EmailNotificationActivated());
          } else {
            emit(
                AccountCreatedError(state: CreateAccountState.activationIssue));
          }
        } else {
          emit(AccountCreatedError(state: CreateAccountState.activationIssue));
        }
      }
    });
  }
}
