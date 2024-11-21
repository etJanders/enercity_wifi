import 'package:wifi_smart_living/device_specification/thermostat_interface.dart';

import '../core/calculation/timeSchedule/heatingtime_calculator.dart';
import '../heatingProfile/heating_profile_item.dart';
import '../heatingProfile/management/schaltzeiten_intervall.dart';
import '../helper/send_schedule_map_builder/send_schedule_data.dart';

class HeatintProfileToMqttHelper {
  final List<SchaltzeitenIntervall> schaltzeitenIntervalle;
  final SendScheduleMapBuilder _mapBuilder = SendScheduleMapBuilder();
  final HeatingtimeCalculatorHelper calculatorHelper =
      HeatingtimeCalculatorHelper();

  HeatintProfileToMqttHelper({required this.schaltzeitenIntervalle}) {
    _initData();
  }

  void _initData() {
    for (int i = 0; i < schaltzeitenIntervalle.length; i++) {
      List<String> wochentage = schaltzeitenIntervalle[i].wochentage;
      for (int j = 0; j < wochentage.length; j++) {
        _mapBuilder.changeData(
            wochentage[j],
            _buildTimeString(
                wochentag: wochentage[j],
                items: schaltzeitenIntervalle[i].zeitschaltpunkte));
      }
    }
  }

  ///Baue den MQTT- und Datenbank-Datnstring anhand der Zeitschaltpunkte zusammen
  String _buildTimeString(
      {required String wochentag,
      required List<HeatingProfileDatabaseItem> items}) {
    String timeString = '';
    for (int i = 0; i < items.length; i++) {
      timeString +=
          HeatingtimeCalculatorHelper.getHeatingTimeFromModelWithWeekday(
              item: items[i], weekday: _weekdayMapping(wochentag));
    }
    return timeString.isEmpty ? '#' : timeString;
  }

  int _weekdayMapping(String weekday) {
    int weekdayMapping;
    if (weekday == ThermostatInterface.weekdayTuesday) {
      weekdayMapping = 1;
    } else if (weekday == ThermostatInterface.weekdayWednesday) {
      weekdayMapping = 2;
    } else if (weekday == ThermostatInterface.weekdayThursday) {
      weekdayMapping = 3;
    } else if (weekday == ThermostatInterface.weekdayFriday) {
      weekdayMapping = 4;
    } else if (weekday == ThermostatInterface.weekdaySaturday) {
      weekdayMapping = 5;
    } else if (weekday == ThermostatInterface.weekdaySunday) {
      weekdayMapping = 6;
    } else {
      weekdayMapping = 0;
    }
    return weekdayMapping;
  }

  SendScheduleMapBuilder get getMapBuilder => _mapBuilder;
}
