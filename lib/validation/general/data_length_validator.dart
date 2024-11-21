///Decription
///Data are send via MQTT should have a specific data length. This class help to check
///the required data lenght and help to create this
///
///Author: J. Anders
///created: 03-11-2022
///changed: 03-11-2022
///
///History:
///
///Notes:
///Check if class or logig exists twice if yes, bad solution, remove duplicated logic
abstract class DataLengthValidator {
  static String validateDataLength(
      {required int length, required String data}) {
    String validatedData = "";
    if (data.length < length) {
      int differenze = length - data.length;
      for (int i = 0; i < differenze; i++) {
        validatedData += "0";
      }
    }
    return validatedData + data;
  }

  static String validateDataLengthReverse(
      {required int length, required String data}) {
    String validatedData = data;
    if (data.length < length) {
      int differenze = length - data.length;
      for (int i = 0; i < differenze; i++) {
        validatedData += "0";
      }
    }
    return validatedData;
  }
}

///Description
///Supported Data Lengh
///
///Autor: J. Anders
///created: 03-11-2022
///changed: 03-11-2022
///
///History:
///
///Notes:
///
abstract class DataLengh {
  static const dataLengthTwo = 2;
  static const dataLengthFour = 4;
  static const dataLenghEight = 8;
}
