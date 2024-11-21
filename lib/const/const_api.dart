///Description
///Define all API Functions are supported from the app
///
///Author: J. Anders
///created: 29-11-2022
///changed: 01-02-2023
///
///History:
///17-01-2023 new function: add_activation_state
///01-02-2023 add new function createScheduleGroupByList and change login urls
///Notes:
///
abstract class ConstApi {
  //Base Urls,
  //static const String defaultUrl = 'https://accounts-kubernetes.eurotronic.io/';
  //static const String secondUrl = 'https://accounts-kubernetes.eurotronic.io/';

  static const String defaultUrl = 'https://accounts-v5.eurotronic.io/';
  static const String secondUrl = 'https://accounts1.eurotronic.io/';

  //Login Data for service user
  static const String serviceUserName = 'app-service';
  static const String serviceUserPassword = 'YVXUPxCeq2rktyQY';

  //account interaction
  static const String loginAndroidFlutterGet = 'login_flutter_android';
  static const String loginIosFlutterGet = 'login_flutter_ios';

  static const String pingGet = 'ping';
  static const String createNewUserPost = 'create_user';
  static const String activateNewUserPost = 'activate_user';
  static const String validateUserMail = 'validate_mail';
  static const String passwordReset = 'password_reset';
  static const String refreshActivationToken = 'refresh_activation_token';
  static const String getActivationstatePost = 'get_activation_state';
  //User Options
  static const String getSelfGet = 'get_self';
  static const String updateSelfPut = 'update_self';
  static const String deleteUserDel = 'delete_self';
  //Group
  static const String getAllGroupsGet = 'get_all_groups';
  static const String deleteGroups = 'delete_group';
  //Group Management
  static const String getAllGroupManagementsGet = 'get_all_group_managements';
  static const String updateGroupManagementPut = 'update_group_management';
  static const String deleteGroupManagementDel = 'delete_group_management';
  //RoomProfile
  static const String createRoomProfilePost = 'create_room_profile';
  static const String getAllRoomProfileGet = 'get_all_room_profiles';
  static const String updateRoomProfilePut = 'update_room_profile';
  static const String deleteRoomProfileDel = 'delete_room_profile';
  //DeviceGroup
  static const String getAllDeviceGroupsGet = 'get_all_device_groups';
  static const String updateAllDeviceGroupsPut = 'update_device_group';
  static const String deleteDeviceGroupDel = 'delete_device_group';
  //DeviceManagement
  static const String getDeviceManagementGet = 'get_all_device_managements';
  static const String updateDeviceManagementPut = 'update_device_management';
  static const String deleteDeviceManagementDel = 'delete_device_management';
  //DeviceType
  static const String getAllDeviceTypsGet = 'get_all_device_types';
  //Device Profile
  static const String createDeviceProfilePost = 'create_device_profile';
  static const String getAllDeviceProfilesGet = 'get_all_device_profiles';
  static const String updateDeviceProfilesPut = 'update_device_profile';
  static const String updateDeviceProfileByListPut =
      'update_device_profile_by_list';
  static const String deleteDeviceProfileDel = 'delete_device_profile';
  //UserSchedule
  static const String getAllUserSchedulesGet = 'get_all_user_schedules';
  static const String deleteUserScheduleDel = 'delete_user_schedule';
  //ScheduleManager
  static const String getAllSchedulemanagerGet = 'get_all_schedule_managers';
  static const String updateAllScheduleManagerPut = 'update_schedule_manager';
  static const String deleteScheduleManagerDel = 'delete_schedule_manager';
  //ScheduleGroup
  static const String createScheduleGroupPost = 'create_schedule_group';
  static const String createScheduleGroupByList =
      'create_schedule_group_by_list';
  static const String getAllScheduleGroupGet = 'get_all_schedule_groups';
  static const String deleteScheduleGroup = 'delete_schedule_group';
  //MQTT
  static const String getSingleDeviceStatePost = 'device_status';
  static const String getAllDeviceStatesGet = 'device_status_all';
  //Cleanup
  static const String deleteRoomDel = 'delete_room';
  static const String deleteDeviceDel = 'delete_device';
  static const String deleteScheduleDel = 'delete_schedule';
  //SW Managment
  static const String getSoftwareInformationGet = 'get_sw_all';
  //Combo Functions
  static const String getAllEntriesByLocationPost =
      'get_all_entries_by_location';
  static const String createRoomWithDevicePost = 'create_basics';
  static const String createNewScheduleDataPost = 'create_schedule';
  static const String addDeviceToRoomPost = 'add_device_to_room';
  //App Control
  static const String getCurrentAppVersion = 'get_current_app_version';
  static const String getAppVersionByOs = 'get_current_app_version_by_os';
  static const String checkPopup = "check_popup";
  static const String checkUserSpecificPopup = "check_user_popup";
  //Parsing
  static const getSeparator = "separator";
  //used client
  static const currentAppCode = 'EC';
}
