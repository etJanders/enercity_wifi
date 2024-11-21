import 'package:wifi_smart_living/const/const_location.dart';

///Description
///Define the device type of supported devices and define methods to check the
///if devices are supported from the app
///
///Author: J. Anders
///created: 29-11-2022
///changed: 29-11-2022
///
///History:
///
///Notes:
///
///Todo loese das Problem über device_type_tabelle statt hardcoded, dafür ist die datenbank tabelle da
class ConstDeviceType {
  late final List<String> _deviceTypesIndoor = [];
  late final List<String> _deviceTypesOutdoor = [];

  static const String cometWiFiGen2 = "0012";
  static const String cometAquaStandAlone = "0021";
  static const String cometAquaWithFlowMeter = "0121";

  ConstDeviceType() {
    _initDeviceTypesIndoor();
    _initDeviceTypesOutdoor();
  }

  void _initDeviceTypesIndoor() {
    _deviceTypesIndoor.add(cometWiFiGen2);
  }

  void _initDeviceTypesOutdoor() {
    _deviceTypesOutdoor.add(cometAquaStandAlone);
    _deviceTypesOutdoor.add(cometAquaWithFlowMeter);
  }

  //Check if device type id is supported from the app
  bool deviceSupported({required String determinedDeviceType}) {
    return _deviceTypesIndoor.contains(determinedDeviceType) ||
        _deviceTypesOutdoor.contains(determinedDeviceType);
  }

  //Check if device is ordered to specific location
  bool deviceSupportedFromLocation(
      {required String location, required String determinedDeviceType}) {
    bool deviceSupportedByLocation;
    if (ConstLocationidentifier.locationidentifierIndoor == location) {
      deviceSupportedByLocation =
          _deviceTypesIndoor.contains(determinedDeviceType);
    } else if (ConstLocationidentifier.locationidentifierOutdoor == location) {
      deviceSupportedByLocation =
          _deviceTypesOutdoor.contains(determinedDeviceType);
    } else {
      deviceSupportedByLocation = false;
    }
    return deviceSupportedByLocation;
  }
}
