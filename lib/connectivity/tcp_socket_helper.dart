import 'dart:io';

///Description
///Handle Socket Connection to thermostat
///
///Author: J. Anders
///created: 20-12-2022
///changed: 20-12-2022
///
///Histoy:
///
///Notes:
class TcpSocket {
  late Socket socket;
  Future<bool> connectToDevice(
      {required String host,
      required int port,
      required String sourceAdress}) async {
    bool socketConnected = false;
    try {
      socket = await Socket.connect(host, port,
          sourceAddress: sourceAdress,
          sourcePort: port,
          timeout: const Duration(seconds: 10));
      socketConnected = true;
      return socketConnected;
    } on Exception catch (_) {
      return socketConnected;
    }
  }

  Future<bool> sendMessage({required String messag}) async {
    bool messageSend = false;
    if (messag.isNotEmpty) {
      socket.write(messag);
      await Future.delayed(const Duration(seconds: 2));
      messageSend = true;
    }
    return messageSend;
  }

  void closeSocketConnection() {
    socket.close();
  }
}
