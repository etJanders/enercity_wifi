import 'package:wifi_smart_living/device_specification/thermostat_interface.dart';

class SendScheduleMapBuilder {
  final Map<String, String> _scheduleMap = <String, String>{};

  SendScheduleMapBuilder() {
    _initMap();
  }

  void _initMap() {
    _scheduleMap[ThermostatInterface.weekdayMonday] = '#';
    _scheduleMap[ThermostatInterface.weekdayTuesday] = '#';
    _scheduleMap[ThermostatInterface.weekdayWednesday] = '#';
    _scheduleMap[ThermostatInterface.weekdayThursday] = '#';
    _scheduleMap[ThermostatInterface.weekdayFriday] = '#';
    _scheduleMap[ThermostatInterface.weekdaySaturday] = '#';
    _scheduleMap[ThermostatInterface.weekdaySunday] = '#';
  }

  void changeData(String identifier, String value) {
    if (_scheduleMap.containsKey(identifier)) {
      _scheduleMap[identifier] = value;
    }
  }

  String getValue(String key) {
    String value = '#';
    if (_scheduleMap.containsKey(key)) {
      value = _scheduleMap[key]!;
    }
    return value;
  }

  bool heatingProfileEmpty() {
    return _scheduleMap[ThermostatInterface.weekdayMonday] == '#' &&
        _scheduleMap[ThermostatInterface.weekdayTuesday] == '#' &&
        _scheduleMap[ThermostatInterface.weekdayWednesday] == '#' &&
        _scheduleMap[ThermostatInterface.weekdayThursday] == '#' &&
        _scheduleMap[ThermostatInterface.weekdayFriday] == '#' &&
        _scheduleMap[ThermostatInterface.weekdaySaturday] == '#' &&
        _scheduleMap[ThermostatInterface.weekdaySunday] == '#';
  }

  Map<String, String> get getMap => _scheduleMap;
}
