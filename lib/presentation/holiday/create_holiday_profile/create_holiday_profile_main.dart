import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wifi_smart_living/bloc/create_holiday_profile/create_holiday_profile_bloc.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/presentation/holiday/create_holiday_profile/create_holiday_profile_rooms.dart';
import 'package:wifi_smart_living/presentation/holiday/create_holiday_profile/select_holiday_profile_image.dart';
import 'package:wifi_smart_living/presentation/holiday/create_holiday_profile/select_holiday_profile_name.dart';

import '../../../theme.dart';

class CreateHolidayProfileMainPage extends StatefulWidget {
  static const routName = '/create_holiday_profile';
  const CreateHolidayProfileMainPage({super.key});

  @override
  State<CreateHolidayProfileMainPage> createState() =>
      _CreateHolidayProfileMainPageState();
}

class _CreateHolidayProfileMainPageState
    extends State<CreateHolidayProfileMainPage> {
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
      create: (context) => CreateHolidayProfileBloc(),
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
                onPageChanged: ((value) {}),
                children: [
                  SelectHolidayProfileRoomsPage(
                    nextCallback: _changePage,
                  ),
                  CreateHolidayProfileSelectNamePage(nextCallback: _changePage),
                  CreateHolidayProfileSelectImage(callbackNexn: _closePage)
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
                      onDotClicked: ((index) {}),
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
    }
  }

  void _closePage() {
    Navigator.of(context).pop();
  }
}
