import 'package:wifi_smart_living/const/const_schedule_id.dart';
import 'package:wifi_smart_living/device_specification/thermostat_interface.dart';
import 'package:wifi_smart_living/models/database/model_device_group.dart';
import 'package:wifi_smart_living/models/database/model_device_manaagement.dart';
import 'package:wifi_smart_living/models/database/model_device_profile.dart';
import 'package:wifi_smart_living/models/database/model_group_management.dart';
import 'package:wifi_smart_living/models/database/model_room_profile.dart';
import 'package:wifi_smart_living/models/database/model_schedule_group.dart';
import 'package:wifi_smart_living/models/database/model_schedule_manager.dart';
import 'package:wifi_smart_living/singelton/api_singelton.dart';
import 'package:wifi_smart_living/thermostat_attributes/flags.dart';

import '../../api_handler/api_treiber/sync/sync_database_entries.dart';
import '../../presentation/thermostat_settings/offset_mapping/offset_mapping.dart';

class ApiSingeltonHelper {
  ApiSingelton apiSingelton = ApiSingelton();

  List<ModelDeviceManagament> getDevicesByGroupId({required String groupId}) {
    return getRoomThermostats(
        macAdreses: determineRoomDeviceMacs(groupId: groupId));
  }

  List<String> getAllGroupIds() {
    List<ModelGroupManagement> groupManagements =
        apiSingelton.getModelGroupManagement;
    List<String> groupsIds = [];
    for (int i = 0; i < groupManagements.length; i++) {
      groupsIds.add(groupManagements[i].groupId);
    }
    return groupsIds;
  }

  List<String> getAllMacIds() {
    List<ModelDeviceManagament> deviceManagements =
        apiSingelton.getModelDeviceManagement;
    List<String> MACIds = [];
    for (int i = 0; i < deviceManagements.length; i++) {
      MACIds.add(deviceManagements[i].deviceMac);
    }
    return MACIds;
  }

  List<ModelDeviceManagament> getRoomThermostats(
      {required List<String> macAdreses}) {
    List<ModelDeviceManagament> roomDevices = [];
    List<ModelDeviceManagament> allDevices =
        apiSingelton.getModelDeviceManagement;

    for (int i = 0; i < macAdreses.length; i++) {
      String mac = macAdreses[i];
      for (int j = 0; j < allDevices.length; j++) {
        ModelDeviceManagament managament = allDevices[j];
        print(managament.deviceMac);
        if (managament.deviceMac == mac) {
          roomDevices.add(managament);
        }
      }
    }
    return roomDevices;
  }

  ModelGroupManagement getGroupManagementByGroupId({required String groupId}) {
    ModelGroupManagement management = ModelGroupManagement(
        entryPublicId: '',
        groupId: groupId,
        location: 10,
        groupName: '',
        groupImage: '',
        groupOwner: '',
        uiPosition: 0);
    for (int i = 0; i < apiSingelton.getModelGroupManagement.length; i++) {
      if (apiSingelton.getModelGroupManagement[i].groupId == groupId) {
        management = apiSingelton.getModelGroupManagement[i];
        break;
      }
    }
    return management;
  }

  List<String> determineRoomDeviceMacs({required String groupId}) {
    List<ModelDeviceGroup> allDeviceGroups = apiSingelton.getModeldeviceGroup;
    List<String> macAdresses = [];

    for (int i = 0; i < allDeviceGroups.length; i++) {
      ModelDeviceGroup group = allDeviceGroups[i];
      if (group.groupId == groupId) {
        macAdresses.add(group.deviceMac);
      }
    }
    return macAdresses;
  }

  ModelDeviceProfile getDeviceProfileValue(
      {required String mac, required String profile}) {
    List<ModelDeviceProfile> allProfiles =
        apiSingelton.getModelDeviceProfileList;
    ModelDeviceProfile model = ModelDeviceProfile(
        entryPublicId: "",
        macAdress: mac,
        profileId: profile,
        profileValue: '#');
    for (int i = 0; i < allProfiles.length; i++) {
      ModelDeviceProfile temp = allProfiles[i];
      if (temp.macAdress == mac && temp.profileId == profile) {
        model = temp;
        break;
      }
    }
    return model;
  }

