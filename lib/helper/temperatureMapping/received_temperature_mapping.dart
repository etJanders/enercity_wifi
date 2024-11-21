import 'package:wifi_smart_living/converter/hex_bin_converter.dart';

class ReceivedTemperatureMapping {
  String mapReceivedTemperature(String receivedTemperature) {
    int convertedData =
        HexBinConverter.convertHexStringToInt(hexString: receivedTemperature);
    double value = convertedData / 2;
    return value.toString();
  }
}
