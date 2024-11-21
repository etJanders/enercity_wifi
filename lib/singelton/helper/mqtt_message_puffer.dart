import 'package:flutter/foundation.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart';
import 'package:wifi_smart_living/core/uiHelper/build_temperature_string.dart';
import 'package:wifi_smart_living/device_specification/thermostat_interface.dart';
import 'package:wifi_smart_living/models/database/model_device_manaagement.dart';
import 'package:wifi_smart_living/models/database/model_group_management.dart';
import 'package:wifi_smart_living/singelton/helper/api_singelton_helper.dart';
import 'package:wifi_smart_living/singelton/mqttMessagePuffer/mqtt_puffer_queue.dart';
import 'package:wifi_smart_living/validation/mqtt_message/timestam_puffer_validation.dart';

import '../../models/database/model_room_profile.dart';

///Description
///puffer reseived target temperature mqtt messages
///
///Author: J. Anders
///creared: 19-01-2023
///changed: 19-01-2023
///
///History:
///
///Notes:
class MqttMessagePuffer with ChangeNotifier {
  static final MqttMessagePuffer _singelton = MqttMessagePuffer._internal();
  MqttMessagePuffer._internal();

  final Map<String, MqttPufferItem> _pufferMessages =
      <String, MqttPufferItem>{};

  factory MqttMessagePuffer() {
    return _singelton;
  }

  void cleanPuffer() {
    final Map<String, MqttPufferItem> tempMessage = <String, MqttPufferItem>{};
    _pufferMessages.forEach((key, value) {
      if (!MqttPufferTimestampValidation().deleteMessage(value)) {
        //Messages düfen noch nicht gelöscht werden
        tempMessage[key] = value;
      }
    });
    _pufferMessages.clear();
    _pufferMessages.addAll(tempMessage);
  }

  ///Add new values
  void addNewData({required String mac, required String value}) {
    _pufferMessages[mac] = MqttPufferItem(mac: mac, value: value);
    notifyListeners();
  }

  void messageChanged(ModelGroupManagement groupManagement) {
    List<ModelDeviceManagament> devices = ApiSingeltonHelper()
        .getDevicesByGroupId(groupId: groupManagement.groupId);

    ///aktualisiere den db puffer, falls daten in der mqtt queue liegen
    if (_nachrichtenVerpasst(devices)) {
      ModelRoomProfile profile = ApiSingeltonHelper().getRoomProfile(
          groupId: groupManagement.groupId,
          profileIdentifier: ThermostatInterface.targetTemperature);
      if (_getMessageValue(devices[0].deviceMac).isNotEmpty) {
        if (profile.profileValue !=
            _pufferMessages[devices[0].deviceMac]!.value) {
          ApiSingeltonHelper().setNewTemperature(
              groupManagement, _pufferMessages[devices[0].deviceMac]!.value);
        }
      }
    }
  }

  String _getMessageValue(String mac) {
    String messageValue = "";
    if (_pufferMessages.containsKey(mac)) {
      messageValue = _pufferMessages[mac]!.value;
    }
    return messageValue;
  }

  bool _nachrichtenVerpasst(List<ModelDeviceManagament> devices) {
    bool nachrichtenVerpasst = false;
    for (int i = 0; i < devices.length; i++) {
      if (_pufferMessages.containsKey(devices[i].deviceMac)) {
        nachrichtenVerpasst = true;
        break;
      }
    }
    return nachrichtenVerpasst;
  }

  bool getErrorProfile(ModelGroupManagement management) {
    print("checking for balue");

    var macs = ApiSingeltonHelper()
        .determineRoomDeviceMacs(groupId: management.groupId);

    for (int i = 0; i < macs.length; i++) {
      print("MAC$i ${macs[i]}");
      var room = ApiSingeltonHelper().getDeviceProfileValue(
          mac: macs[i],
          profile: ThermostatInterface.holidayProfileActiveIndicator);

      if (room.profileValue.isNotEmpty && room.profileValue != "#") {
        String value = int.parse(room.profileValue, radix: 16).toString();
        print("value is $value");
        var holidayIndicatorValue =
            int.parse(value, radix: 10).toRadixString(2).padLeft(16, "0");
        print("Device ${macs[i]} BD value obtained is  $holidayIndicatorValue");
        if (holidayIndicatorValue.isNotEmpty &&
            (holidayIndicatorValue[15] == '1' ||
                holidayIndicatorValue[14] == '1' ||
                holidayIndicatorValue[13] == '1')) {
          return true;
        }
      }
    }
    return false;
  }