  ModelRoomProfile getRoomProfile(
      {required String groupId, required String profileIdentifier}) {
    List<ModelRoomProfile> allRoomProfiles = apiSingelton.getModelGroupProfile;
    ModelRoomProfile roomProfile = ModelRoomProfile(
        entryPublicId: "",
        groupId: groupId,
        profileId: profileIdentifier,
        profileValue: "#",
        deviceTypeId: "");
    for (int i = 0; i < allRoomProfiles.length; i++) {
      ModelRoomProfile temp = allRoomProfiles[i];
      if (temp.groupId == groupId && temp.profileId == profileIdentifier) {
        return allRoomProfiles[i];
      }
    }
    return roomProfile;
  }

  List<ModelRoomProfile> getRoomProfileByGroupID({required String groupId}) {
    List<ModelRoomProfile> allRoomProfiles = apiSingelton.getModelGroupProfile;
    List<ModelRoomProfile> validRoomProfile = [];
    for (int i = 0; i < allRoomProfiles.length; i++) {
      ModelRoomProfile temp = allRoomProfiles[i];
      if (temp.groupId == groupId) {
        validRoomProfile.add(temp);
      }
    }
    return validRoomProfile;
  }

  List<ModelRoomProfile> getRoomProfileByGroupIDs({required String groupId}) {
    List<ModelRoomProfile> allRoomProfiles = apiSingelton.getModelGroupProfile;
    return allRoomProfiles
        .where((element) => element.groupId == groupId)
        .toList();
  }

  List<ModelDeviceProfile> getDeviceProfileByGroupIDs({required String macId}) {
    List<ModelDeviceProfile> allRoomProfiles =
        apiSingelton.getModelDeviceProfileList;
    return allRoomProfiles
        .where((element) => element.macAdress == macId)
        .toList();
  }
  //

  List<ModelDeviceProfile> getDeviceProfileByMACID({required String macID}) {
    List<ModelDeviceProfile> allRoomProfiles =
        apiSingelton.getModelDeviceProfileList;
    List<ModelDeviceProfile> validRoomProfile = [];
    for (int i = 0; i < allRoomProfiles.length; i++) {
      ModelDeviceProfile temp = allRoomProfiles[i];
      if (temp.macAdress == macID) {
        validRoomProfile.add(temp);
      }
    }
    return validRoomProfile;
  }

  ModelDeviceProfile updateDeviceProfile(
      {required String macAdress,
      required String profileId,
      required String profileValue}) {
    ModelDeviceProfile profile = ModelDeviceProfile(
        entryPublicId: '',
        macAdress: macAdress,
        profileId: profileId,
        profileValue: profileValue);
    for (int i = 0; i < apiSingelton.getModelDeviceProfileList.length; i++) {
      if (apiSingelton.getModelDeviceProfileList[i].macAdress == macAdress &&
          apiSingelton.getModelDeviceProfileList[i].profileId == profileId) {
        apiSingelton.getModelDeviceProfileList[i].profileValue = profileValue;
        profile = apiSingelton.getModelDeviceProfileList[i];
        break;
      }
    }
    return profile;
  }

  bool batterieEmpty({required String groupId}) {
    bool batteryEmpty = false;
    List<ModelDeviceManagament> list = getDevicesByGroupId(groupId: groupId);
    for (int i = 0; i < list.length; i++) {
      ModelDeviceProfile profile = getDeviceProfileValue(
          mac: list[i].deviceMac, profile: ThermostatInterface.battery);

      if (profile.profileValue != '#' && profile.profileValue.isNotEmpty) {
        int profileVale = int.parse(profile.profileValue);
        if (profileVale < 10) {
          batteryEmpty = true;
          break;
        }
      }
    }
    return batteryEmpty;
  }

  ///Check if batteriess are empty of a single device

  bool batteryEmpty({required String mac}) {
    bool batteryEmpty = false;
    ModelDeviceProfile profile =
        getDeviceProfileValue(mac: mac, profile: ThermostatInterface.battery);
    if (profile.profileValue != '#') {
      int profileVale = int.parse(profile.profileValue);
      if (profileVale < 10) {
        batteryEmpty = true;
      }
    }
    return batteryEmpty;
  }

