import 'package:wifi_smart_living/const/const_json_identifier.dart';
import 'package:wifi_smart_living/const/const_schedule_id.dart';

import '../../core/map_helper/map_builder.dart';

///Description
///Hold attributes are used to create a new time schedule in database
///
///Author: J. Anders
///created: 09-01-2023
///changed: 09-01-2023
///
///History:
///
///Notes:
///
class CreateHeatingProfileHelper {
  late List<String> _groupIds;
  late String _scheduleName;
  late String _scheduleImage;

  CreateHeatingProfileHelper() {
    _groupIds = [];
  }

  void setScheduleName({required String scheduleName}) {
    _scheduleName = scheduleName;
  }

  void setScheduleImage({required String scheduleImageName}) {
    _scheduleImage = scheduleImageName;
  }

  void addRoomsToSchedule(List<String> rooms) {
    _groupIds = rooms;
  }

  Map<String, dynamic> toJson() {
    MapBuilder mapBuilder = MapBuilder();
    mapBuilder.addDynamicMapEntry(key: 'group_ids', value: _groupIds);
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierScheduleName, value: _scheduleName);
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierScheduleImage,
        value: _scheduleImage);
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierScheduleId,
        value: ConstScheduleId.timeScheduleProfileId);
    return mapBuilder.getDynamicMap;
  }

  Map<String, dynamic> toHolidayJson() {
    MapBuilder mapBuilder = MapBuilder();
    mapBuilder.addDynamicMapEntry(key: 'group_ids', value: _groupIds);
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierScheduleName, value: _scheduleName);
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierScheduleImage,
        value: _scheduleImage);
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierScheduleId,
        value: ConstScheduleId.holidayProfileScheduleId);
    return mapBuilder.getDynamicMap;
  }

  List<String> get getScheduleGroups => _groupIds;
  String get getScheduleName => _scheduleName;
  String get getScheduleImage => _scheduleImage;
}
