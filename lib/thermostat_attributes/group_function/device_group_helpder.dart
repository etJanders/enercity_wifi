import 'package:wifi_smart_living/device_specification/thermostat_interface.dart';
import 'package:wifi_smart_living/models/database/model_device_manaagement.dart';
import 'package:wifi_smart_living/models/database/model_device_profile.dart';
import 'package:wifi_smart_living/models/database/model_room_profile.dart';
import 'package:wifi_smart_living/singelton/helper/api_singelton_helper.dart';

///Descripitons
///if there are more than one devices in a room the app has to group the devices
///fot temperatur change-syncronisation.
///
///
///Author: J. Anders
///created: 28-02-2023
///changed: 28-02-2023
///
///History:
///
///Notes:
///
class DeviceGroupHelper {
  ///Room for which the group function has to check
  final String groupId;
  //summery of specific  device profile of all devices of a room
  late List<ModelDeviceProfile> _groupInformation = [];
  late List<ModelDeviceManagament> _roomDevices = [];
  late final ModelRoomProfile _roomProfile;

  DeviceGroupHelper({required this.groupId}) {
    ApiSingeltonHelper helper = ApiSingeltonHelper();

    ///Determine the group mac entrie of a room
    _roomProfile = helper.getRoomProfile(
        groupId: groupId, profileIdentifier: ThermostatInterface.groupMac);
    _groupInformation = helper.getSpecificProfilesOfARoom(
        groupId: groupId, profileId: ThermostatInterface.groupMac);
    _roomDevices = helper.getDevicesByGroupId(groupId: groupId);
  }

  List<ModelDeviceProfile> getUpdatableDeviceGroups() {
    List<ModelDeviceProfile> updatableDeviceProfiles = [];
    //the room has more than 1 device
    if (_roomDevices.length > 1) {
      //es wurde noch keine Gruppe gebildet
      String groupMac = _roomProfile.profileValue;
      if (groupMac == '#') {
        ///Mac Adresse, which are used as group mac
        groupMac = _roomDevices[0].deviceMac;
        _roomProfile.profileValue = groupMac;
      }
      for (int i = 0; i < _groupInformation.length; i++) {
        ModelDeviceProfile profile = _groupInformation[i];
        if (profile.profileValue == '#' || profile.profileValue != groupMac) {
          profile.profileValue = groupMac;
          updatableDeviceProfiles.add(profile);
        }
      }
    }
    return updatableDeviceProfiles;
  }

  int get getCountOfRoomDevices => _roomDevices.length;
  ModelRoomProfile get getModelRoomProfile => _roomProfile;
}
