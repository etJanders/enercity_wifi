import 'package:wifi_smart_living/const/const_schedule_id.dart';
import 'package:wifi_smart_living/models/database/model_database_user.dart';
import 'package:wifi_smart_living/models/database/model_device_group.dart';
import 'package:wifi_smart_living/models/database/model_device_manaagement.dart';
import 'package:wifi_smart_living/models/database/model_device_profile.dart';
import 'package:wifi_smart_living/models/database/model_group.dart';
import 'package:wifi_smart_living/models/database/model_group_management.dart';
import 'package:wifi_smart_living/models/database/model_room_profile.dart';
import 'package:wifi_smart_living/models/database/model_schedule_group.dart';
import 'package:wifi_smart_living/models/database/model_schedule_manager.dart';
import 'package:wifi_smart_living/models/database/model_user_schedule.dart';

import '../models/accessToken/model_access_token.dart';

///Description
///Singelton: Hold all entries a determined from database
///
///Author: J. Anders
///created: 02-12-2022
///changed: 13-02-2023
///
///History:
///13-02-2023 clear arrays first, bevore adding new elements, use
///           addAll instad of = to add values to the arrays
///
///Notes:
///
class ApiSingelton {
  //Singelton Paddern
  static final ApiSingelton _singelton = ApiSingelton._internal();
  ApiSingelton._internal();

  //Database Models
  late ModelAccessToken _modelAccessToken;
  late ModelDatabaseUser _databaseUserModel;
  late final List<ModelDeviceGroup> _modelDeviceGroup = [];
  late final List<ModelDeviceManagament> _modelDeviceManagment = [];
  late final List<ModelDeviceProfile> _modelDeviceProfile = [];
  late final List<ModelGroupManagement> _modelGroupManagament = [];
  late List<ModelRoomProfile> _modelGroupProfile = [];
  late final List<ModelScheduleGroup> _modelScheduleGroup = [];
  late final List<ModelScheduleManager> _modelScheduleManager = [];
  late final List<ModelUserSchedule> _modelUserSchedule = [];
  late final List<ModelGroup> _modelUserGroup = [];
  late String _modelPopUpMessae = "";
  late String _modelTitle = "";
  late String _modelPopUpMessageDe = "";
  late String _modelTitleDe = "";
  late int _modelInstallStatusWithDevice = 3;
  late int _modelInstallStatusWithoutDevice = 1;
  factory ApiSingelton() {
    return _singelton;
  }

  void deleteSingeltonData() {
    _modelAccessToken = ModelAccessToken(
        tokenString: "",
        tokenDescription: "",
        serviceToken: true,
        tokenCreatedTime: 0);
    _databaseUserModel = ModelDatabaseUser(
        entryPublicId: "",
        userMailAdress: "",
        userPassowrd: "",
        mqttUserName: "",
        mqttUserPassword: "",
        updateMail: false,
        betaUser: false,
        notification: false,
        broker: "",
        isMultiUser: true,
        usedClient: <String, bool>{});
    _modelDeviceGroup.clear();
    _modelDeviceManagment.clear();
    _modelDeviceProfile.clear();
    _modelGroupManagament.clear();
    _modelGroupProfile.clear();
    _modelScheduleGroup.clear();
    _modelScheduleManager.clear();
    _modelUserSchedule.clear();
    _modelUserGroup.clear();
  }

  //Setter
  void initModelAccessToken({required ModelAccessToken token}) {
    _modelAccessToken = token;
  }

  void initModeldatabaseUser({required ModelDatabaseUser user}) {
    _databaseUserModel = user;
  }

  void initModelDeviceGroup({required List<ModelDeviceGroup> deviceGroupList}) {
    _modelDeviceGroup.clear();
    _modelDeviceGroup.addAll(deviceGroupList);
  }

  void initModelDeviceManagement(
      {required List<ModelDeviceManagament> deviceMangement}) {
    _modelDeviceManagment.clear();
    _modelDeviceManagment.addAll(deviceMangement);
  }

