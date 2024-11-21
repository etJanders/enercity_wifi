import 'package:wifi_smart_living/const/const_device_type.dart';
import 'package:wifi_smart_living/const/const_location.dart';

///Description
///Collection of informarion are used to add a new device
///
///Author: J. Anders
///created: 16-12-2022
///changed: 16-12-2022
///
///History:
///
///Notes:
///
class AddNewDeviceHelper {
  String wifiName = "";
  String wifiPassword = "";
  String _deviceMacAdress = "";
  String deviceName = "";
  String imageName = "";
  String deviceTypeId = ConstDeviceType.cometWiFiGen2;
  String roomName = "";
  int location = ConstLocationidentifier.locationidentifierIndoorInt;
  bool seperator = false;
  void setMacAdress(String mac) {
    _deviceMacAdress = mac;
  }

  String getMacAdress() {
    return _deviceMacAdress;
  }
}
