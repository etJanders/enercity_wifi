import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wifi_smart_living/bloc/login/login_bloc.dart';
import 'package:wifi_smart_living/presentation/login/login_page_content.dart';

///Description
///Login Page Init Bloc and manage ui content
///
///Author: J. Anders
///created: 01-11-2022
///changed: 01-11-2022
///
///History:
///
///Notes:
///
class LoginPage extends StatelessWidget {
  static const String routName = "/route_login_page";
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(local.login),
        ),
        body: const LoginPageContent(),
      ),
    );
  }
}
