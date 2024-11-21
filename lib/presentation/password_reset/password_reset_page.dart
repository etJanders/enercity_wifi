import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wifi_smart_living/bloc/password_reset/password_reset_bloc.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/presentation/password_reset/view_pages/enter_reset_token.dart';
import 'package:wifi_smart_living/presentation/password_reset/view_pages/password_reset_enter_mail_page.dart';
import 'package:wifi_smart_living/presentation/password_reset/view_pages/set_new_password_page.dart';
import 'package:wifi_smart_living/theme.dart';

class PasswordResetPage extends StatefulWidget {
  static const String routName = '/password_reset_page';
  const PasswordResetPage({super.key});

  @override
  State<PasswordResetPage> createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
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
      create: (context) => PasswordResetBloc(),
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
                  PasswordResetMailPage(nextStepCallback: _changePage),
                  PasswordResetTokenPage(nextStepCallback: _changePage),
                  SetNewPasswordPage(nextStepCallback: _finish),
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

  void _changePage() {
    if (_pageState != _pageSize) {
      setState(() {
        _pageState++;
        _pageController.animateToPage(_pageState,
            duration: const Duration(microseconds: 200),
            curve: Curves.bounceInOut);
      });
    }
  }

  void _finish() {
    Navigator.of(context).pop();
  }
}
