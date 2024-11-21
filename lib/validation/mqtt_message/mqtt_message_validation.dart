import 'package:wifi_smart_living/validation/regex/regex_helper.dart';
import 'package:wifi_smart_living/validation/regex/regex_konstanten.dart';

///Description
///Mqtt Message Validation to check if data are in correct format.
///- The correct MQTT Data format is hex
///- data length % 2 == 0
///
///Author: J. Anders
///creted: 15-12-2022
///changed: 15-12-2022
///
///History:
///
///Notes:
///
abstract class MqttMessageValidator {
  static bool mqttDataValid({required String data}) {
    bool dataValid = true;
    if (data.length % 2 != 0 ||
        !RegexHelper.inputValide(ConstRegEx.hexRegex, data)) {
      dataValid = false;
    }
    return dataValid;
  }
}