  bool getErrorProfileDeviceLevel(ModelDeviceManagament management) {
    print("checking for balue");

    var macs = management.deviceMac;
    //for(int i=0;i<macs.length;i++){
    var room = ApiSingeltonHelper().getDeviceProfileValue(
        mac: macs, profile: ThermostatInterface.holidayProfileActiveIndicator);

    if (room.profileValue.isNotEmpty && room.profileValue != "#") {
      String value = int.parse(room.profileValue, radix: 16).toString();
      print("value is $value");
      var holidayIndicatorValue =
          int.parse(value, radix: 10).toRadixString(2).padLeft(16, "0");
      print(
          "Device ${management.deviceName} BD value obtained is  $holidayIndicatorValue");
      if (holidayIndicatorValue.isNotEmpty &&
          (holidayIndicatorValue[15] == '1' ||
              holidayIndicatorValue[14] == '1' ||
              holidayIndicatorValue[13] == '1')) {
        return true;
      }
    }
    //   }
    return false;
  }

  bool getWindowDetectionProfileDeviceLevel(ModelDeviceManagament management) {
    print("checking for balue");

    var macs = management.deviceMac;
    //for(int i=0;i<macs.length;i++){
    var room = ApiSingeltonHelper().getDeviceProfileValue(
        mac: macs, profile: ThermostatInterface.holidayProfileActiveIndicator);

    if (room.profileValue.isNotEmpty && room.profileValue != "#") {
      String value = int.parse(room.profileValue, radix: 16).toString();
      print("value is $value");
      var holidayIndicatorValue =
          int.parse(value, radix: 10).toRadixString(2).padLeft(16, "0");
      print(
          "Device ${management.deviceName} BD value obtained is  $holidayIndicatorValue");
      if (holidayIndicatorValue.isNotEmpty &&
          holidayIndicatorValue[11] == '1') {
        return true;
      }
    }
    //   }
    return false;
  }

  bool getWindowDetectionProfile(ModelGroupManagement management) {
    print("checking for balue");

    var macs = ApiSingeltonHelper()
        .determineRoomDeviceMacs(groupId: management.groupId);
    for (int i = 0; i < macs.length; i++) {
      var room = ApiSingeltonHelper().getDeviceProfileValue(
          mac: macs[i],
          profile: ThermostatInterface.holidayProfileActiveIndicator);

      if (room.profileValue.isNotEmpty && room.profileValue != "#") {
        String value = int.parse(room.profileValue, radix: 16).toString();
        print("value is $value");
        var holidayIndicatorValue =
            int.parse(value, radix: 10).toRadixString(2).padLeft(16, "0");
        print(
            "Device ${macs[i]}  BD value obtained is  $holidayIndicatorValue");
        if (holidayIndicatorValue.isNotEmpty &&
            holidayIndicatorValue[11] == '1') {
          return true;
        }
      }
    }
    return false;
  }

  // Introduced by Zubair
  bool getHolidayProfileActive(ModelGroupManagement management) {
    print("checking for value");

    messageChanged(ApiSingeltonHelper()
        .getGroupManagementByGroupId(groupId: management.groupId));

    ModelRoomProfile roomProfile = ApiSingeltonHelper().getRoomProfile(
        groupId: management.groupId,
        profileIdentifier: ThermostatInterface.targetTemperature);

    ModelRoomProfile roomProfileHoliday = ApiSingeltonHelper().getRoomProfile(
        groupId: management.groupId,
        profileIdentifier: ThermostatInterface.holidayProfile);
    if (ApiSingeltonHelper()
        .determineRoomDeviceMacs(groupId: management.groupId)
        .isEmpty) {
      return false;
    }

    var macs = ApiSingeltonHelper()
        .determineRoomDeviceMacs(groupId: management.groupId);

    for (int i = 0; i < macs.length; i++) {
      var room = ApiSingeltonHelper().getDeviceProfileValue(
          mac: ApiSingeltonHelper()
              .determineRoomDeviceMacs(groupId: management.groupId)[i],
          profile: ThermostatInterface.holidayProfileActiveIndicator);

      if (room.profileValue.isNotEmpty &&
          room.profileValue != "#") //check for valid room activation code
      {
        print("check for check for valid room activation code passed");
        print(room.profileValue);
        String value = int.parse(room.profileValue, radix: 16).toString();
        print("value is $value");
        var holidayIndicatorValue =
            int.parse(value, radix: 10).toRadixString(2).padLeft(16, "0");
        if (holidayIndicatorValue.isNotEmpty &&
            holidayIndicatorValue[10] == '1') {
          print("A7 value is ${roomProfileHoliday.profileValue}");
          if (roomProfileHoliday.profileValue != "#") {
            //extract the end time and compare with the current time stamp to check if holiday profile has expired
            print("=====================");
            if (checkIfHolidayProfileExpired(roomProfileHoliday.profileValue)) {
              return true;
            }
          }
        } // when holiday mode is active but A7 is # or holiday profile is inactive
        else if (roomProfile.profileValue.isEmpty ||
            roomProfile.profileValue == '#') {
          print("check for check for invaid valid A0 failed");
          // return false;
        } //target temperature value is invalid or null
      }
      print("displaying A0");
      //return false;
    }
    return false;
//when holiday mode is inactive -- no check for A7
  }
//=========================================================