  //Check which rooms are added to a heating profile
  List<ModelGroupManagement> getGroupsWithoutTimeSchedule() {
    List<ModelGroupManagement> managementList =
        apiSingelton.getModelGroupManagement;
    List<ModelGroupManagement> output = [];
    if (apiSingelton
        .getScheduleById(ConstScheduleId.timeScheduleProfileId)
        .isEmpty) {
      output = managementList;
    } else {
      for (int i = 0; i < managementList.length; i++) {
        ModelGroupManagement tempGroup = managementList[i];
        if (!_existTimeScheduleForRoom(tempGroup)) {
          output.add(tempGroup);
        }
      }
    }
    return output;
  }

  List<ModelGroupManagement> getGroupsWithoutHolidaySchedule() {
    List<ModelGroupManagement> managementList =
        apiSingelton.getModelGroupManagement;
    List<ModelGroupManagement> output = [];
    if (apiSingelton
        .getScheduleById(ConstScheduleId.holidayProfileScheduleId)
        .isEmpty) {
      output = managementList;
    } else {
      for (int i = 0; i < managementList.length; i++) {
        ModelGroupManagement tempGroup = managementList[i];
        if (!_existHolidayForRoom(tempGroup)) {
          output.add(tempGroup);
        }
      }
    }
    return output;
  }

  bool _existTimeScheduleForRoom(ModelGroupManagement management) {
    bool roomAdded = false;
    List<ModelScheduleGroup> scheduleGroup = apiSingelton.getScheduleGroup;
    List<ModelScheduleManager> scheduleManager =
        apiSingelton.getScheduleById(ConstScheduleId.timeScheduleProfileId);

    for (int i = 0; i < scheduleGroup.length; i++) {
      ModelScheduleGroup temp = scheduleGroup[i];
      for (int k = 0; k < scheduleManager.length; k++) {
        var temp2 = scheduleManager[k];
        if (temp.scheduleManagerPublicId == temp2.entryPublicId &&
            management.groupId == temp.groupId) {
          roomAdded = true;
          return roomAdded;
        }
      }
    }
    return roomAdded;
  }

  bool _existHolidayForRoom(ModelGroupManagement management) {
    bool roomAdded = false;
    List<ModelScheduleGroup> scheduleGroup = apiSingelton.getScheduleGroup;

    List<ModelScheduleManager> scheduleManager =
        apiSingelton.getScheduleById(ConstScheduleId.holidayProfileScheduleId);
    for (int i = 0; i < scheduleGroup.length; i++) {
      var temp = scheduleGroup[i];
      for (int k = 0; k < scheduleManager.length; k++) {
        var temp2 = scheduleManager[k];
        if (temp.scheduleManagerPublicId == temp2.entryPublicId &&
            management.groupId == temp.groupId) {
          roomAdded = true;
          return roomAdded;
        }
      }
    }
    return roomAdded;
  }

  List<ModelGroupManagement> getGroupsWithoutHolidayProfile() {
    List<ModelGroupManagement> managementList =
        apiSingelton.getModelGroupManagement;
    List<ModelGroupManagement> output = [];
    if (apiSingelton
        .getScheduleById(ConstScheduleId.holidayProfileScheduleId)
        .isEmpty) {
      output = managementList;
    } else {
      for (int i = 0; i < managementList.length; i++) {
        ModelGroupManagement tempGroup = managementList[i];
        if (!_existHolidayForRoom(tempGroup)) {
          output.add(tempGroup);
        }
      }
    }
    return output;
  }

  List<ModelRoomProfile> getHeatingProfile(String groupId) {
    List<ModelRoomProfile> heatingprofileOutput = [];
    List<ModelRoomProfile> allProfiles = apiSingelton.getModelGroupProfile;
    for (int i = 0; i < allProfiles.length; i++) {
      ModelRoomProfile temp = allProfiles[i];
      if (temp.groupId == groupId) {
        if (temp.profileId == ThermostatInterface.weekdayMonday ||
            temp.profileId == ThermostatInterface.weekdayTuesday ||
            temp.profileId == ThermostatInterface.weekdayWednesday ||
            temp.profileId == ThermostatInterface.weekdayThursday ||
            temp.profileId == ThermostatInterface.weekdayFriday ||
            temp.profileId == ThermostatInterface.weekdaySaturday ||
            temp.profileId == ThermostatInterface.weekdaySunday) {
          heatingprofileOutput.add(temp);
        }
      }
    }
    return heatingprofileOutput;
  }

