import 'package:wifi_smart_living/thermostat_attributes/rtc.dart';

import '../converter/utf8_converter.dart';

///Description
///Create data packege fpr sap mode
///
///Author: J. Anders
///created: 08-11-2022
///changed: 08-11-2022
///
///History:
///
///Notes:
///
abstract class BuildSapData {
  static String buildSapData1233(
      {required String wifiName,
      required String wifiPassword,
      required String mqttUserName,
      required String mqttuserPassword,
      required bool seperator,
      required String broker}) {
    String lastByteOfBrokerIP;
    String leadingZero = '0';
    lastByteOfBrokerIP =
        (int.parse(broker) - 2).toRadixString(16).toUpperCase();
    if (lastByteOfBrokerIP.length == 1) {
      lastByteOfBrokerIP = '$leadingZero$lastByteOfBrokerIP';
    }
    if (seperator) {
      return '${UTF8Converter.convertStringToUtf8Hex(data: wifiName)}${"01"}${UTF8Converter.convertStringToUtf8Hex(data: wifiPassword)},$mqttUserName,$mqttuserPassword,000000$lastByteOfBrokerIP,075B'; //This is the code for future implementation of modified field separator 01
    }
    return '${UTF8Converter.convertStringToUtf8Hex(data: '$wifiName,$wifiPassword')},$mqttUserName,$mqttuserPassword,000000$lastByteOfBrokerIP,075B';
  }

  //not used at the moment
  static String buildSapData1234(
      {required String wifiName, required String wifiPassword}) {
    return '${UTF8Converter.convertStringToUtf8Hex(data: '$wifiName,$wifiPassword')},${Rtc.getRtc()}';
  }
}
