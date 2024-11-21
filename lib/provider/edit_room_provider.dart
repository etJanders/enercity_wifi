import 'package:flutter/material.dart';
import 'package:wifi_smart_living/models/database/model_group_management.dart';

///Description
///the name and the image of stored rooms can be changed. This notifie helps to
///manage editing a room name and an image
///
///Author: J. Anders
///created: 01-02-2023
///changed: 01-02-2023
///
///History:
///
///Notes:
///
class EditRoomProvider with ChangeNotifier {
  late ModelGroupManagement _groupManagement;
  //current room information to detect changes
  late ModelGroupManagement _tempManagement;
  //true if an image or room name is changed
  late bool _dataChanged;
  late bool _nameChanged;

  void initEditRoomProvider({required ModelGroupManagement management}) {
    _groupManagement = management;
    _tempManagement = management;
    _dataChanged = false;
    _nameChanged = false;
  }

  void changeRoomName(String roomName) {
    if (_tempManagement.groupName == roomName) {
      _dataChanged = false;
      _nameChanged = false;
    } else {
      _groupManagement.groupName = roomName;
      _dataChanged = true;
      _nameChanged = true;
    }
    notifyListeners();
  }

  void changeImage(String newImageName) {
    if (_tempManagement.groupImage == newImageName) {
      _dataChanged = false;
    } else {
      _dataChanged = true;
      _groupManagement.groupImage = newImageName;
    }
    notifyListeners();
  }

  ModelGroupManagement get getGroupManagement => _groupManagement;
  bool get getDataChanged => _dataChanged;
  bool get getNameChanged => _nameChanged;
}
