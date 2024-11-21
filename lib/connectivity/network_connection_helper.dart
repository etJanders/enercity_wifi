import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

///Description
///Overwatch networc connectivity
///
///Author: J. Anders
///created: 09-11-2022
///changed: 09-11-2022
///
///History:
///
///Notes:
///https://pub.dev/packages/connectivity_plus

abstract class NetworkStateHelper {
  static Future<bool> networkConnectionEstablished() async {
    return await _checkDomainConnectivity('example.com') ||
        await _checkDomainConnectivity('google.com');
  }

  static Future<bool> _checkDomainConnectivity(String domain) async {
    try {
      final result = await InternetAddress.lookup(domain);
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  static Future<ConnectivityResult> isDeviceConnectedToWiFi() async {
    return await Connectivity().checkConnectivity();
  }
}
