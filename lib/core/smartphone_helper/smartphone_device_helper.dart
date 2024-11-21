import 'package:device_info_plus/device_info_plus.dart';
import 'package:wifi_smart_living/core/platformHelper/platform_helper.dart';

///Definition: Determine mobile phone and app information and put this information
///to a data string
///
///Author: J. Anders
///created: 29-11-2022
///changed: 29-11-2022
///
///History:
///
///Notes:
///https://pub.dev/documentation/device_info_plus/latest/
abstract class SmartphoneBuild {
  static Future<String> defineSmartphoneIdenificationString() async {
    String smartphineInformation =
        "App: enercity smarte Thermostate, App Version: 1.0";
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (PlatformHelper.getPlatformInf() == PlatformHelper.platformIdIos) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      smartphineInformation =
          "$smartphineInformation Android Version: ${androidInfo.version.release}, Gerät: ${androidInfo.model}";
    } else if (PlatformHelper.getPlatformInf() ==
        PlatformHelper.platformIdIos) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      smartphineInformation =
          "$smartphineInformation iOS Version: ${iosInfo.systemVersion}, Gerät: ${iosInfo.model}";
    }
    return smartphineInformation;
  }
}
