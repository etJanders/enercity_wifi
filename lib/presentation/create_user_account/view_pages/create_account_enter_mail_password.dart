import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wifi_smart_living/bloc/create_new_user_account/create_user_account_bloc.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/presentation/alert_dialogs/alert_dialog_double_message.dart';
import 'package:wifi_smart_living/presentation/general_widgets/checkBoxen/default_check_box.dart';
import 'package:wifi_smart_living/presentation/general_widgets/click_buttons/click_button_colored.dart';
import 'package:wifi_smart_living/presentation/general_widgets/editTextWidgets/edit_mail_text_widget.dart';
import 'package:wifi_smart_living/presentation/general_widgets/editTextWidgets/edit_password_text_widget.dart';
import 'package:wifi_smart_living/presentation/general_widgets/image_container/home_image.dart';
import 'package:wifi_smart_living/presentation/general_widgets/loading_spinner/loading_circle.dart';
import 'package:wifi_smart_living/theme.dart';

import '../../../api_handler/api_treiber/create_user_account/create_user_account_helper.dart';
import '../../../const/const_web_url.dart';
import '../../../http_helper/uri_helper/uri_parser.dart';
import '../../../validation/general/create_user_validator.dart';
import '../../alert_dialogs/alert_dialog_information.dart';
import '../../general_widgets/back_button_widget/back_button_widget.dart';
import '../../web_viewer/web_view_page.dart';

///Description
///UI to enter user mail and password to create a new dtabase account
///
///Author: J. Anders
///created: 30-11-2022
///changed: 13-12-2022
///
///History:
///13-12-2022 Option to confirm entered mail adress
///
///Notes:
///
class EnterMailAndPasswordPage extends StatefulWidget {
  final Function callbackFunction;
  const EnterMailAndPasswordPage({super.key, required this.callbackFunction});

  @override
  State<EnterMailAndPasswordPage> createState() =>
      _EnterMailAndPasswordPageState();
}

class _EnterMailAndPasswordPageState extends State<EnterMailAndPasswordPage> {
  bool _agbInit = false;
  final emailControler = TextEditingController();
  final confirmEmailControler = TextEditingController();
  final passwordControler = TextEditingController();
  final confirmPasswordController = TextEditingController();

  late LoadingCicle loadingCicle;

  @override
  void initState() {
    super.initState();
    _agbInit = true;
  }

