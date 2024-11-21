///Description
///Defines UI sizes which are permanently in use
///
///Author: J. Anders
///created: 01-10-2022
///changed: 01-10-2022
///
///History:
///
///Notes:
abstract class Dimens {
  static const double zero = 0.0;

  ///Size of Home Icon
  static const double homeImagesize = 140.0;
  //Container Sizes
  static const double containerWidth = 160;
  static const double containerHight = 80;

  ///Default Border radius for rounded corners
  static const double borderRadius = 10;

  ///Default Text Size
  //static const double textSize = 16;
  //Layout Padding default Value
  static const double paddingDefault = 10;
  static const double paddingSecondary = 15;
  //Halve padding value
  static const double sizedBoxHalf = paddingDefault / 2;
  //Height of sized box.
  static const double sizedBoxDefault = 10.0;
  //Bige SizedBox height
  static const double sizedBoxBigDefault = sizedBoxDefault * 3;
  //Width of borders
  static const double borderWidth = 2.0;
  static const double borderWidthSmall = 1.0;
  //Button Size Login
  static const double clickButtonSize = 150.0;
  //Progress indicator dot size
  static const double pageNavigationDotSize = 9.0;
  //margin between pageview dot progress and ui content
  static const double pageControlBottomMargin = 20.0;
  //small image size
  static const double smallImageSize = 48.0;
  static const double iconSize = 24.0;
  //Data Picker sizes
  static const double trackHeight = 10.0;
  static const double trackThumbRadius = 10.0;
  static const double thermostatSettingsBoxHight = 50.0;

  //Insert Battery guide image sizes
  static const double insertBatteryWidth = 180.0;
  static const double insertBatteriesHight = 150.0;
  //pairing Mode active image size
  static const double pairingModeWidth = 200.0;
  static const double pairingModeHight = 250.0;

  static const int changePageViewDurationMicroSeconds = 200;
}
