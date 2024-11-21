///Description
///Describe a heating profile item which is displayed in the UI
///
///Author: J. Anders
///created: 10-01-2023
///changed: 10-01-2023
///
///History:
///
///Notes:
///
class HeatingProfileDatabaseItem {
  late int _startHour;
  late int _startMinute;
  late int _weekday;
  late int _temperature;

  HeatingProfileDatabaseItem(
      int startHour, int startMinute, int weekday, int temperature) {
    _startHour = startHour;
    _startMinute = startMinute;
    _weekday = weekday;
    _temperature = temperature;
  }

  factory HeatingProfileDatabaseItem.emptyItem(int weekday) {
    return HeatingProfileDatabaseItem(0x00, 0x00, weekday, 32);
  }

  void setNewStartHour({required int startHour}) {
    _startHour = startHour;
  }

  void setNewStartMinute({required int startMinute}) {
    _startMinute = startMinute;
  }

  void setWeekday({required int weekday}) {
    _weekday = weekday;
  }

  void setTemperature({required int temperature}) {
    _temperature = temperature;
  }

  void setNewTime({required int hour, required int minute}) {
    _startHour = hour;
    _startMinute = minute;
  }

  int get getStartHour => _startHour;
  int get getStartMinute => _startMinute;
  int get getWeekday => _weekday;
  int get getTemperature => _temperature;
}
