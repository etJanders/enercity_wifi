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
import '../user_management/user_account_activation.dart';

class CreateUserAccountHelper {
  late String userMail;

  Future<CreateAccountState> createUserAccount(
      {required String mail, required String password}) async {
    userMail = mail;
    CreateAccountState state = CreateAccountState.createAccountIssue;
    MapBuilder mapBuilder = MapBuilder();
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierUserMail, value: mail);
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierUserPassword, value: password);
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierUsedClient,
        value: {ConstApi.currentAppCode: true});

    //Determine Service User Token
    ModelAccessToken token =
        await ServiceUserTokenHelper().determineServiceUser();
    //Call ApI Function
    if (token.tokenString.isNotEmpty) {
      Response request = await HttpRequestHelper.postDatabaseEntries(
          apiFunction: await UriParser.createUri(
              apiFunction: ConstApi.createNewUserPost),
          httpHeader: await HttpHeaderHelper.createAccessTokenHeader(
              xaccesstoken: token.tokenString),
          data: mapBuilder.getDynamicMap);
      if (request.statusCode == 200) {
        int messageId = ApiResponses()
            .getMessageCode(message: HttpMessageParser.getMessage(request));
        if (messageId == ApiResponses.mailAlreadyExists) {
          state = CreateAccountState.mailAlreadyExists;
        } else if (messageId == ApiResponses.entrySuccesfullCreated) {





          state = CreateAccountState.successfulCreated;
        } else if (messageId == ApiResponses.datasbaseNotAvaialable) {
          state = CreateAccountState.databaseNotAvailable;
        }
      }
    }
    return state;
  }

  Future<CreateAccountState> activateUserAccount(
      {required String token}) async {
    CreateAccountState state = CreateAccountState.activationIssue;
    UserAccountActivationHelper helper = UserAccountActivationHelper();
    AccountActivationState activationState = await helper.activateUserAccount(
        mail: userMail, activationToken: token);
    if (activationState == AccountActivationState.accountSuccesfulActivated) {
      state = CreateAccountState.accountSuccesfulActivated;

    } else if (activationState ==
        AccountActivationState.enteredTokenIsNotCorrect) {
      state = CreateAccountState.wrongToken;
    }
    return state;
  }

  Future<CreateAccountState> refreshActivationToken() async {
    CreateAccountState state = CreateAccountState.activationIssue;
    UserAccountActivationHelper helper = UserAccountActivationHelper();
    AccountActivationState activationState =
        await helper.refreshActivationToken(mail: userMail);
    if (activationState == AccountActivationState.tokenHasResent) {
      state = CreateAccountState.activationTokenRefreshed;
    }
    return state;
  }

  void initMailAdress(String userMail) {
    this.userMail = userMail;
  }
}

enum CreateAccountState {
  createAccountIssue,
  activationIssue,
  mailAlreadyExists,
  successfulCreated,
  accountSuccesfulActivated,
  activationTokenRefreshed,
  notificationActivated,
  databaseNotAvailable,
  wrongToken,
}
