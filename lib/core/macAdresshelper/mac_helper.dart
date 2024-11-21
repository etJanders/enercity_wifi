import 'package:wifi_smart_living/converter/hex_bin_converter.dart';
import 'package:wifi_smart_living/core/stringSplitter/string_splitter_builder.dart';

import '../../validation/general/data_length_validator.dart';

///Description
///Convert a determined Gateway Mac to the correct format by decrement the
///lowes digit of the highes mc byte by 2
///
///Author: J. Anders
///created: 08-11-2022
///changed: 08-11-2022
///
///History:
///
///Notes:
///
class MacAdressHelper {
  late List<String> splittedMac;

  MacAdressHelper() {
    splittedMac = [];
  }

  String generateUsableMacAdress(String? determinedMacAdress) {
    String generatedMacAdress = "";
    if (determinedMacAdress != null) {
      splittedMac = SplitStringHelper.splitStringOnCharacter(
          character: ":", dataString: determinedMacAdress);
      _changeMacByteDigit();
      _fillValues(splittedString: splittedMac);
      generatedMacAdress = _buildMac(splittedString: splittedMac);
    }
    return generatedMacAdress.toUpperCase();
  }

  ///Check that every mac byte has the correct length
  void _fillValues({required List<String> splittedString}) {
    for (int i = 0; i < splittedString.length; i++) {
      if (splittedString[i].length != DataLengh.dataLengthTwo) {
        splittedString[i] = DataLengthValidator.validateDataLength(
            data: splittedString[i], length: DataLengh.dataLengthTwo);
      }
    }
  }

  ///Generate the mac adress from list to a usable format
  String _buildMac({required List<String> splittedString}) {
    String data = "";
    for (int i = 0; i < splittedString.length; i++) {
      data += splittedString[i];
    }
    return data.toUpperCase();
  }

  ///decrement mac byte by one
  void _changeMacByteDigit() {
    if (splittedMac.length == 6) {
      int value = HexBinConverter.convertHexStringToInt(
          hexString: splittedMac[splittedMac.length - 1]);
      value -= 1;
      splittedMac[splittedMac.length - 1] =
          DataLengthValidator.validateDataLength(
              data: value.toRadixString(16), length: DataLengh.dataLengthTwo);
    }
  }
}
