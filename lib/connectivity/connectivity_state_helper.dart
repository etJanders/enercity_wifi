import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import 'network_connection_helper.dart';

class ConnectivityStateHelper {
  Future<ConnectivityStates> checkConnectionState() async {
    ConnectivityStates state;
    ConnectivityResult result =
        await NetworkStateHelper.isDeviceConnectedToWiFi();
    if (result == ConnectivityResult.none) {
      state = ConnectivityStates.noNetworcConnection;
    } else if (result == ConnectivityResult.wifi) {
      state = ConnectivityStates.wifiConnectionEstablished;
    } else if (!await Permission.location.isGranted) {
      state = ConnectivityStates.permissionError;
    } else {
      state = ConnectivityStates.connectionError;
    }
    return state;
  }
}

enum ConnectivityStates {
  connected,
  noNetworcConnection,
  permissionError,
  wifiConnectionEstablished,
  connectionError,
  separatorNotFound
}