  void initModelDeviceProfile(
      {required List<ModelDeviceProfile> deviceProfiles}) {
    _modelDeviceProfile.clear();
    _modelDeviceProfile.addAll(deviceProfiles);
  }

  void initModelGroupManagement(
      {required List<ModelGroupManagement> modelGroupManagemtn}) {
    _modelGroupManagament.clear();
    _modelGroupManagament.addAll(modelGroupManagemtn);
  }

  void initModelGroupProfile({required List<ModelRoomProfile> groupProfile}) {
    _modelGroupProfile.clear();
    _modelGroupProfile.addAll(groupProfile);
    _modelGroupProfile = groupProfile;
  }

  void initModelScheduleGroup(
      {required List<ModelScheduleGroup> scheduleGroup}) {
    _modelScheduleGroup.clear();
    _modelScheduleGroup.addAll(scheduleGroup);
  }

  void initScheduleManager(
      {required List<ModelScheduleManager> scheduleManger}) {
    _modelScheduleManager.clear();
    _modelScheduleManager.addAll(scheduleManger);
    _modelScheduleManager.sort(((a, b) {
      return a.scheduleName
          .toLowerCase()
          .compareTo(b.scheduleName.toLowerCase());
    }));
  }

  void initScheduleUser({required List<ModelUserSchedule> scheduleUser}) {
    _modelUserSchedule.clear();
    _modelUserSchedule.addAll(scheduleUser);
  }

  void initUserGroup({required List<ModelGroup> userGroup}) {
    _modelUserGroup.clear();
    _modelUserGroup.addAll(userGroup);
  }

  void initPopUpMessage(
      {required String message,
      required String title,
      required String messageDe,
      required String titleDe}) {
    _modelPopUpMessae = message;
    _modelTitle = title;
    _modelPopUpMessageDe = messageDe;
    _modelTitleDe = titleDe;
  }

  void init() {}

  void initInstallStatus(
      {required int withDeviceIndex, required int withoutDeviceIndex}) {
    _modelInstallStatusWithDevice = withDeviceIndex;
    _modelInstallStatusWithoutDevice = withoutDeviceIndex;
  }

  List<ModelScheduleManager> getScheduleById(String id) {
    List<ModelScheduleManager> output = [];
    if (id == ConstScheduleId.timeScheduleProfileId ||
        id == ConstScheduleId.holidayProfileScheduleId) {
      for (int i = 0; i < _modelScheduleManager.length; i++) {
        if (_modelScheduleManager[i].scheduleId == id) {
          output.add(_modelScheduleManager[i]);
        }
      }
    }
    return output;
  }

  //Getter
  ModelAccessToken get getModelAccessToken => _modelAccessToken;
  ModelDatabaseUser get getDatabaseUserModel => _databaseUserModel;
  List<ModelDeviceGroup> get getModeldeviceGroup => _modelDeviceGroup;
  List<ModelDeviceManagament> get getModelDeviceManagement =>
      _modelDeviceManagment;
  List<ModelDeviceProfile> get getModelDeviceProfileList => _modelDeviceProfile;
  List<ModelGroupManagement> get getModelGroupManagement =>
      _modelGroupManagament;
  List<ModelRoomProfile> get getModelGroupProfile => _modelGroupProfile;
  List<ModelScheduleGroup> get getScheduleGroup => _modelScheduleGroup;
  List<ModelUserSchedule> get getUserSchedule => _modelUserSchedule;
  List<ModelGroup> get getUserGroup => _modelUserGroup;
  String get getMessage => _modelPopUpMessae;
  String get getTitle => _modelTitle;
  String get getMessageGerman => _modelPopUpMessageDe;
  String get getTitleGerman => _modelTitleDe;
  int get getWithoutDeviceIndex => _modelInstallStatusWithoutDevice;
  int get getWithDeviceIndex => _modelInstallStatusWithDevice;
}
