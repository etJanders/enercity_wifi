// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wifi_smart_living/api_handler/api_treiber/login/login_helper.dart';
import 'package:wifi_smart_living/api_handler/api_treiber/user_management/get_self_helper.dart';
import 'package:wifi_smart_living/connectivity/network_connection_helper.dart';
import 'package:wifi_smart_living/const/const_secured_storage_identifier.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/presentation/create_user_account/create_user_account_page.dart';
import 'package:wifi_smart_living/presentation/display_notification/display_notification_page.dart';
import 'package:wifi_smart_living/presentation/general_widgets/checkBoxen/default_check_box.dart';
import 'package:wifi_smart_living/presentation/general_widgets/click_buttons/click_button_empty.dart';
import 'package:wifi_smart_living/presentation/general_widgets/editTextWidgets/edit_mail_text_widget.dart';
import 'package:wifi_smart_living/presentation/general_widgets/editTextWidgets/edit_password_text_widget.dart';
import 'package:wifi_smart_living/presentation/general_widgets/image_container/home_image.dart';
import 'package:wifi_smart_living/presentation/general_widgets/loading_spinner/loading_circle.dart';
import 'package:wifi_smart_living/theme.dart';
import 'package:wifi_smart_living/validation/general/login_validation.dart';

import '../../bloc/login/login_bloc.dart';
import '../../singelton/api_singelton.dart';
import '../../storage_helper/secured_storage_helper.dart';
import '../alert_dialogs/alert_dialog_information.dart';
import '../general_widgets/textWidgets/clickebal_text_widget.dart';
import '../home_page/indoor/homepage_indoor_page.dart';
import '../mail_verification/mail_verification_page.dart';
import '../mail_verification/model_user_data.dart';
import '../password_reset/password_reset_page.dart';

///Description
///Enter user mail and password to start login,  Login Page content
///
///Author: J. Anders
///created: 30-11-2022
///changed: 30-11-2022
///
///History:
///
///Notes:
///
class LoginPageContent extends StatefulWidget {
  const LoginPageContent({super.key});

  @override
  State<LoginPageContent> createState() => _LoginPageContentState();
}