  List<ModelRoomProfile> getHolidayProfileExisting(String groupId) {
    List<ModelRoomProfile> heatingprofileOutput = [];
    List<ModelRoomProfile> allProfiles = apiSingelton.getModelGroupProfile;
    for (int i = 0; i < allProfiles.length; i++) {
      ModelRoomProfile temp = allProfiles[i];
      if (temp.groupId == groupId) {
        if (temp.profileId == ThermostatInterface.holidayProfile) {
          heatingprofileOutput.add(temp);
        }
      }
    }
    return heatingprofileOutput;
  }

  List<String> getGroupIdsFromHeatingProfile({required String smPublicId}) {
    List<String> profileGroups = [];
    List<ModelScheduleGroup> scheduleGrops = apiSingelton.getScheduleGroup;
    for (int i = 0; i < scheduleGrops.length; i++) {
      ModelScheduleGroup group = scheduleGrops[i];
      if (group.scheduleManagerPublicId == smPublicId) {
        profileGroups.add(group.groupId);
      }
    }
    return profileGroups;
  }

  List<String> getAllGroupIdsOfHeatingProfile() {
    List<String> profileGroups = [];
    List<ModelScheduleGroup> scheduleGrops = apiSingelton.getScheduleGroup;
    for (int i = 0; i < scheduleGrops.length; i++) {
      ModelScheduleGroup group = scheduleGrops[i];
      profileGroups.add(group.groupId);
    }
    return profileGroups;
  }

  List<String> getAllGroupIdsOfHolidayProfile() {
    List<String> profileGroups = [];
    List<ModelScheduleGroup> scheduleGrops = apiSingelton.getScheduleGroup;
    for (int i = 0; i < scheduleGrops.length; i++) {
      ModelScheduleGroup group = scheduleGrops[i];
      profileGroups.add(group.groupId);
    }
    return profileGroups;
  }

  List<ModelRoomProfile> getProfilesBySchedulemanager(
      ModelScheduleManager scheduleManager) {
    List<String> data = getGroupIdsFromHeatingProfile(
        smPublicId: scheduleManager.entryPublicId);
    return getHeatingProfile(data[0]);
  }

  List<String> getAllDevicesOfSchedule({required String smPublicId}) {
    List<ModelDeviceGroup> groups = apiSingelton.getModeldeviceGroup;
    List<String> deviceMacAdresses = [];
    List<String> groupIds =
        getGroupIdsFromHeatingProfile(smPublicId: smPublicId);
    for (int i = 0; i < groupIds.length; i++) {
      String groupId = groupIds[i];
      for (int j = 0; j < groups.length; j++) {
        if (groups[j].groupId == groupId) {
          deviceMacAdresses.add(groups[j].deviceMac);
        }
      }
    }
    return deviceMacAdresses;
  }

  void setNewTemperature(
      ModelGroupManagement groupManagement, String tempValue) {
    int index = _findIndexOfRoomProfile(
        groupManagement, ThermostatInterface.targetTemperature);
    if (index != -1) {
      apiSingelton.getModelGroupProfile[index].profileValue = tempValue;
    }
  }

  List<ModelGroupManagement> groupManagementsByLocation(int locationId) {
    List<ModelGroupManagement> locationRooms = [];
    for (int i = 0; i < ApiSingelton().getModelGroupManagement.length; i++) {
      if (ApiSingelton().getModelGroupManagement[i].location == locationId) {
        locationRooms.add(ApiSingelton().getModelGroupManagement[i]);
      }
    }
    return locationRooms;
  }

  int _findIndexOfRoomProfile(
      ModelGroupManagement groupManagement, String profileId) {
    int index = -1;
    for (int i = 0; i < apiSingelton.getModelGroupProfile.length; i++) {
      ModelRoomProfile roomProfile = apiSingelton.getModelGroupProfile[i];
      if (roomProfile.groupId == groupManagement.groupId &&
          roomProfile.profileId == profileId) {
        index = i;
        break;
      }
    }
    return index;
  }

  String getHolidayProfile({required String smPublicId}) {
    String holidayProfile = '#';
    List<String> groupIds =
        getGroupIdsFromHeatingProfile(smPublicId: smPublicId);
    if (groupIds.isNotEmpty) {
      ModelRoomProfile profile = getRoomProfile(
          groupId: groupIds[0],
          profileIdentifier: ThermostatInterface.holidayProfile);
      holidayProfile = profile.profileValue;
    }
    return holidayProfile;
  }

