import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:wifi_smart_living/presentation/general_widgets/back_button_widget/back_button_widget.dart';
import 'package:wifi_smart_living/presentation/mail_verification/mail_verification_content_page.dart';
import 'package:wifi_smart_living/presentation/mail_verification/model_user_data.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../bloc/mail_activation/mail_activation_bloc.dart';

///Description
///If a user call login function but account is not activated this page will
///called to help the user to activate the user account
///
///Author: J. Anders
///created: 01-03-2023
///changed: 01-03-2023
///
///History:
///
///Notes:
///
///
class MailVerificationPage extends StatelessWidget {
  static const routName = '/mail_verification_page';
  const MailVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    ModelUserData userData =
        ModalRoute.of(context)!.settings.arguments as ModelUserData;

    return BlocProvider(
      create: (context) =>
          MailActivationBloc()..add(InitBlocEvent(modelUserData: userData)),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(local.activateUserAccount),
          leading: const BackButtonWidget(),
        ),
        body: const MailVerificationContent(),
      ),
    );
  }
}
