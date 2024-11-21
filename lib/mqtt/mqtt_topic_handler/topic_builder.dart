///Decription
///Create topic structure for MQTT Comminication
///
///Author: J. Anders
///created: 07-12-2022
///changed: 07-12-2022
///
///History:
///
///Nodes:
///
abstract class MqttTopicBuilder {
  ///Topic Strucure is used for subscitption
  static String buildSubscribeTopic(
      {required String home, required String broker}) {
    return "$broker/$home/#";
  }

  ///Topic Strucure is used for sending data
  static String buildCommunicationTopic(
      {required String home,
      required String mac,
      required String profielIdentifier,
      required String broker}) {
    return "$broker/$home/$mac/S/$profielIdentifier";
  }
}
