import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:wifi_smart_living/presentation/mail_verification/model_user_data.dart';

import '../../api_handler/api_treiber/change_email_notification/change_emial_notification_helper.dart';
import '../../api_handler/api_treiber/create_user_account/create_user_account_helper.dart';
import '../../api_handler/api_treiber/login/login_helper.dart';
import '../../const/const_api.dart';
import '../../const/const_secured_storage_identifier.dart';
import '../../http_helper/http_handler/https_request_helper.dart';
import '../../http_helper/http_header/http_header_helper.dart';
import '../../http_helper/uri_helper/uri_parser.dart';
import '../../jsonParser/databaseUser/parse_database_user.dart';
import '../../singelton/api_singelton.dart';
import '../../storage_helper/secured_storage_helper.dart';

part 'mail_activation_event.dart';
part 'mail_activation_state.dart';

class MailActivationBloc
    extends Bloc<MailActivationEvent, MailActivationState> {
  late ModelUserData modelUserData;
  CreateUserAccountHelper helper = CreateUserAccountHelper();
  late String userMail = "";
  late String userPassword = "";

  MailActivationBloc() : super(MailActivationInitial()) {
    on<InitBlocEvent>((event, emit) async {
      modelUserData = event.modelUserData;
      userMail = event.modelUserData.mail;
      userPassword = event.modelUserData.password;
      helper.initMailAdress(modelUserData.mail);
      //   emit(InitFinished());

      CreateAccountState state = await helper.refreshActivationToken();
      if (state == CreateAccountState.activationTokenRefreshed) {
        emit(TokenFistSentSuccessful());
      } else {
        emit(AccountActivationError(state: state));
      }
    });

    on<InitialActivationToken>((event, emit) async {
      CreateAccountState state = await helper.refreshActivationToken();
      if (state == CreateAccountState.activationTokenRefreshed) {
        emit(TokenFistSentSuccessful());
      } else {
        emit(AccountActivationError(state: state));
      }
    });

    on<ActivateUserAccount>((event, emit) async {
      CreateAccountState state =
          await helper.activateUserAccount(token: event.activationToken);
      if (state == CreateAccountState.accountSuccesfulActivated) {
        emit(UserAccountActivated());
      } else if (state == CreateAccountState.wrongToken) {
        emit(WrongActivationCodeError(state: state));
      } else {
        emit(AccountActivationError(state: state));
      }
    });

    on<RefreshingActivationToken>((event, emit) async {
      CreateAccountState state = CreateAccountState.activationIssue;
      state = await helper.refreshActivationToken();
      if (state == CreateAccountState.activationTokenRefreshed) {
        emit(TokenResent());
      } else {
        emit(TokenResendFailed());
      }
    });

    on<EnteringTokenEvent>((event, emit) async {
      CreateAccountState state =
          await helper.activateUserAccount(token: event.activationToken);
      if (state == CreateAccountState.accountSuccesfulActivated) {
        HttpRequestHelper.getDatabaseEntries(
            apiFunction:
                await UriParser.createUri(apiFunction: ConstApi.getSelfGet),
            httpHeader: await HttpHeaderHelper.createAccessTokenHeader(
                xaccesstoken: event.activationToken));
        emit(AccountActivatedSuccessfully());
      } else if (state == CreateAccountState.wrongToken) {
        emit(WrongActivationCodeError(state: state));
      } else {
        emit(AccountActivationError(state: state));
      }
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
            apiFunction:
                await UriParser.createUri(apiFunction: ConstApi.getSelfGet),
            httpHeader: await HttpHeaderHelper.createAccessTokenHeader(
                xaccesstoken: ApiSingelton().getModelAccessToken.tokenString),
          );
          singelton.initModeldatabaseUser(
              user: ParseDatabaseUser.converteDatabaseUser(
                  receivedMessage: response, password: userPassword));
          if (state ==
              ChangeMailNotificationState.notificationSuccesfullUpdated) {
            emit(EmailNotificationActivated());
          } else {
            emit(AccountActivationError(
                state: CreateAccountState.activationIssue));
          }
        } else {
          emit(AccountActivationError(
              state: CreateAccountState.activationIssue));
        }
      }
    });

    on<SaveDataAndNext>(
      (event, emit) async {
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
              apiFunction:
                  await UriParser.createUri(apiFunction: ConstApi.getSelfGet),
              httpHeader: await HttpHeaderHelper.createAccessTokenHeader(
                  xaccesstoken: ApiSingelton().getModelAccessToken.tokenString),
            );
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
          apiFunction:
              await UriParser.createUri(apiFunction: ConstApi.getSelfGet),
          httpHeader: await HttpHeaderHelper.createAccessTokenHeader(
              xaccesstoken: ApiSingelton().getModelAccessToken.tokenString),
        );

        emit(CallIntroductionScreen());
      },
    );
  }
}
