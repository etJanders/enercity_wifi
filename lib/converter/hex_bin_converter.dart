import '../validation/general/data_length_validator.dart';

///Description
///Converte bin Strings to hex strings or hex Strings to bin String
///
///Author: J. Anders
///created: 03-11-2022
///changed: 03-11-2022
///
///History:
///
///Notes:
///
abstract class HexBinConverter {
  static String convertBinStringToHex(int dataLength, String binString) {
    return DataLengthValidator.validateDataLength(
            data: int.parse(binString, radix: 2).toRadixString(16),
            length: dataLength)
        .toUpperCase();
  }

  static String convertHexStringToBin(String hexString) {
    return int.parse(hexString, radix: 16).toRadixString(2);
  }

  ///Converte a int valu into data value
  static String convertIntToHex(int dataLength, int value) {
    return DataLengthValidator.validateDataLength(
      data: value.toRadixString(16),
      length: dataLength,
    ).toUpperCase();
  }

  static int convertHexStringToInt({required String hexString}) {
    return int.parse(hexString, radix: 16);
  }
}
