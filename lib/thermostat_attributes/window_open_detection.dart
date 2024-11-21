import 'package:wifi_smart_living/converter/hex_bin_converter.dart';
import 'package:wifi_smart_living/core/stringSplitter/string_splitter_builder.dart';
import 'package:wifi_smart_living/validation/general/data_length_validator.dart';

///Description
/// Helper to control window open detection values
///
/// Author: J. Anders
/// created: 19-12-2022
/// changed: 19-12-2022
///
/// History:
///
/// Notes:
///for more infotmation see mqtt specification
///wod = window open detection
class WindowOpenDetectionHelper {
  //array index
  static const int sensitivityLowPointer = 0;
  static const int sensitivityMiddlPointer = 1;
  static const int sensitivityHighPointer = 2;

  late bool windowOpenDetectionEnabled = false;
  late int wodSensitivity = 0;
  late int wodDuration = 0;

  WindowOpenDetectionHelper(String databaseEntrie) {
    List<int> data = SplitStringHelper.splitStringAfterCharactersInt(
        dataString: databaseEntrie, splitPosition: 2);
    if (data.length == 2) {
      if (data[0] == 128) {
        windowOpenDetectionEnabled = false;
      } else {
        windowOpenDetectionEnabled = true;
      }
      wodSensitivity = data[0];
      wodDuration = data[1];
    }
  }

  void enableDisable(bool windoeOpenState) {
    windowOpenDetectionEnabled = windoeOpenState;
    if (windoeOpenState) {
      wodSensitivity = 0x04;
    } else {
      wodSensitivity = 128;
    }
  }

  int getSensitivityPointer() {
    int pointer;
    if (wodSensitivity == 0x80 || wodSensitivity == 0x0C) {
      pointer = sensitivityLowPointer;
    } else if (wodSensitivity == 8) {
      pointer = sensitivityMiddlPointer;
    } else {
      pointer = sensitivityHighPointer;
    }
    return pointer;
  }

  int getDurationPointer() {
    return ((wodDuration / 10) - 1).round();
  }

  void changeSensitivity(int pointer) {
    if (pointer == sensitivityLowPointer) {
      wodSensitivity = 0x0C;
    } else if (pointer == sensitivityMiddlPointer) {
      wodSensitivity = 0x08;
    } else {
      wodSensitivity = 0x04;
    }
  }

  void changeDuration(int pointer) {
    wodDuration = ((pointer + 1) * 10);
  }

  String getDatabaseFlagsForSentAndUpdate() {
    return(HexBinConverter.convertIntToHex(
        DataLengh.dataLengthTwo, wodSensitivity) +
        HexBinConverter.convertIntToHex(DataLengh.dataLengthTwo, wodDuration));

  }
}