class _LoginPageContentState extends State<LoginPageContent> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  late bool stayLoggedIn;

  static const int firstTimeOut = 5;
  static const int secondTimeOut = 8;
  static const int thirdTimeOut = 9;
  static const int addedOneMinute = 1;
  static const int addedTowMinutes = 2;
  static const int addedFiveMinutes = 5;
  static const String timeOutActive = "1";
  static const String timeOutInactive = "0";

  @override
  void initState() {
    //Check if custome data are added
    SecuredStorageHelper helper = SecuredStorageHelper();
    helper
        .readSecuredStorageData(key: ConstSecuredStoreageID.storedMailAdress)
        .then((value) => emailController.text = value);
    helper
        .readSecuredStorageData(
            key: ConstSecuredStoreageID.storedPasswordAdress)
        .then((value) => passwordController.text = value);
    stayLoggedIn = true;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    LoadingCicle loadingCicle = LoadingCicle(context: context);
    SecuredStorageHelper helper = SecuredStorageHelper();
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) async {
        if (state is LoginResponse) {
          loadingCicle.animationDismiss();
          LoginHelperState loginState = state.loginState;
          if (loginState == LoginHelperState.benutzerNochNichtAktiviert) {
            //   Todo workflow is buggy, UIs not working.
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: ((context) => const MailVerificationPage()),
                settings: RouteSettings(
                  arguments: ModelUserData(
                      mail: emailController.text,
                      password: passwordController.text),
                ),
              ),
            );
          } else if (loginState == LoginHelperState.httpError) {
            InformationAlert().showAlertDialog(
                context: context, message: local.oopsError, callback: () {});
          } else if (loginState == LoginHelperState.zugangsdatenFalsch) {
            String attempts = await helper.readSecuredStorageData(
                key: ConstSecuredStoreageID.loginAttemptCounter);
            if (attempts.isEmpty) {
              helper.storeData(
                  key: ConstSecuredStoreageID.loginAttemptCounter,
                  value: timeOutActive);
            } else {
              int attemptsInt = int.parse(attempts);
              attemptsInt = attemptsInt + 1;
              print(attemptsInt);
              if (attemptsInt == firstTimeOut) {
                final today = DateTime.now();
                final fiveMainsAddedTimeStamp = today
                    .add(const Duration(minutes: addedOneMinute))
                    .microsecondsSinceEpoch;
                helper.storeData(
                    key: ConstSecuredStoreageID.loginTimeStamp,
                    value: fiveMainsAddedTimeStamp.toString());
                helper.storeData(
                    key: ConstSecuredStoreageID.loginTimeOutPresent,
                    value: timeOutActive);
              } else if (attemptsInt == secondTimeOut) {
                final today = DateTime.now();
                final fiveMainsAddedTimeStamp = today
                    .add(const Duration(minutes: addedTowMinutes))
                    .microsecondsSinceEpoch;
                helper.storeData(
                    key: ConstSecuredStoreageID.loginTimeStamp,
                    value: fiveMainsAddedTimeStamp.toString());
                helper.storeData(
                    key: ConstSecuredStoreageID.loginTimeOutPresent,
                    value: timeOutActive);
              } else if (attemptsInt > thirdTimeOut) {
                final today = DateTime.now();
                final fiveMainsAddedTimeStamp = today
                    .add(const Duration(minutes: addedFiveMinutes))
                    .microsecondsSinceEpoch;
                helper.storeData(
                    key: ConstSecuredStoreageID.loginTimeStamp,
                    value: fiveMainsAddedTimeStamp.toString());
                helper.storeData(
                    key: ConstSecuredStoreageID.loginTimeOutPresent,
                    value: timeOutActive);
              } else {
                helper.storeData(
                    key: ConstSecuredStoreageID.loginTimeOutPresent,
                    value: timeOutInactive);
              }
              helper.storeData(
                  key: ConstSecuredStoreageID.loginAttemptCounter,
                  value: attemptsInt.toString());
            }
            InformationAlert().showAlertDialog(
                context: context,
                message: local.emailOrPasswordNotEntered,
                callback: () {});
          } else if (loginState == LoginHelperState.tokenErmittelt) {
            helper.storeData(
                key: ConstSecuredStoreageID.loginAttemptCounter,
                value: timeOutInactive);
            helper.storeData(
                key: ConstSecuredStoreageID.loginTimeOutPresent,
                value: timeOutInactive);
            BlocProvider.of<LoginBloc>(context).add(DetermineSelfEvent(
                token: ApiSingelton().getModelAccessToken,
                password: passwordController.text));
          }
        } else if (state is GetSelfResponseState) {
          GetSelfState getSelfState = state.getSelfResponse;
          if (getSelfState == GetSelfState.getSelfDetermined) {
            String isFirstInstall = await helper.readSecuredStorageData(
                key: ConstSecuredStoreageID.installStatusCheck);

            SharedPreferences sp = await SharedPreferences.getInstance();
            int installCase = sp.getInt("myKey") ?? 0;
            var singleton = ApiSingelton();
            if (installCase == 0 &&
                !singleton.getDatabaseUserModel.notification) {
              Navigator.of(context)
                  .popAndPushNamed(DisplayNotificationPage.routName);
            } else {
              Navigator.of(context)
                  .popAndPushNamed(HomepageIndoorPage.routName);
            }
          } else {
            InformationAlert().showAlertDialog(
                context: context, message: local.oopsError, callback: () {});
          }
        } else {
          InformationAlert().showAlertDialog(
              context: context,
              message: local.noInternetConnectionAvaialable,
              callback: () {});
        }
      },
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HomeImage(),
                const SizedBox(
                  height: Dimens.sizedBoxBigDefault,
                ),
                Form(
                  child: Column(
                    children: [
                      EditEmailTextInput(
                          emailController: emailController,
                          hintText: local.email),
                      const SizedBox(
                        height: Dimens.sizedBoxDefault,
                      ),
                      EditPasswortTextInput(
                          passwordEditingControler: passwordController,
                          hintText: local.password),
                    ],
                  ),
                ),
                const SizedBox(
                  height: Dimens.sizedBoxBigDefault,
                ),
                ClickedText(
                    text: local.forgotPassword,
                    textColor: AppTheme.violet,
                    onClick: () {
                      Navigator.of(context)
                          .pushNamed(PasswordResetPage.routName);
                    }),
                const SizedBox(
                  height: Dimens.sizedBoxDefault,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(local.stayLoggedIn, style: AppTheme.textStyleDefault),
                    CustomeCheckBox(
                        initState: stayLoggedIn,
                        callback: (value) {
                          setState(() {
                            stayLoggedIn = value;
                          });
                        }),
                  ],
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ClickButton(
                        buttonText: local.register,
                        buttonFunktion: () {
                          Navigator.of(context).pushNamed(
                              CreateUserAccountViewPagerPage.routName);
                        },
                        width: Dimens.clickButtonSize),
                    ClickButton(
                        buttonText: local.login,
                        buttonFunktion: () async {
                          if (await helper.readSecuredStorageData(
                                  key: ConstSecuredStoreageID
                                      .loginTimeOutPresent) ==
                              "1") {
                            if (int.parse(await helper.readSecuredStorageData(
                                    key: ConstSecuredStoreageID
                                        .loginTimeStamp)) <
                                int.parse(DateTime.now()
                                    .microsecondsSinceEpoch
                                    .toString())) {
                              LoginValidationState state = LoginValidation()
                                  .validateEmailAndPassword(
                                      email: emailController.text,
                                      password: passwordController.text);
                              //check Login-Validation aus

                              if (state == LoginValidationState.emptyEntries) {
                                InformationAlert().showAlertDialog(
                                    context: context,
                                    message: local.emailOrPasswordNotEntered,
                                    callback: () {});
                              } else if (state ==
                                  LoginValidationState.wrongMailFormat) {
                              } else if (state ==
                                  LoginValidationState.validated) {
                                if (await NetworkStateHelper
                                    .networkConnectionEstablished()) {
                                  loadingCicle
                                      .showAnimation(local.loginProgress);
                                  BlocProvider.of<LoginBloc>(context).add(
                                      StartLoginEvent(
                                          email: emailController.text,
                                          password: passwordController.text,
                                          stayLoggedIn: stayLoggedIn));
                                } else {
                                  InformationAlert().showAlertDialog(
                                      context: context,
                                      message:
                                          local.noInternetConnectionAvaialable,
                                      callback: () {});
                                }
                              }
                            } else {
                              InformationAlert().showAlertDialog(
                                  context: context,
                                  message: local.waitForTimeOut,
                                  callback: () {});
                            }
                          } else {
                            LoginValidationState state = LoginValidation()
                                .validateEmailAndPassword(
                                    email: emailController.text,
                                    password: passwordController.text);
                            //check Login-Validation aus
                            if (state == LoginValidationState.emptyEntries) {
                              InformationAlert().showAlertDialog(
                                  context: context,
                                  message: local.emailOrPasswordNotEntered,
                                  callback: () {});
                            } else if (state ==
                                LoginValidationState.wrongMailFormat) {
                            } else if (state ==
                                LoginValidationState.validated) {
                              if (await NetworkStateHelper
                                  .networkConnectionEstablished()) {
                                loadingCicle.showAnimation(local.loginProgress);
                                BlocProvider.of<LoginBloc>(context).add(
                                    StartLoginEvent(
                                        email: emailController.text,
                                        password: passwordController.text,
                                        stayLoggedIn: stayLoggedIn));
                              } else {
                                InformationAlert().showAlertDialog(
                                    context: context,
                                    message:
                                        local.noInternetConnectionAvaialable,
                                    callback: () {});
                              }
                            }
                          }
                        },
                        width: Dimens.clickButtonSize)
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
