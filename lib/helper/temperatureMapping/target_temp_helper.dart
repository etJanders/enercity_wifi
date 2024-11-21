import 'package:wifi_smart_living/core/stringSplitter/string_splitter_builder.dart';

class TargetTempHelper {
  final String temp;
  late List<String> _splited;
  TargetTempHelper({required this.temp}) {
    if (temp != 'on' && temp != 'off') {
      //Remov last string part means °C
      var data = temp.substring(0, temp.length - 2);
      _splited = SplitStringHelper.splitStringOnCharacter(
          character: ".", dataString: data);
    }
  }

  String getFirst() {
    return _splited[0];
  }

  String getSecond() {
    return _splited[1];
  }
}
