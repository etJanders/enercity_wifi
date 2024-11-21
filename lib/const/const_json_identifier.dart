///Description
///Define all Json Identifier are used from API to parse json responses
///
///Author: J. Anders
///created: 29-11-2022
///changed: 29-11-2022
///
///History:
///
///Nodes:
///
abstract class ConstJsonIdentifier {
  //API Messages
  static const String identifierMessage = 'message';
  //Accass-Token-Information
  static const String identifierTokenState = 'token_state';
  static const String identifierXAccassToken = 'x-access-token';
  static const String identifierToken = 'token';
  //User information
  static const String jsonIdentifierUser = 'user';
  static const String identifierUserPublicId = 'user_public_id';
  static const String identifierUserMail = 'mail';
  static const String identifierUserPassword = 'password';
  static const String identifierBeta = 'beta';
  static const String identifierMqttUserName = 'mqtt_username';
  static const String identifierMqttuserPassword = 'mqtt_password';
  static const String identifierNewMail = 'new_mail';
  static const String identifierNotification = 'notification';
  static const String identifierUpdateToken = 'update_token';
  static const String identifierBroker = 'broker';
  static const String identifierMulti = 'multi';
  static const String identifierUsedClient = 'used_client';
  //Groups
  static const String jsonIdentifierGroup = 'groups';
  static const String identifierGroupPublicId = 'group_public_id';
  static const String identifierOwnGroup = 'own_group';
  //Group Managemnt
  static const String jsonIdnetifierGroupManagement = 'group_managements';
  static const String identifierGroupManagamentPublicid = 'gm_public_id';
  static const String identifierGroupId = 'group_id';
  static const String identifierLocation = 'location';
  static const String identifierGroupName = 'group_name';
  static const String identifierGroupImage = 'group_image';
  static const String identifierGroupOwner = 'group_owner';
  static const String identifierUiPosition = 'ui_position';
  //Room Profile
  static const String jsonIdentifierRoomProfiel = 'room_profiles';
  static const String identifierRoomProfilePublicId = 'room_public_id';
  static const String identifierProfileValue = 'profile_value';
  static const String identifierProfileId = 'profile_id';
  static const String identifierDeviceTypeId = 'device_type_id';
  //Device Group
  static const String jsonIdentifierDeviceGroup = 'device_groups';
  static const String identifierDeviceGroupPublicId = 'dg_public_id';
  static const String identifierDeviceMacAdress = 'mac';
  //Device Manager
  static const String jsonIdentifierDeviceManagament = 'device_managements';
  static const String identifierDevicemanagementPublicId = 'dm_public_id';
  static const String identifierDeviceName = 'device_name';
  static const String identifierSsid = 'ssid_name';
  //Device Type
  static const String jsonIdentifierDeviceType = 'device_types';
  static const String identifierDeviceTypePublicid = 'dt_public_id';
  static const String identifierdeviceTypeDescription = 'device_description';
  //Device Profile
  static const String jsonIdentifierDevieProfileList = 'dp_public_ids';
  static const String jsonIdentifierDeviceProfile = 'device_profiles';
  static const String identifierDeviceProfilePublicId = 'dp_public_id';
  //User Schedule
  static const String jsonIdentifierUserSchedule = 'user_schedules';
  static const String identifierUserSchedulePublicId = 'us_public_id';
  static const String identifierOwnSchedule = 'own_schedule';
  //Schedule Manager
  static const String jsonIdetifierScheduleManager = 'schedule_managers';
  static const String identifierScheduleManagerPublicId = 'sm_public_id';
  static const String identifierScheduleName = 'schedule_name';
  static const String identifierScheduleImage = 'schedule_image';
  static const String identifierScheduleId = 'schedule_id';
  //Schedule Group
  static const String jsonIdentifierScheduleGroup = 'schedule_groups';
  static const String identifierScheduleGroupPublicId = 'sg_public_id';
  //MQTT
  static const String jsonIdentifierDeviceStatus = 'status';
  static const String identifierOfflineSinse = 'offline_since';
  //SW Management
  static const String jsonIdentifierSwVersions = 'sw_versions';
  static const String identifierRadioVersion = 'da_ver';
  static const String identifierBaseVersion = 'st_ver';
  static const String identifierWebLinkRtos = 'rtos_link';
  static const String identifierWebLinkSlib = 'slib_link';
  static const String idenifierWebLinkBase = 'st_link';
  //GET All
  static const String identifierAllItems = 'items';
}
