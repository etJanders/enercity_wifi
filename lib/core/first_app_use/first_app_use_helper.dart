import 'package:wifi_smart_living/storage_helper/secured_storage_helper.dart';

///Description
///Detect if app is started the first time.
///
///Author: J. Anders
///created: 15.03.2023
///changed: 15.03.2023
///
///History:
///
///Notes:
///
class FirstAppUseHelper {
  final SecuredStorageHelper _helper = SecuredStorageHelper();
  static const String _firstAppStartIdentifier = 'firstAppStart';

  static const String firstAppFalse = '0';

  Future<bool> firstAppStart() async {
    String value =
        await _helper.readSecuredStorageData(key: _firstAppStartIdentifier);
    return value.isNotEmpty ? false : true;
  }

  void appStarted() {
    _helper
        .storeData(key: _firstAppStartIdentifier, value: firstAppFalse)
        .then((value) => null);
  }
}
