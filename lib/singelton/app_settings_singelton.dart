import 'package:wifi_smart_living/const/const_location.dart';
import 'package:wifi_smart_living/storage_helper/secured_storage_helper.dart';

///Description
///Show general app settings are used during workflow for example which section is displayed
///garden or home. Not used for current app version. Will be used in further steps
///
///Author: J. Anders
///created: 12-12-2022
///changed: 12-12-2022
///
///History:
///
///Notes:
///
class AppSettingsSingelton {
  static const _selectedLocation = 'selectedLocation';
  //representate the location which schuld be displayed for interaction
  late int _currentLocation;

  static final AppSettingsSingelton _singelton =
      AppSettingsSingelton._internal();

  AppSettingsSingelton._internal();

  factory AppSettingsSingelton() {
    return _singelton;
  }

  void initConstScheduleId() async {
    SecuredStorageHelper storageHelper = SecuredStorageHelper();
    if (await storageHelper.readSecuredStorageData(key: _selectedLocation) ==
        "") {
      setNewLocation(
          newLocation: ConstLocationidentifier.locationidentifierIndoorInt);
    } else {
      _currentLocation = int.parse(
          await storageHelper.readSecuredStorageData(key: _selectedLocation));
    }
  }

  void setNewLocation({required int newLocation}) {
    _currentLocation = newLocation;
    SecuredStorageHelper storageHelper = SecuredStorageHelper();
    storageHelper.storeData(
        key: _selectedLocation, value: newLocation.toString());
  }

  int get getCurrentLocation => _currentLocation;
}
