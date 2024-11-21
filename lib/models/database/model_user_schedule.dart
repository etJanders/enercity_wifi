import 'package:wifi_smart_living/const/const_json_identifier.dart';
import 'package:wifi_smart_living/core/map_helper/map_builder.dart';
import 'package:wifi_smart_living/models/database/datenbank_models.dart';

class ModelUserSchedule extends DatabaseModel {
  final String userPublicId;
  final String scheduleManagerPublicId;
  final bool ownSchedule;

  ModelUserSchedule(
      {required super.entryPublicId,
      required this.userPublicId,
      required this.scheduleManagerPublicId,
      required this.ownSchedule});

  factory ModelUserSchedule.fromJson(Map<String, dynamic> rawData) {
    return ModelUserSchedule(
        entryPublicId:
            rawData[ConstJsonIdentifier.identifierUserSchedulePublicId],
        userPublicId: rawData[ConstJsonIdentifier.identifierUserPublicId],
        scheduleManagerPublicId:
            rawData[ConstJsonIdentifier.identifierScheduleManagerPublicId],
        ownSchedule: rawData[ConstJsonIdentifier.identifierOwnSchedule]);
  }

  @override
  Map<String, dynamic> toJson() {
    MapBuilder mapBuilder = MapBuilder();
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierUserSchedulePublicId,
        value: entryPublicId);
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierUserPublicId, value: userPublicId);
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierScheduleManagerPublicId,
        value: scheduleManagerPublicId);

    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierOwnSchedule, value: ownSchedule);
    return mapBuilder.getDynamicMap;
  }
}
