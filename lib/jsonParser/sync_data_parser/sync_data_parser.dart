import 'dart:convert';

import 'package:wifi_smart_living/const/const_json_identifier.dart';
import 'package:wifi_smart_living/models/database/model_device_group.dart';
import 'package:wifi_smart_living/models/database/model_device_manaagement.dart';
import 'package:wifi_smart_living/models/database/model_device_profile.dart';
import 'package:wifi_smart_living/models/database/model_group_management.dart';
import 'package:wifi_smart_living/models/database/model_room_profile.dart';
import 'package:wifi_smart_living/models/database/model_schedule_group.dart';
import 'package:wifi_smart_living/models/database/model_schedule_manager.dart';
import 'package:wifi_smart_living/models/database/model_user_schedule.dart';
import 'package:wifi_smart_living/singelton/api_singelton.dart';

import '../../models/database/model_group.dart';

///Description
///Parser for get all database data
///
///Author: J. Anders
///created: 13-12-2022
///changed: 13-12-2022
///
///History:
///
///Notes:
///
class SyncDataParser {
  ApiSingelton apiSingelton = ApiSingelton();

  static const _responseIdGroup = 0;
  static const _responseIdDeviceGroup = 1;
  static const _responseIdRoomProfile = 2;
  static const _responseIdGroupManagement = 3;
  static const _responseIdScheduleGroups = 4;
  static const _responseIdUserSchedules = 5;
  static const _responseIdScheduleManager = 6;
  static const _responseIdDeviceProfiles = 7;
  static const _responseIdDeviceManagements = 8;

  Future<SyncState> parseData({required String responseBody}) async {
    SyncState dataParsed = SyncState.parserError;
    if (responseBody.isNotEmpty) {
      final parsedJson = jsonDecode(responseBody);
      _initGroup(data: parsedJson);
      _initDeviceGroups(data: parsedJson);
      _initRoomProfile(data: parsedJson);
      _initGroupManagement(data: parsedJson);
      _initScheduleGroups(data: parsedJson);
      _initUserSchedule(data: parsedJson);
      _initScheduleManager(data: parsedJson);
      _initDeviceProfiles(data: parsedJson);
      _initDeviceManagements(data: parsedJson);

      dataParsed = SyncState.parsingFinished;
    } else {
      dataParsed = SyncState.noDataAvailable;
    }
    return dataParsed;
  }

  void _initGroup({required dynamic data}) {
    var groupList = data[ConstJsonIdentifier.identifierAllItems]
        [_responseIdGroup][ConstJsonIdentifier.jsonIdentifierGroup] as List;
    List<ModelGroup> list =
        groupList.map<ModelGroup>((json) => ModelGroup.fromJson(json)).toList();
    apiSingelton.initUserGroup(userGroup: list);
  }

  void _initDeviceGroups({required dynamic data}) {
    var deviceGroups = data[ConstJsonIdentifier.identifierAllItems]
            [_responseIdDeviceGroup]
        [ConstJsonIdentifier.jsonIdentifierDeviceGroup] as List;
    List<ModelDeviceGroup> list = deviceGroups
        .map<ModelDeviceGroup>((json) => ModelDeviceGroup.fromJson(json))
        .toList();
    apiSingelton.initModelDeviceGroup(deviceGroupList: list);
  }

  void _initRoomProfile({required dynamic data}) {
    var roomProfile = data[ConstJsonIdentifier.identifierAllItems]
            [_responseIdRoomProfile]
        [ConstJsonIdentifier.jsonIdentifierRoomProfiel] as List;
    List<ModelRoomProfile> list = roomProfile
        .map<ModelRoomProfile>((e) => ModelRoomProfile.fromJson(e))
        .toList();
    apiSingelton.initModelGroupProfile(groupProfile: list);
    for (int i = 0; i < list.length; i++) {
      print(
          "room profiles ===== ${list[i].profileId}===== ${list[i].profileValue}===== ${list[i].groupId}");
    }
  }

  void _initGroupManagement({required dynamic data}) {
    var groupManagement = data[ConstJsonIdentifier.identifierAllItems]
            [_responseIdGroupManagement]
        [ConstJsonIdentifier.jsonIdnetifierGroupManagement] as List;
    List<ModelGroupManagement> list = groupManagement
        .map<ModelGroupManagement>(
            (json) => ModelGroupManagement.fromJosn(json))
        .toList();
    apiSingelton.initModelGroupManagement(modelGroupManagemtn: list);
    for (int i = 0; i < list.length; i++) {
      print(
          "room profiles ===== ${list[i].groupId}===== ${list[i].groupName}===== ${list[i].groupImage}");
    }
  }

  void _initScheduleGroups({required dynamic data}) {
    var scheduleGroups = data[ConstJsonIdentifier.identifierAllItems]
            [_responseIdScheduleGroups]
        [ConstJsonIdentifier.jsonIdentifierScheduleGroup] as List;
    List<ModelScheduleGroup> list = scheduleGroups
        .map<ModelScheduleGroup>((e) => ModelScheduleGroup.fromJson(e))
        .toList();
    apiSingelton.initModelScheduleGroup(scheduleGroup: list);
    for (int i = 0; i < list.length; i++) {
      print(
          "schedule grps ===== ${list[i].groupId}===== ${list[i].scheduleManagerPublicId}");
    }
  }

  void _initUserSchedule({required dynamic data}) {
    var userSchedules = data[ConstJsonIdentifier.identifierAllItems]
            [_responseIdUserSchedules]
        [ConstJsonIdentifier.jsonIdentifierUserSchedule] as List;
    List<ModelUserSchedule> list = userSchedules
        .map<ModelUserSchedule>((e) => ModelUserSchedule.fromJson(e))
        .toList();
    apiSingelton.initScheduleUser(scheduleUser: list);
  }

  void _initScheduleManager({required dynamic data}) {
    var scheduleManager = data[ConstJsonIdentifier.identifierAllItems]
            [_responseIdScheduleManager]
        [ConstJsonIdentifier.jsonIdetifierScheduleManager] as List;
    List<ModelScheduleManager> list = scheduleManager
        .map<ModelScheduleManager>((e) => ModelScheduleManager.fromJson(e))
        .toList();
    apiSingelton.initScheduleManager(scheduleManger: list);
    for (int i = 0; i < list.length; i++) {
      print(
          "schedule manager ===== ${list[i].scheduleId}===== ${list[i].scheduleName}=== ${list[i].scheudleImage}");
    }
  }

  void _initDeviceProfiles({required dynamic data}) {
    var deviceProfile = data[ConstJsonIdentifier.identifierAllItems]
            [_responseIdDeviceProfiles]
        [ConstJsonIdentifier.jsonIdentifierDeviceProfile] as List;
    List<ModelDeviceProfile> list = deviceProfile
        .map<ModelDeviceProfile>((e) => ModelDeviceProfile.fromJson(e))
        .toList();
    apiSingelton.initModelDeviceProfile(deviceProfiles: list);
  }

  void _initDeviceManagements({required dynamic data}) {
    var deviceManager = data[ConstJsonIdentifier.identifierAllItems]
            [_responseIdDeviceManagements]
        [ConstJsonIdentifier.jsonIdentifierDeviceManagament] as List;
    List<ModelDeviceManagament> list = deviceManager
        .map<ModelDeviceManagament>((e) => ModelDeviceManagament.fromJson(e))
        .toList();
    apiSingelton.initModelDeviceManagement(deviceMangement: list);
  }
}

enum SyncState { noDataAvailable, parsingFinished, parserError }