  @override
  Widget build(BuildContext context) {
    loadingCicle = LoadingCicle(context: context);
    AppLocalizations local = AppLocalizations.of(context)!;
    return BlocConsumer<CreateUserAccountBloc, CreateUserAccountState>(
      listener: (context, state) {
        loadingCicle.animationDismiss();
        if (state is AccountCreated) {
          //Go forward to next step
          InformationAlertDoubleMessage().showAlertDialog(
              context: context,
              message: local.emailActivationToken,
              subMessage: local.spamHint,
              callback: () {
                widget.callbackFunction();
              });
        } else if (state is AccountCreatedError) {
          CreateAccountState errorState = state.state;
          if (errorState == CreateAccountState.mailAlreadyExists) {
            InformationAlert().showAlertDialog(
                context: context,
                message: local.mailAlreadyExists,
                callback: () {});
          } else {
            InformationAlert().showAlertDialog(
                context: context, message: local.oopsError, callback: () {});
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
                leading: const BackButtonWidget(),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(local.createAccount),
                    Text(
                      local.registration,
                      style: AppTheme.textStyleDefault,
                    ),
                  ],
                )),
            body: SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.all(Dimens.paddingDefault),
              child: Column(
                children: [
                  const HomeImage(),
                  const SizedBox(
                    height: Dimens.sizedBoxBigDefault,
                  ),
                  Form(
                    child: Column(
                      children: [
                        EditEmailTextInput(
                            emailController: emailControler,
                            hintText: local.email),
                        const SizedBox(
                          height: Dimens.sizedBoxDefault,
                        ),
                        EditEmailTextInput(
                            emailController: confirmEmailControler,
                            hintText: local.confirmEmail),
                        const SizedBox(
                          height: Dimens.sizedBoxDefault,
                        ),
                        EditPasswortTextInput(
                            passwordEditingControler: passwordControler,
                            hintText: local.password),
                        const SizedBox(
                          height: Dimens.sizedBoxDefault,
                        ),
                        EditPasswortTextInput(
                            passwordEditingControler: confirmPasswordController,
                            hintText: local.confirmPassword),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: Dimens.sizedBoxDefault,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            text: local.accepTermsAndContitionsOne,
                            style: AppTheme.textStyleDefault,
                            children: [
                              TextSpan(
                                  text: local.termsAndConditions,
                                  style: AppTheme.textStyleColoredUnderlined,
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      canLaunchUrl(UriParser.createBasicUri(
                                              url: ConstWebUrls
                                                  .webUrlTermsAndContitions))
                                          .then((value) async {
                                        if (value) {
                                          await launchUrl(
                                              UriParser.createBasicUri(
                                                  url: ConstWebUrls
                                                      .webUrlTermsAndContitions));
                                        } else {
                                          Navigator.of(context).push(MaterialPageRoute(
                                              builder: ((context) => WebViewPage(
                                                  title:
                                                      local.termsAndConditions,
                                                  webUrl: ConstWebUrls
                                                      .webUrlTermsAndContitions))));
                                        }
                                      });
                                    }),
                              TextSpan(
                                  text: local.andThe,
                                  style: AppTheme.textStyleDefault),
                              TextSpan(
                                  text: local.privacyPolicy,
                                  style: AppTheme.textStyleColoredUnderlined,
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      canLaunchUrl(UriParser.createBasicUri(
                                              url: ConstWebUrls
                                                  .webUrlPrivacyPolicy))
                                          .then((value) async {
                                        if (value) {
                                          await launchUrl(
                                              UriParser.createBasicUri(
                                                  url: ConstWebUrls
                                                      .webUrlPrivacyPolicy));
                                        } else {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: ((context) =>
                                                      WebViewPage(
                                                          title: local
                                                              .privacyPolicy,
                                                          webUrl: ConstWebUrls
                                                              .webUrlPrivacyPolicy))));
                                        }
                                      });
                                    }),
                              const TextSpan(text: " ."),
                            ]),
                      )),
                      CustomeCheckBox(
                          initState: _agbInit,
                          callback: (value) {
                            _agbInit = value;
                          })
                    ],
                  ),
                  // const Spacer(),
                  const SizedBox(
                    height: Dimens.containerHight,
                  ),
                  ClickButtonFilled(
                      buttonText: local.register,
                      buttonFunktion: () {
                        ValidateCreateUserAccount validData =
                            ValidateCreateUserAccount(
                                userMail: emailControler.text,
                                confirmUserMail: confirmEmailControler.text,
                                userPassword: passwordControler.text,
                                confirmedPassword:
                                    confirmPasswordController.text,
                                agbState: _agbInit);
                        ValidateCreateUserState state =
                            validData.validateData();
                        if (state ==
                            ValidateCreateUserState.allInformationValide) {
                          loadingCicle
                              .showAnimation(local.createNewUserAccountLoading);
                          BlocProvider.of<CreateUserAccountBloc>(context).add(
                              CreateAccountEvent(
                                  userMail: emailControler.text,
                                  userPassword: passwordControler.text));
                        } else if (state ==
                                ValidateCreateUserState.agbNotaccepted ||
                            state == ValidateCreateUserState.emptyFields) {
                          InformationAlert().showAlertDialog(
                              context: context,
                              message: local.createAccountError,
                              callback: () {});
                        } else if (state ==
                            ValidateCreateUserState.passwordNotSame) {
                          InformationAlert().showAlertDialog(
                              context: context,
                              message: local.passwordNotSame,
                              callback: () {});
                        } else if (state ==
                            ValidateCreateUserState.emailNotValide) {
                          InformationAlert().showAlertDialog(
                              context: context,
                              message: local.wrongEmailFormat,
                              callback: () {});
                        } else if (state ==
                            ValidateCreateUserState.passwordNotValide) {
                          InformationAlert().showAlertDialog(
                              context: context,
                              message: local.passwordWrongFormat,
                              callback: () {});
                        } else if (state ==
                            ValidateCreateUserState.mailNotSame) {
                          InformationAlert().showAlertDialog(
                              context: context,
                              message: local.enteredMailNotSame,
                              callback: () {});
                        }
                      },
                      width: double.infinity)
                ],
              ),
            )));
      },
    );
  }
}
