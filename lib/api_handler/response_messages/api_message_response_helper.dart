import 'dart:collection';

///Description
///The api send message reports. This class maps the messages into a unique id
///For workflows it is easier to work with ids.
///
///Author: J. Anders
///created: 31-10-2022
///changed: 31-10-2022
///
///History:
///
///Notes:
class ApiResponses {
  static final Map<String, int> _apiMessages = HashMap<String, int>();

  static const int unknownMessage = -99;

  static const int entrySuccesfullCreated = 10;
  static const int activationTokenSent = 11;
  static const int userSuccessfullActivated = 12;
  static const int databaseEntrySuccesfulUpdated = 13;
  static const int updateMailVerificationTokenSent = 14;
  static const int databaseEntrySuccesfulDeleted = 15;
  static const int passwordResetTokenSent = 16;

  static const int datasbaseNotAvaialable = 100;
  static const int userNotActivated = 101;
  static const int loginRequired = 102;
  static const int mailAlreadyExists = 103;
  static const int tokenNotFromServiceUser = 104;
  static const int userDoseNotExists = 105;
  static const int tokenInvalde = 106;
  static const int userAlreadyActivated = 107;
  static const int mailHasNotCorrectFormat = 108;
  static const int mailAdressInUse = 109;
  static const int newPasswordEqualsOldPassword = 110;
  static const int noPermissionToUpdate = 111;
  static const int noPermissionToDelete = 112;
  static const int databaseEntryNotFound = 113;
  static const int noPermissionToCheckStatus = 114;
  static const int deviceStatusNotAvaialable = 115;
  static const int unknownError = 999;

  ApiResponses() {
    _initHashMap();
  }

  void _initHashMap() {
    //positive messages
    _addNewEntries(key: 'New user created!', value: entrySuccesfullCreated);
    _addNewEntries(key: 'Token has been resent!', value: activationTokenSent);
    _addNewEntries(
        key: 'User has been activated!', value: userSuccessfullActivated);
    _addNewEntries(
        key: 'The user has been updated!',
        value: databaseEntrySuccesfulUpdated);
    //if email should be changed
    _addNewEntries(
        key: 'Mail verification token has been sent!',
        value: updateMailVerificationTokenSent);
    _addNewEntries(
        key: 'The user has been deleted!',
        value: databaseEntrySuccesfulDeleted);
    _addNewEntries(
        key: 'Successfully updated Mail!',
        value: databaseEntrySuccesfulUpdated);
    _addNewEntries(
        key: 'The group has been deleted!',
        value: databaseEntrySuccesfulDeleted);
    _addNewEntries(
        key: 'successfully created all entries!',
        value: entrySuccesfullCreated);
    _addNewEntries(
        key: 'successfully added device to room!',
        value: entrySuccesfullCreated);
    _addNewEntries(
        key: 'The group_management has been updated!',
        value: databaseEntrySuccesfulUpdated);
    _addNewEntries(
        key: 'The room_profile has been updated!',
        value: databaseEntrySuccesfulUpdated);
    _addNewEntries(
        key: 'The room_profile has been deleted!',
        value: databaseEntrySuccesfulDeleted);
    _addNewEntries(
        key: 'Removed all entries!', value: databaseEntrySuccesfulDeleted);
    _addNewEntries(
        key: 'The device_group has been updated!',
        value: databaseEntrySuccesfulUpdated);
    _addNewEntries(
        key: 'The device_group has been deleted!',
        value: databaseEntrySuccesfulDeleted);
    _addNewEntries(
        key: 'The device_management has been updated!',
        value: databaseEntrySuccesfulUpdated);
    _addNewEntries(
        key: 'The device_management has been deleted!',
        value: databaseEntrySuccesfulDeleted);
    _addNewEntries(
        key: 'The device_profile has been updated',
        value: databaseEntrySuccesfulUpdated);
    _addNewEntries(
        key: 'The device_profile has been updated!',
        value: databaseEntrySuccesfulUpdated);
    _addNewEntries(
        key: 'The user_schedule has been deleted!',
        value: databaseEntrySuccesfulDeleted);
    _addNewEntries(
        key: 'The schedule_manager has been updated!',
        value: databaseEntrySuccesfulUpdated);
    _addNewEntries(
        key: 'The schedule_manager has been deleted!',
        value: databaseEntrySuccesfulDeleted);
    _addNewEntries(
        key: 'The schedule_group has been deleted!',
        value: databaseEntrySuccesfulDeleted);

    //negative mesages
    _addNewEntries(key: 'Activation required', value: userNotActivated);
    _addNewEntries(key: 'Login required', value: loginRequired);
    _addNewEntries(key: 'Database Problem!', value: datasbaseNotAvaialable);
    _addNewEntries(key: 'Mail already exists!', value: mailAlreadyExists);
    _addNewEntries(
        key: 'Cannot perform that function!', value: tokenNotFromServiceUser);
    _addNewEntries(key: 'User does not exists!', value: userDoseNotExists);
    _addNewEntries(key: 'Invalid Token!', value: tokenInvalde);
    _addNewEntries(key: 'User already activated!', value: userAlreadyActivated);
    _addNewEntries(key: 'No user found!', value: userDoseNotExists);
    _addNewEntries(key: 'No user fround!', value: userDoseNotExists);

    _addNewEntries(
        key: 'Same Password cant be used twice!',
        value: newPasswordEqualsOldPassword);
    _addNewEntries(key: 'Mail already exists!', value: mailAdressInUse);
    _addNewEntries(key: 'Invalid Email!', value: mailHasNotCorrectFormat);
    _addNewEntries(key: 'Something went wrong!', value: unknownError);
    _addNewEntries(
        key: 'Reset Token has been sent!', value: passwordResetTokenSent);
    _addNewEntries(
        key: 'No permission to update!', value: noPermissionToUpdate);
    _addNewEntries(
        key: 'No group_management found!', value: databaseEntryNotFound);
    _addNewEntries(
        key: 'No permission to delete!', value: noPermissionToDelete);
    _addNewEntries(key: 'No room_profile found!', value: databaseEntryNotFound);
    _addNewEntries(
        key: 'No permission to check status!',
        value: noPermissionToCheckStatus);
    _addNewEntries(
        key: 'No Status available!', value: deviceStatusNotAvaialable);
    _addNewEntries(key: 'No device_group found!', value: databaseEntryNotFound);
    _addNewEntries(
        key: 'No device_management found!', value: databaseEntryNotFound);
    _addNewEntries(
        key: 'No device_profile found!', value: databaseEntryNotFound);
    _addNewEntries(
        key: 'No user_schedule found!', value: databaseEntryNotFound);
    _addNewEntries(
        key: 'No schedule_manager found!', value: databaseEntryNotFound);
    _addNewEntries(
        key: 'No schedule_group found!', value: databaseEntryNotFound);
  }

  ///Add new entries to the repsonse collection
  void _addNewEntries({required String key, required int value}) {
    if (!_apiMessages.containsKey(key)) {
      _apiMessages[key] = value;
    }
  }

  ///Get message code from a api response
  int getMessageCode({required String message}) {
    int messageCode = unknownMessage;
    if (_apiMessages.containsKey(message)) {
      messageCode = _apiMessages[message]!;
    }
    return messageCode;
  }
}
