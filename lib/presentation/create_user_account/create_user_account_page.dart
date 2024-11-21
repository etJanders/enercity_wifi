import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wifi_smart_living/bloc/create_new_user_account/create_user_account_bloc.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/presentation/create_user_account/view_pages/create_account_enter_mail_password.dart';
import 'package:wifi_smart_living/presentation/create_user_account/view_pages/create_account_enter_token.dart';
import 'package:wifi_smart_living/presentation/create_user_account/view_pages/create_account_notification_page.dart';
import 'package:wifi_smart_living/theme.dart';

import '../home_page/indoor/homepage_indoor_page.dart';

///Description
///Flow Control for creating a new user account
///
///Author: J. Anders
///created: 30-11-2022
///changed: 30-11-2022
///
///History:
///
///Notes:
class CreateUserAccountViewPagerPage extends StatefulWidget {
  static const routName = "/create_user_account";
  const CreateUserAccountViewPagerPage({super.key});

  @override
  State<CreateUserAccountViewPagerPage> createState() =>
      _CreateUserAccountViewPagerPageState();
}

class _CreateUserAccountViewPagerPageState
    extends State<CreateUserAccountViewPagerPage> {
  static const int _pageSize = 3;
  int _pageState = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateUserAccountBloc(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Container(
              margin:
                  const EdgeInsets.only(bottom: Dimens.pageControlBottomMargin),
              child: PageView(
                pageSnapping: false,
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                onPageChanged: (value) {},
                children: [
                  EnterMailAndPasswordPage(
                    callbackFunction: _changePage,
                  ),
                  CreateAccountEnterTokenPage(callbackFunction: _changePage),
                  NotificationInformationPage(
                    callbackFunction: _changePage,
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(Dimens.paddingDefault),
                  child: Center(
                    child: SmoothPageIndicator(
                      controller: _pageController,
                      count: _pageSize,
                      effect: const CustomizableEffect(
                          activeDotDecoration: DotDecoration(
                              height: Dimens.pageNavigationDotSize,
                              width: Dimens.pageNavigationDotSize,
                              color: AppTheme.violet,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(Dimens.borderRadius))),
                          dotDecoration: DotDecoration(
                              height: Dimens.pageNavigationDotSize,
                              width: Dimens.pageNavigationDotSize,
                              color: AppTheme.schriftfarbe,
                              dotBorder: DotBorder(color: AppTheme.violet),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(Dimens.borderRadius)))),
                      onDotClicked: (index) {},
                    ),
                  ),
                ),
                Platform.isIOS
                    ? const SizedBox(height: 12)
                    : const SizedBox(height: 0)
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _changePage() async {
    if (_pageState != _pageSize) {
      setState(() {
        _pageState++;
        _pageController.animateToPage(_pageState,
            duration: const Duration(microseconds: 200),
            curve: Curves.bounceInOut);
      });
    } else {
      Navigator.pushNamedAndRemoveUntil(
          context, HomepageIndoorPage.routName, (route) => false);
    }
  }
}
