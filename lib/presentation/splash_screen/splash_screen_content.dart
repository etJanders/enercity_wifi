import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_smart_living/presentation/general_widgets/image_container/splash_image.dart';
import 'package:wifi_smart_living/presentation/home_page/indoor/homepage_indoor_page.dart';

import '../../bloc/auto_login_bloc/auto_login_bloc.dart';
import '../login/login_page.dart';
import '../maintainanace_display/display_maintainance_message.dart';

///Description
///Content of Solash Screen Page
///make a auto login if user data a known
///
///Author: J. Anders
///created: 29-11-2022
///changed: 29-11-2022
///
///History:
///
///Notes:
class SplashScreenContent extends StatelessWidget {
  const SplashScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AutoLoginBloc, AutoLoginBlocState>(
      listener: (context, state) {
        if (state is AutoLoginSuccessState) {
          //Call auto login
          BlocProvider.of<AutoLoginBloc>(context)
              .add(DetermineSelfDataFromDatabase());
        } else if (state is GetSelfeCalledState) {
          BlocProvider.of<AutoLoginBloc>(context)
              .add(DeterminePopUpStatusForAutoLogin());
        } else if (state is PopUpStateFalse) {
          Navigator.of(context).popAndPushNamed(HomepageIndoorPage.routName);
        } else if (state is PopUpManualStateFalse) {
          Navigator.of(context).popAndPushNamed(LoginPage.routName);
        } else if (state is PopUpManualStateSuccess) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) =>
                      const DisplayMaintainancePage(loginType: "manual")),
              (Route<dynamic> route) => false);
        } else if (state is PopUpStateSuccess) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) =>
                      const DisplayMaintainancePage(loginType: "auto")),
              (Route<dynamic> route) => false);
        } else if (state is NetworkErrorState) {
          Navigator.of(context).popAndPushNamed(LoginPage.routName);
        } else if (state is TimeOutErrorState) {
          Navigator.of(context).popAndPushNamed(LoginPage.routName);
        } else {
          //Call Login Page
          BlocProvider.of<AutoLoginBloc>(context)
              .add(DeterminePopUpStatusForManualLogin());
        }
      },
      builder: (context, state) {
        return const Scaffold(body: SplashImage());
      },
    );
  }
}