  ThermostatFlags getFlags({required String groupId}) {
    ModelRoomProfile roomProfile = getRoomProfile(
        groupId: groupId, profileIdentifier: ThermostatInterface.flags);
    return ThermostatFlags(roomProfile.profileValue);
  }

  List<ModelGroupManagement> groupsOfTimeSchedule(
      {required String smPubblicId}) {
    List<ModelGroupManagement> connectedRooms = [];
    List<String> connectedRoomIds =
        _groupIdsFromSchedule(smPubblicId: smPubblicId);
    for (int i = 0; i < connectedRoomIds.length; i++) {
      connectedRooms
          .add(getGroupManagementByGroupId(groupId: connectedRoomIds[i]));
    }
    return connectedRooms;
  }

  List<ModelGroupManagement> groupsOfHolidaySchedule(
      {required String smPubblicId}) {
    List<ModelGroupManagement> connectedRooms = [];
    List<String> connectedRoomIds =
        _groupIdsFromSchedule(smPubblicId: smPubblicId);
    for (int i = 0; i < connectedRoomIds.length; i++) {
      connectedRooms
          .add(getGroupManagementByGroupId(groupId: connectedRoomIds[i]));
    }
    return connectedRooms;
  }

  List<String> _groupIdsFromSchedule({required String smPubblicId}) {
    List<String> connectedRooms = [];
    List<ModelScheduleGroup> scheduleGroup = apiSingelton.getScheduleGroup;
    for (int i = 0; i < scheduleGroup.length; i++) {
      if (scheduleGroup[i].scheduleManagerPublicId == smPubblicId) {
        connectedRooms.add(scheduleGroup[i].groupId);
      }
    }
    return connectedRooms;
  }

  ModelScheduleGroup getScheduleGroupOfRoom(
      {required ModelGroupManagement management}) {
    ModelScheduleGroup group = ModelScheduleGroup(
        entryPublicId: '', scheduleManagerPublicId: '', groupId: '');
    for (int i = 0; i < apiSingelton.getScheduleGroup.length; i++) {
      if (apiSingelton.getScheduleGroup[i].groupId == management.groupId) {
        group = apiSingelton.getScheduleGroup[i];
        break;
      }
    }
    return group;
  }

  ModelScheduleGroup getHeatingScheduleGroupOfRoom(
      {required ModelGroupManagement management}) {
    ModelScheduleGroup group = ModelScheduleGroup(
        entryPublicId: '', scheduleManagerPublicId: '', groupId: '');
    for (int i = 0; i < apiSingelton.getScheduleGroup.length; i++) {
      if (apiSingelton.getScheduleGroup[i].groupId == management.groupId) {
        var schedule =
            apiSingelton.getScheduleById(ConstScheduleId.timeScheduleProfileId);
        for (int k = 0; k < schedule.length; k++) {
          if (schedule[k].entryPublicId ==
              apiSingelton.getScheduleGroup[i].scheduleManagerPublicId) {
            group = apiSingelton.getScheduleGroup[i];
            break;
          }
        }
      }
    }
    return group;
  }

  ModelScheduleGroup getHolidayScheduleGroupOfRoom(
      {required ModelGroupManagement management}) {
    ModelScheduleGroup group = ModelScheduleGroup(
        entryPublicId: '', scheduleManagerPublicId: '', groupId: '');
    for (int i = 0; i < apiSingelton.getScheduleGroup.length; i++) {
      if (apiSingelton.getScheduleGroup[i].groupId == management.groupId) {
        var schedule = apiSingelton
            .getScheduleById(ConstScheduleId.holidayProfileScheduleId);
        for (int k = 0; k < schedule.length; k++) {
          if (schedule[k].entryPublicId ==
              apiSingelton.getScheduleGroup[i].scheduleManagerPublicId) {
            group = apiSingelton.getScheduleGroup[i];
            break;
          }
        }
      }
    }
    return group;
  }

  ModelScheduleManager getManagerFromScheduleGroup(
      {required ModelScheduleGroup group, required String scheduleId}) {
    ModelScheduleManager manager = ModelScheduleManager(
        entryPublicId: '', scheduleName: '', scheudleImage: '', scheduleId: '');

    List<ModelScheduleManager> scheduleManagerList =
        apiSingelton.getScheduleById(scheduleId);
    for (int i = 0; i < scheduleManagerList.length; i++) {
      if (scheduleManagerList[i].entryPublicId ==
          group.scheduleManagerPublicId) {
        manager = scheduleManagerList[i];
        break;
      }
    }
    return manager;
  }

