import 'package:wifi_smart_living/converter/hex_bin_converter.dart';

///Description
///Determine the current smartphone time for sap package only used for mqtt
///protocol version 01, not supported in this app version
///
///Author: J. Anders
///creared: 06-01-2023
///changed: 06-01-2023
///
///History:
///
///Notes:
///
abstract class Rtc {
  static String getRtc() {
    DateTime currentTime = DateTime.now();
    return HexBinConverter.convertIntToHex(2, currentTime.minute) +
        HexBinConverter.convertIntToHex(2, currentTime.hour) +
        HexBinConverter.convertIntToHex(2, currentTime.day) +
        HexBinConverter.convertIntToHex(2, currentTime.month) +
        HexBinConverter.convertIntToHex(2, (currentTime.year - 2000));
  }
}
