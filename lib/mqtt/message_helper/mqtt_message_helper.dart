///Description
///Every MQTT message starts with #. This class remove the # and provide the
///data string if data exists. Otherwise an empty string is provided.
///
///Author: J. Anders
///created: 07-12-2022
///changed: 07-12-2022
///
///History:
///
///Nodes:
///
abstract class MqttMessageHelper {
  static String getMessage(String message) {
    String output = "";
    if (message.startsWith("#") && message.length > 1) {
      output = message.substring(1);
    }
    return output;
  }
}
