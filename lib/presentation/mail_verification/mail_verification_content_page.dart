import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/presentation/create_user_account/view_pages/create_account_notification_content.dart';
import 'package:wifi_smart_living/presentation/mail_verification/mail_activation_content.dart';

import '../../theme.dart';

///Todo besteht aus den Punkten Mail erneut registrieren und notification
class MailVerificationContent extends StatefulWidget {
  const MailVerificationContent({super.key});

  @override
  State<MailVerificationContent> createState() =>
      _MailVerificationContentState();
}

class _MailVerificationContentState extends State<MailVerificationContent> {
  int _pageState = 0;
  static const _pageCount = 2;
  final PageController _pageControlle = PageController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: Dimens.pageControlBottomMargin),
          child: PageView(
            pageSnapping: false,
            physics: const NeverScrollableScrollPhysics(),
            controller: _pageControlle,
            onPageChanged: (value) {},
            children: [
              MailActivationContent(nextCallback: _changePage),
              // NotificationInformationPage(
              //   callbackFunction: _changePage,
              // ),
              CreateAccountNotificationContent(callbackFunction: _changePage)
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
                  controller: _pageControlle,
                  count: _pageCount,
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
    );
  }

  void _changePage() {
    setState(() {
      _pageState++;
      _pageControlle.animateToPage(_pageState,
          duration: const Duration(microseconds: 200),
          curve: Curves.bounceInOut);
    });
  }
}
