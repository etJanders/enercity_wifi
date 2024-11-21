import 'package:wifi_smart_living/device_specification/thermostat_interface.dart';

import '../const/const_json_identifier.dart';
import '../core/map_helper/map_builder.dart';
import '../models/database/model_room_profile.dart';

class MissingRoomProfiles {
  final List<DefaultProfileHelp> roomProfile = [

    DefaultProfileHelp(
        profileIdentifier: ThermostatInterface.targetTemperature,
        defaultValue: '20'),
    DefaultProfileHelp(
        profileIdentifier: ThermostatInterface.flags, defaultValue: '0182'),
    DefaultProfileHelp(
        profileIdentifier: ThermostatInterface.windowOpenDetection,
        defaultValue: '040A'),
    DefaultProfileHelp(
        profileIdentifier: ThermostatInterface.holidayProfile,
        defaultValue: '#'),
    DefaultProfileHelp(
        profileIdentifier: ThermostatInterface.weekdayMonday,
        defaultValue: '#'),
    DefaultProfileHelp(
        profileIdentifier: ThermostatInterface.weekdayTuesday,
        defaultValue: '#'),
    DefaultProfileHelp(
        profileIdentifier: ThermostatInterface.weekdayWednesday,
        defaultValue: '#'),
    DefaultProfileHelp(
        profileIdentifier: ThermostatInterface.weekdayThursday,
        defaultValue: '#'),
    DefaultProfileHelp(
        profileIdentifier: ThermostatInterface.weekdayFriday,
        defaultValue: '#'),
    DefaultProfileHelp(
        profileIdentifier: ThermostatInterface.weekdaySaturday,
        defaultValue: '#'),
    DefaultProfileHelp(
        profileIdentifier: ThermostatInterface.weekdaySunday,
        defaultValue: '#'),
    DefaultProfileHelp(
        profileIdentifier: ThermostatInterface.groupMac, defaultValue: '#'),


  ];

  late List<ModelRoomProfile> determinedRoomProfiles = [];
  late String detectedGroupId = '';
  final List<CleanUpModelRoomProfile> _models = [];

  MissingRoomProfiles(List<ModelRoomProfile> roomProfile, String groupId) {
    determinedRoomProfiles = roomProfile;
    detectedGroupId = groupId;
    _checkMissingModels();
    _buildDefaultModels();
  }

  //Pruefe welche Daten fehlen
  void _checkMissingModels() {
    for (int j = 0; j < determinedRoomProfiles.length; j++) {
      ModelRoomProfile temp = determinedRoomProfiles[j];
      for (int i = 0; i < roomProfile.length; i++) {
        if (roomProfile[i].profileIdentifier == temp.profileId) {
          roomProfile[i].valueExist = true;
          break;
        }
      }
    }
  }

  //Erstelle models mit fehlenden Daten, die an die Datenbank übergeben werden muessen
  void _buildDefaultModels() {
    for (int i = 0; i < roomProfile.length; i++) {
      DefaultProfileHelp help = roomProfile[i];
      if (!help.valueExist) {
        _models.add(CleanUpModelRoomProfile(
            groupId: detectedGroupId,
            profileIdentifier: help.profileIdentifier,
            profileValue: help.defaultValue,
            deviceTypeId: '0012'));
      }
    }
  }

  List<CleanUpModelRoomProfile> get getMissingModels => _models;
}

class CleanUpModelRoomProfile {
  final String groupId;
  final String profileIdentifier;
  final String profileValue;
  final String deviceTypeId;

  CleanUpModelRoomProfile(
      {required this.groupId,
      required this.profileIdentifier,
      required this.profileValue,
      required this.deviceTypeId});

  Map<String, dynamic> toJson() {
    MapBuilder mapBuilder = MapBuilder();
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierGroupId, value: groupId);
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierProfileId, value: profileIdentifier);
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierProfileValue, value: profileValue);
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierDeviceTypeId, value: deviceTypeId);
    return mapBuilder.getDynamicMap;
  }
}

class DefaultProfileHelp {
  final String profileIdentifier;
  final String defaultValue;
  bool valueExist = false;
  DefaultProfileHelp(
      {required this.profileIdentifier, required this.defaultValue});
}
