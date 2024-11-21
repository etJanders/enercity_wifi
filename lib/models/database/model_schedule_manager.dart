import 'package:wifi_smart_living/const/const_json_identifier.dart';
import 'package:wifi_smart_living/core/map_helper/map_builder.dart';
import 'package:wifi_smart_living/models/database/datenbank_models.dart';

///Description
///Summery of schedule management information
///schedule name => is displayed in ui for representation
///schedule image => is displayed in ui for representation
///schedule id => desrcipe schedule state T means time schedule H means holiday
///
///Author: J. Anders
///created: 30-11-2022
///changed: 17-01-2023
///
///History:
///17-01-2023 add schedule id attribute
///
///Notes:
///
class ModelScheduleManager extends DatabaseModel {
  String scheduleName;
  String scheudleImage;
  final String scheduleId;

  ModelScheduleManager(
      {required super.entryPublicId,
      required this.scheduleName,
      required this.scheudleImage,
      required this.scheduleId});

  factory ModelScheduleManager.fromJson(Map<String, dynamic> rawData) {
    return ModelScheduleManager(
        entryPublicId:
            rawData[ConstJsonIdentifier.identifierScheduleManagerPublicId],
        scheduleName: rawData[ConstJsonIdentifier.identifierScheduleName],
        scheudleImage: rawData[ConstJsonIdentifier.identifierScheduleImage],
        scheduleId: rawData[ConstJsonIdentifier.identifierScheduleId]);
  }

  @override
  Map<String, dynamic> toJson() {
    MapBuilder mapBuilder = MapBuilder();
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierScheduleManagerPublicId,
        value: entryPublicId);
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierScheduleName, value: scheduleName);
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierScheduleImage, value: scheudleImage);
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierScheduleId, value: scheduleId);
    return mapBuilder.getDynamicMap;
  }
}
