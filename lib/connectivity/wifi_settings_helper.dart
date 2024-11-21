import 'dart:io';

import 'package:flutter/services.dart';
import 'package:network_info_plus/network_info_plus.dart';

///Description
///Determine the name of the connected wifi network and the mac address of the
///connected wifi network
///
///Author: J. Anders
///created: 08-11-2022
///changed: 08-11-2022
///
///History:
///
///Notes:
///
class WiFiSettingsHelper {
  late NetworkInfo _info;
  //Call ios native code in app delegate
  static const ssidChannel = MethodChannel('org/eurotronic/smartLiving/ssid');
  static const macChannel = MethodChannel('org/eurotronic/smartLiving/mac');

  WiFiSettingsHelper() {
    _info = NetworkInfo();
  }

  Future<String?> determineSsidName() async {
    if (Platform.isAndroid || Platform.isWindows) {
      if (await _info.getWifiName() != null) {
        return await _info.getWifiName();
      }
      return "";
    } else if (Platform.isIOS) {
      return await getSsid();
    }
    return "";
  }

  ///Dermine Mac adress of connected device
  Future<String?> getDeviceMacAdress() async {
    if (Platform.isAndroid || Platform.isWindows) {
      return await _info.getWifiBSSID();
    } else if (Platform.isIOS) {
      return await getMacAdressFromIos();
    } else {
      return "";
    }
  }

  Future<String?> getWiFiGatewayIp() async {
    return await _info.getWifiGatewayIP();
  }

  Future<String?> getOwnIpAdress() async {
    return await _info.getWifiIP();
  }

  Future<String> getSsid() async {
    String data = await ssidChannel.invokeMethod('getSsidName');
    return data;
  }

  Future<String> getMacAdressFromIos() async {
    String macAdress = await macChannel.invokeMethod('getMacAdress');
    return macAdress;
  }
}
