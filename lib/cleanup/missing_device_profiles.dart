import 'package:wifi_smart_living/device_specification/thermostat_interface.dart';

import '../const/const_json_identifier.dart';
import '../core/map_helper/map_builder.dart';
import '../models/database/model_device_profile.dart';

class MissingDeviceProfiles {
  final String deviceMacAdress;
  late List<ModelDeviceProfile> receivedDeviceProfiles;
  final List<CleanUpModelDeviceProfile> _missingDeviceModels = [];

  final List<DefaultProfileHelp> _defaultDeviceProfiles = [
    DefaultProfileHelp(
        profileIdentifier: ThermostatInterface.flags, defaultValue: "0182"),
    DefaultProfileHelp(
        profileIdentifier: ThermostatInterface.windowOpenDetection,
        defaultValue: "040A"),
    DefaultProfileHelp(
        profileIdentifier: ThermostatInterface.groupMac, defaultValue: "#"),

    DefaultProfileHelp(
        profileIdentifier: ThermostatInterface.battery, defaultValue: "#"),
    DefaultProfileHelp(
        profileIdentifier: ThermostatInterface.baseSoftwareVersion, defaultValue: "#"),
    DefaultProfileHelp(
        profileIdentifier: ThermostatInterface.radioSoftwareVersion, defaultValue: "#"),
    DefaultProfileHelp(
        profileIdentifier: ThermostatInterface.rssi, defaultValue: "#"),
  ];

  MissingDeviceProfiles(
      {required this.deviceMacAdress,
      required List<ModelDeviceProfile> storedDeviceProfiles}) {
    receivedDeviceProfiles = storedDeviceProfiles;
    _checkMissingModels();
    _buildDefaultModels();
  }

  void _checkMissingModels() {
    for (int i = 0; i < receivedDeviceProfiles.length; i++) {
      ModelDeviceProfile profile = receivedDeviceProfiles[i];
      for (int j = 0; j < _defaultDeviceProfiles.length; j++) {
        if (_defaultDeviceProfiles[j].profileIdentifier == profile.profileId) {
          _defaultDeviceProfiles[j].valueExist = true;
          break;
        }
      }
    }
  }

  void _buildDefaultModels() {
    for (int i = 0; i < _defaultDeviceProfiles.length; i++) {
      DefaultProfileHelp data = _defaultDeviceProfiles[i];
      if (!data.valueExist) {
        _missingDeviceModels.add(CleanUpModelDeviceProfile(
            mac: deviceMacAdress,
            profileIdentifier: data.profileIdentifier,
            profileValue: data.defaultValue));
      }
    }
  }

  List<CleanUpModelDeviceProfile> get getMissingModles => _missingDeviceModels;
}

class CleanUpModelDeviceProfile {
  final String mac;
  final String profileIdentifier;
  final String profileValue;

  CleanUpModelDeviceProfile({
    required this.mac,
    required this.profileIdentifier,
    required this.profileValue,
  });

  Map<String, dynamic> toJson() {
    MapBuilder mapBuilder = MapBuilder();
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierDeviceMacAdress, value: mac);
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierProfileId, value: profileIdentifier);
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierProfileValue, value: profileValue);
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
