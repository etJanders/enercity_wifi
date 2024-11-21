///Description
///Mqtt Config Information
///
///Author: J. Anders
///created: 07-12-2022
///changed: 07-12-2022
///
///History:
///
///Nodes:
abstract class ConstMqtt {
  static const String brokerUrlStart = 'mqtt';
  static const String brokerUrlEnd = '.eurotronic.io';
  static const String defaultBrokerNumber = '02';
  static const int defaultBrokerPort = 1883;
  static const int keepAliveInterval = 20;
  static const bool autoReconnectState = true;

  // not used
  // static const String firstBrokerUrl = 'mqtt.eurotronic.io';
  // static const String secondBrokerUrl = 'mqtt1.eurotronic.io';
  //static const String test = 'test-lb.eurotronic.io';
  //static const String firstBrokerUrl = 'node2.eurotronic.io';
}
