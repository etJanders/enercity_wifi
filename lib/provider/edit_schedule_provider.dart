import 'package:flutter/material.dart';
import 'package:wifi_smart_living/models/database/model_schedule_manager.dart';

class EditScheduleProvider with ChangeNotifier {
  late ModelScheduleManager _scheduleManager;
  late ModelScheduleManager _temp;
  bool _dataChanged = false;

  void initScheduleManager(ModelScheduleManager manager) {
    _scheduleManager = manager;
    _temp = manager;
    _dataChanged = false;
  }

  void changeImage(String imageName) {
    if (_temp.scheudleImage != imageName) {
      _scheduleManager.scheudleImage = imageName;
      _dataChanged = true;
    } else {
      _dataChanged = false;
    }
    notifyListeners();
  }

  void changeScheduleName(String scheduleName) {
    if (_temp.scheduleName != scheduleName.trim()) {
      _scheduleManager.scheduleName = scheduleName;
      _dataChanged = true;
    } else {
      _dataChanged = false;
    }
    notifyListeners();
  }

  ModelScheduleManager get getScheduleManager => _scheduleManager;
  bool get getDataChanged => _dataChanged;
}
