import 'package:wifi_smart_living/core/stringSplitter/string_splitter_builder.dart';

///Description
///Split a mqtt topic and provide the topic parts
///
///Author: J. Anders
///created: 07-12-2022
///changed: 07-12-2022
///
///History:
///
///Nodes:
///
class TopicStructureHelper {
  late List<String> topic;

  static const String aquaDirection = 'A';
  static const String thermostatDirection = 'V';

  static const int _versionIndex = 0;
  static const int _homeIndex = 1;
  static const int _macIndex = 2;
  static const int _direcionIndex = 3;
  static const int _identifierIndex = 4;

  static const int _topicLength = 5;

  TopicStructureHelper({required String recivedTopic}) {
    topic = SplitStringHelper.splitStringOnCharacter(
        character: '/', dataString: recivedTopic);
  }

  String get getVersionCode =>
      topic.length == _topicLength ? topic.elementAt(_versionIndex) : "";
  String get getHome =>
      topic.length == _topicLength ? topic.elementAt(_homeIndex) : "";
  String get getTopicMac =>
      topic.length == _topicLength ? topic.elementAt(_macIndex) : "";
  String get getDirectionIndex =>
      topic.length == _topicLength ? topic.elementAt(_direcionIndex) : "";
  String get getIdentifier =>
      topic.length == _topicLength ? topic.elementAt(_identifierIndex) : "";
}
