import 'dart:io';

///Desctription
///Detecst if app is running on android or ios plarform
///
///Author: J. Anders
///created: 02-12-2022
///changed: 02-12-2022
///
///History:
///
///Notes:
///
abstract class PlatformHelper {
  static const int platformIdIos = 0;
  static const int platformIdAndroid = 1;

  static int getPlatformInf() {
    int platformDetected = platformIdAndroid;
    if (Platform.isIOS) {
      platformDetected = platformIdIos;
    }
    return platformDetected;
  }
}
