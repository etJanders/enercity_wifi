import 'package:wifi_smart_living/converter/hex_bin_converter.dart';
import 'package:wifi_smart_living/core/stringSplitter/string_splitter_builder.dart';
import 'package:wifi_smart_living/heatingProfile/heating_profile_item.dart';

class HeatingtimeCalculatorHelper {
  static const int weekdayConst = (64 * 6 * 24);
  static const int hourConst = (64 * 6);
  static const int minuteConst = 64;

  static List<HeatingProfileDatabaseItem> getWeekayHeating(
      {required String mqttData}) {
    List<HeatingProfileDatabaseItem> convertedHeatingProfile = [];
    if (mqttData != '#') {
      List<int> splittedData = SplitStringHelper.splitStringAfterCharactersInt(
          dataString: mqttData, splitPosition: 4);
      if (splittedData.isNotEmpty) {
        for (int i = 0; i < splittedData.length; i++) {
          convertedHeatingProfile
              .add(convertTimeToModel(heatingTime: splittedData[i]));
        }
      }
    }
    return convertedHeatingProfile;
  }

  static HeatingProfileDatabaseItem convertTimeToModel(
      {required int heatingTime}) {

    int weekday = _divide(heatingTime, weekdayConst);
    int mod = _moduleCalc(heatingTime, weekdayConst);
    int startHour = _divide(mod, hourConst);
    mod = _moduleCalc(mod, hourConst);
    int startMinute = (_divide(mod, minuteConst) * 10);
    int temperature = _moduleCalc(mod, minuteConst);

    return HeatingProfileDatabaseItem(
        startHour, startMinute, weekday, temperature);
  }

  static int _moduleCalc(int value, int mod) {
    return value % mod;
  }

  static int _divide(int divider, int divisor) {
    int calculated = 0;
    if (divider > 0) {
      calculated = divider ~/ divisor;
    }
    return calculated;
  }

  static String getHeatingTomeFromModel(
      {required HeatingProfileDatabaseItem item}) {
    int calculated = item.getTemperature +
        ((item.getStartMinute / 10).round() * minuteConst) +
        (item.getStartHour * hourConst) +
        (item.getWeekday * weekdayConst);
    return HexBinConverter.convertIntToHex(4, calculated).toUpperCase();
  }

  static String getHeatingTimeFromModelWithWeekday(
      {required HeatingProfileDatabaseItem item, required int weekday}) {
    if(item.getTemperature>57){
      return "";
    }
  if(item.getStartHour > 24 || item.getStartMinute > 59){
    return "";
  }
    int calculated = item.getTemperature +
        ((item.getStartMinute / 10).round() * minuteConst) +
        (item.getStartHour * hourConst) +
        (weekday * weekdayConst);
    return HexBinConverter.convertIntToHex(4, calculated).toUpperCase();
  }
}
