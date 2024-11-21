import 'package:wifi_smart_living/connectivity/tcp_socket_helper.dart';
import 'package:wifi_smart_living/connectivity/wifi_settings_helper.dart';

///Description
///Open a port to thermostat and sned config data to device
///
///Author: J. Anders
///created: 20-12-2022
///changed: 20-12-2022
///
///History:
///
///Notes:
///Todo error handling is missing:
///-Every comet wifi mac starts with D43D39. Check if detected mac starts with this padden
///-whats happen when ip address of the smartphone is out of dhcp range of the thermostat?
class SapHandler {
  TcpSocket tcpSocket = TcpSocket();
  static const String deviceIp = '10.0.0.1';

  Future<SapState> openPortAndSendData(
      {required String sapConfig, required int port}) async {
    SapState state = SapState.socketConnectionNotWorking;
    //IP of connected wifi network
    print("Config string is $sapConfig");
    String? deviceIpAdress = await WiFiSettingsHelper().getWiFiGatewayIp();
    if (deviceIpAdress != null && deviceIp == deviceIpAdress) {
      //Ip Adress of the smartphone
      String? ownIp = await WiFiSettingsHelper().getOwnIpAdress();
      if (ownIp != null) {
        //Start socket connection
        if (await tcpSocket.connectToDevice(
            host: deviceIp, port: port, sourceAdress: ownIp)) {
          //Send sap data
          if (await tcpSocket.sendMessage(messag: sapConfig)) {
            tcpSocket.closeSocketConnection();
            state = SapState.deviceSuccesfulConfigurated;
          } else {
            state = SapState.notAbleToSendData;
          }
        } else {
          state = SapState.socketConnectionNotWorking;
        }
      }
    } else {
      state = SapState.disableMobileData;
    }
    return state;
  }
}

enum SapState {
  socketConnectionNotWorking,
  macNotSupported,
  disableMobileData,
  notAbleToSendData,
  deviceSuccesfulConfigurated
}