  String getTemperature(ModelGroupManagement management) {
    messageChanged(ApiSingeltonHelper()
        .getGroupManagementByGroupId(groupId: management.groupId));
    ModelRoomProfile roomProfile = ApiSingeltonHelper().getRoomProfile(
        groupId: management.groupId,
        profileIdentifier: ThermostatInterface.targetTemperature);
    ModelRoomProfile roomProfileHoliday = ApiSingeltonHelper().getRoomProfile(
        groupId: management.groupId,
        profileIdentifier: ThermostatInterface.holidayProfile);
    if (ApiSingeltonHelper()
        .determineRoomDeviceMacs(groupId: management.groupId)
        .isEmpty) {
      return '--';
    }
    var room = ApiSingeltonHelper().getDeviceProfileValue(
        mac: ApiSingeltonHelper()
            .determineRoomDeviceMacs(groupId: management.groupId)[0],
        profile: ThermostatInterface.holidayProfileActiveIndicator);
    if (room.profileValue.isNotEmpty &&
        room.profileValue != "#") //check for valid room activation code
    {
      print("check for check for valid room activation code passed");
      print(room.profileValue);
      String value = int.parse(room.profileValue, radix: 16).toString();
      print("value is $value");
      var holidayIndicatorValue =
          int.parse(value, radix: 10).toRadixString(2).padLeft(16, "0");
      print("BD value is $holidayIndicatorValue");
      if (holidayIndicatorValue.isNotEmpty &&
          holidayIndicatorValue[10] == '1') {
        print("A7 value is ${roomProfileHoliday.profileValue}");
        if (roomProfileHoliday.profileValue != "#") {
          print("check for check for valid A7 passed");
          String temperature = roomProfileHoliday.profileValue
              .substring(roomProfileHoliday.profileValue.length - 2);
          print(temperature);
          print("A7 value is used");
          if (checkIfHolidayProfileExpired(roomProfileHoliday.profileValue) ==
              true) {
            return BuildTemperatureString.bildTemperatureString(
                temperature: int.parse(temperature, radix: 16));
          }
        }
      } // when holiday mode is active but A7 is # or holiday profile is inactive
      //target temperature value is invalid or null
    } else if (roomProfile.profileValue.isEmpty ||
        roomProfile.profileValue == '#') {
      print("check for check for invaid valid A0 failed");
      return BuildTemperatureString.bildTemperatureString(
          temperature: int.parse("20", radix: 16));
    }
    print("displaying A0");
    return BuildTemperatureString.bildTemperatureString(
        temperature: int.parse(roomProfile.profileValue,
            radix: 16)); //when holiday mode is inactive -- no check for A7
  }

  String getTemperatureHex(ModelGroupManagement management) {
    messageChanged(ApiSingeltonHelper()
        .getGroupManagementByGroupId(groupId: management.groupId));
    ModelRoomProfile roomProfile = ApiSingeltonHelper().getRoomProfile(
        groupId: management.groupId,
        profileIdentifier: ThermostatInterface.targetTemperature);
    if (roomProfile.profileValue.isEmpty || roomProfile.profileValue == '#') {
      return '20';
    }
    return roomProfile.profileValue;
  }

