import 'package:wifi_smart_living/heatingProfile/heating_profile_item.dart';

class CompareArrayLists {
  bool arrayListsSame(List<HeatingProfileDatabaseItem> listOne,
      List<HeatingProfileDatabaseItem> listTwo) {
    int timeIntervallSame = 0;
    if (listOne.length == listTwo.length) {
      for (int i = 0; i < listOne.length; i++) {
        HeatingProfileDatabaseItem one = listOne[i];
        for (int j = 0; j < listTwo.length; j++) {
          HeatingProfileDatabaseItem two = listTwo[j];
          if (_startZeitGleich(one, two) &&
              _minutenGleich(one, two) &&
              _temperaturenGleich(one, two)) {
            timeIntervallSame++;
          }
        }
      }
    }
    return timeIntervallSame != 0 && timeIntervallSame == listOne.length;
  }

  bool _startZeitGleich(
      HeatingProfileDatabaseItem one, HeatingProfileDatabaseItem two) {
    return one.getStartHour == two.getStartHour;
  }

  bool _minutenGleich(
      HeatingProfileDatabaseItem one, HeatingProfileDatabaseItem two) {
    return one.getStartMinute == two.getStartMinute;
  }

  bool _temperaturenGleich(
      HeatingProfileDatabaseItem one, HeatingProfileDatabaseItem two) {
    return one.getTemperature == two.getTemperature;
  }
}
