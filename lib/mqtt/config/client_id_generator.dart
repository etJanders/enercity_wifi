import 'package:wifi_smart_living/core/platformHelper/platform_helper.dart';
import 'package:wifi_smart_living/core/randomNumberGenerator/random_number_helper.dart';
import 'package:wifi_smart_living/storage_helper/secured_storage_helper.dart';

///Description
///Determine the client ID for MQTT session. The cient id contains of the home
///and an random generated number. the random number should be the same during the
///app account livecycle and is for everey smartphone individual.
///
///Author: J. Anders
///created: 07-12-2022
///changed: 07-12-2022
///
///History:
///
///Notes:
///
abstract class GeneriereClientId {
  static const String clinetNumberSpIdentifier = "randomClientIdNumber";

  static Future<String> generateClientIdNumber({required String home}) async {
    SecuredStorageHelper helper = SecuredStorageHelper();
    String randomNumber =
        await helper.readSecuredStorageData(key: clinetNumberSpIdentifier);
    if (randomNumber.isEmpty) {
      if (PlatformHelper.getPlatformInf() == PlatformHelper.platformIdAndroid) {
        randomNumber =
            GenerateRandomNumber.generateRandomNumber(min: 100000, max: 900000)
                .toString();
        helper.storeData(key: clinetNumberSpIdentifier, value: randomNumber);
      } else {
        randomNumber = GenerateRandomNumber.generateRandomNumber(
                min: 10000000, max: 90000000)
            .toString();
        helper.storeData(key: clinetNumberSpIdentifier, value: randomNumber);
      }
    }
    return "${home}_$randomNumber";
  }
}