  List<String> getMacsFromRooms(List<String> groupIds) {
    List<String> deviceMacs = [];
    for (int i = 0; i < groupIds.length; i++) {
      for (int j = 0; j < ApiSingelton().getModeldeviceGroup.length; j++) {
        ModelDeviceGroup group = ApiSingelton().getModeldeviceGroup[j];
        if (group.groupId == groupIds[i]) {
          deviceMacs.add(group.deviceMac);
        }
      }
    }
    return deviceMacs;
  }

  List<ModelDeviceProfile> getSpecificProfilesOfARoom(
      {required String groupId, required String profileId}) {
    List<ModelDeviceProfile> determinedProfile = [];
    List<ModelDeviceManagament> devics = getDevicesByGroupId(groupId: groupId);
    for (int i = 0; i < devics.length; i++) {
      determinedProfile.add(
          getDeviceProfileValue(mac: devics[i].deviceMac, profile: profileId));
    }

    return determinedProfile;
  }

  bool roomWithProfile({required String scheduleId, required String groupid}) {
    bool roomWithProfile = false;
    List<ModelScheduleManager> scheduleManagerList =
        apiSingelton.getScheduleById(scheduleId);
    print(scheduleManagerList);
    final String smPublic =
        _getSmPubIdByGroupid(groupId: groupid, scheduleId: scheduleId);
    if (smPublic.isNotEmpty) {
      for (int i = 0; i < scheduleManagerList.length; i++) {
        if (scheduleManagerList[i].entryPublicId == smPublic) {
          roomWithProfile = true;
          break;
        }
      }
    }
    return roomWithProfile;
  }

  bool roomWithScheduledProfile(
      {required String scheduleId, required String groupid}) {
    bool roomWithProfile = false;
    List<ModelScheduleManager> scheduleManagerList =
        apiSingelton.getScheduleById(scheduleId);
    List<ModelScheduleGroup> scheduleManagerGroup =
        apiSingelton.getScheduleGroup;
    if (scheduleManagerGroup.isNotEmpty && scheduleManagerList.isNotEmpty) {
      for (int i = 0; i < scheduleManagerList.length; i++) {
        for (int k = 0; k < scheduleManagerGroup.length; k++) {
          if (scheduleManagerGroup[k].scheduleManagerPublicId ==
                  scheduleManagerList[i].entryPublicId &&
              scheduleManagerGroup[k].groupId == groupid) {
            roomWithProfile = true;
            break;
          }
        }
      }
    }
    return roomWithProfile;
  }

  String _getSmPubIdByGroupid(
      {required String groupId, required String scheduleId}) {
    String smPublicId = '';
    var list1 = ApiSingelton().getScheduleGroup;
    for (int i = 0; i < list1.length; i++) {
      List<ModelScheduleManager> scheduleManagerList =
          apiSingelton.getScheduleById(scheduleId);
      if (ApiSingelton().getScheduleGroup[i].groupId == groupId) {
        for (int i = 0; i < scheduleManagerList.length; i++) {}
        smPublicId = ApiSingelton().getScheduleGroup[i].scheduleManagerPublicId;
        break;
      }
    }

    return smPublicId;
  }

  String getOffsetprfoile(String mac) {
    var room = ApiSingeltonHelper()
        .getDeviceProfileValue(mac: mac, profile: ThermostatInterface.offset);
    String value = "0.0";
    if (room.profileValue.isNotEmpty && room.profileValue != "#") {
      value = OffsetMapping().getOffsetReverseHashValue(room.profileValue);
    }
    DatabaseSync();
    return value;
  }

  double getOffsetUIprfoile(String mac) {
    var room = ApiSingeltonHelper()
        .getDeviceProfileValue(mac: mac, profile: ThermostatInterface.offset);
    int value = 0;
    if (room.profileValue.isNotEmpty && room.profileValue != "#") {
      value = OffsetMapping().getOffsetReverseUIValue(room.profileValue);
    }
    DatabaseSync();
    return (value + 0.0);
  }
}
