import 'dart:convert' show utf8;

import '../validation/general/data_length_validator.dart';
import 'hex_bin_converter.dart';

///Description:
///Convert a datastring into the ut8 represnations String
///
///Author: J. Anders
///created: 03-11-2022
///chnaged: 03-11-2022
///
///History:
///
///Notes:
///
abstract class UTF8Converter {
  static String convertStringToUtf8Hex({required String data}) {
    String convertedData = "";
    List<int> convertedDataList = utf8.encode(data);
    for (int i = 0; i < convertedDataList.length; i++) {
      convertedData += HexBinConverter.convertIntToHex(
          DataLengh.dataLengthTwo, convertedDataList[i]);
    }
    return convertedData;
  }
}