  String getHexTemperature(ModelGroupManagement management) {
    messageChanged(ApiSingeltonHelper()
        .getGroupManagementByGroupId(groupId: management.groupId));
    ModelRoomProfile roomProfile = ApiSingeltonHelper().getRoomProfile(
        groupId: management.groupId,
        profileIdentifier: ThermostatInterface.targetTemperature);
    ModelRoomProfile roomProfileHoliday = ApiSingeltonHelper().getRoomProfile(
        groupId: management.groupId,
        profileIdentifier: ThermostatInterface.holidayProfile);
    if (ApiSingeltonHelper()
        .determineRoomDeviceMacs(groupId: management.groupId)
        .isEmpty) {
      return "--";
    }
    var room = ApiSingeltonHelper().getDeviceProfileValue(
        mac: ApiSingeltonHelper()
            .determineRoomDeviceMacs(groupId: management.groupId)[0],
        profile: ThermostatInterface.holidayProfileActiveIndicator);
    if (room.profileValue.isNotEmpty &&
        room.profileValue != "#") //check for valid room activation code
    {
      String value = int.parse(room.profileValue, radix: 16).toString();
      var holidayIndicatorValue =
          int.parse(value, radix: 10).toRadixString(2).padLeft(16, "0");
      if (holidayIndicatorValue.isNotEmpty &&
          holidayIndicatorValue[10] == '1') {
        if (roomProfileHoliday.profileValue != "#") {
          String temperature = roomProfileHoliday.profileValue
              .substring(roomProfileHoliday.profileValue.length - 2);
          if (checkIfHolidayProfileExpired(roomProfileHoliday.profileValue) ==
              true) {
            print(
                "=================${int.parse(temperature, radix: 16)}============");
            return temperature;
          }
        }
      } // when holiday mode is active but A7 is # or holiday profile is inactive
      //target temperature value is invalid or null
    } else if (roomProfile.profileValue.isEmpty ||
        roomProfile.profileValue == '#') {
      return "16";
    }

    return roomProfile.profileValue;
    //when holiday mode is inactive -- no check for A7
  }

  bool checkIfHolidayProfileExpired(String roomProfileValue) {
    String year = roomProfileValue.substring(
        roomProfileValue.length - 4, roomProfileValue.length - 2);
    var yeasrdecimal = int.parse(year, radix: 16);

    String month = roomProfileValue.substring(
        roomProfileValue.length - 6, roomProfileValue.length - 4);
    var monthdecimal = int.parse(month, radix: 16);

    String day = roomProfileValue.substring(
        roomProfileValue.length - 8, roomProfileValue.length - 6);
    var daydecimal = int.parse(day, radix: 16);

    String hour = roomProfileValue.substring(
        roomProfileValue.length - 10, roomProfileValue.length - 8);
    var hourdecimal = int.parse(hour, radix: 16);

    tz.initializeTimeZones();
    DateTime localTime = DateTime.now();
    Location germanyLocation = getLocation('Europe/Berlin');
    TZDateTime germanyTime = TZDateTime.from(localTime, germanyLocation);
    int yearGerman = germanyTime.year;
    yearGerman = yearGerman - 2000;
    int monthGerman = germanyTime.month;
    int dayGerman = germanyTime.day;
    int hourGerman = germanyTime.hour;
    // print(yearGerman);
    // print(monthGerman);
    // print(dayGerman);
    // print(hourGerman);
    // print("=====================");
    // print(yeasrdecimal);
    // print(monthdecimal);
    // print(daydecimal);
    // print(hourdecimal);
    // print("=====================");
    // print(timeYearLastDigits);
    // print(timeGerman.month);
    // print(timeGerman.day);
    // print(timeGerman.hour);
    // print("=====================");
    //
    //

    if (yearGerman > yeasrdecimal) {
      print("current y > set y");
      return false;
    } else if (yearGerman == yeasrdecimal) {
      print("current y = set y");
      if (monthGerman > monthdecimal) {
        print("current m > set m");
        return false;
      } else if (monthGerman == monthdecimal) {
        print("current m == set m");
        if (dayGerman > daydecimal) {
          print("current d > set d");
          return false;
        } else if (dayGerman == daydecimal) {
          print("current d == set d");
          if (hourGerman >= hourdecimal) {
            print("current h >= set h");
            return false;
          } else {
            print("current h <set h");
            return true;
          }
        } else {
          print("current d < set d");
          return true;
        }
      } else {
        print("current m < set m");
        return true;
      }
    } else {
      print("current y < set y");
      return true;
    }
  }
}
