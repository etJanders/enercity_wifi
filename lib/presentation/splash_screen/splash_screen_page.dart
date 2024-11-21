import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_smart_living/presentation/splash_screen/splash_screen_content.dart';

import '../../bloc/auto_login_bloc/auto_login_bloc.dart';

///Description
///Splasg Screen is shown every time after app is startet from scratch
///If user data are stored the app should do a auto-login
///
///Author: Julian Anders
///created: 29-11-2022
///changed: 29-11-2022
///
///History:
///
///Nodes:
///
class SplashScreenPage extends StatelessWidget {
  static const String routname = "/splash_page";
  const SplashScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AutoLoginBloc()..add(AutoLoginInitEvent()),
      child: const SplashScreenContent(),
    );
  }
}
