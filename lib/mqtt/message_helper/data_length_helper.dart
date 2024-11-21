///Description
///Data are send via mqtt always have a fixed length and should be sent in hex format.
///If data are converted from int to hex starting 0 are missing. This class helps to add
///first 0 to datastring if needed.
///
///Author: J. Anders
///created: 07-12-2022
///changed: 07-12-2022
///
///History:
///
///Nodes:
abstract class DataLengthBuilder {
  static const int dataLengthTwo = 2;
  static const int dataLengthFour = 4;

  static String buildData({required String data, required int dataLength}) {
    String output = "";
    if (data.isNotEmpty && data.length < dataLength) {
      for (int i = 0; i < dataLength - data.length; i++) {
        output = "${output}0";
      }
    }
    output = output + data;
    return output;
  }
}
