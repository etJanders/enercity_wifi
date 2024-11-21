import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/presentation/change_account_mail/view_pages/enter_change_mail_token_page.dart';
import 'package:wifi_smart_living/presentation/change_account_mail/view_pages/enter_new_mail_page.dart';
import 'package:wifi_smart_living/theme.dart';

import '../../api_handler/api_treiber/user_management/get_self_helper.dart';
import '../../bloc/change_account_mail/change_account_mail_bloc.dart';
import '../../singelton/api_singelton.dart';
import '../general_widgets/back_button_widget/back_button_widget.dart';
import '../home_page/indoor/homepage_indoor_page.dart';

class ChangeAccountMailPage extends StatefulWidget {
  static const routName = "/change_account_mail";

  const ChangeAccountMailPage({super.key});

  @override
  State<ChangeAccountMailPage> createState() => _ChangeAccountMailPageState();
}

class _ChangeAccountMailPageState extends State<ChangeAccountMailPage> {
  static const int _pageSize = 2;
  int _pageState = 1;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (context) => ChangeAccountMailBloc(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: const BackButtonWidget(),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(local.myUserAccount),
              Text(
                local.editEmail,
                style: AppTheme.textStyleDefault,
              )
            ],
          ),
        ),
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
                  EnterNewMailPage(
                    changeUiCallback: _changePage,
                  ),
                  EnterChangeMailTokenPage(changeUiCallback: _changePage),
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
                      onDotClicked: (index) {},
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
    } else {
      GetSelfHelper().callGetSelf(
          token: ApiSingelton().getModelAccessToken,
          password: ApiSingelton().getDatabaseUserModel.userPassowrd);

      Navigator.pushNamedAndRemoveUntil(
          context, HomepageIndoorPage.routName, (route) => false);
    }
  }
}
