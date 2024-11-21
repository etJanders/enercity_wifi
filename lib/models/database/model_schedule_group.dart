import 'package:wifi_smart_living/const/const_json_identifier.dart';
import 'package:wifi_smart_living/core/map_helper/map_builder.dart';
import 'package:wifi_smart_living/models/database/datenbank_models.dart';

class ModelScheduleGroup extends DatabaseModel {
  final String scheduleManagerPublicId;
  final String groupId;

  ModelScheduleGroup(
      {required super.entryPublicId,
      required this.scheduleManagerPublicId,
      required this.groupId});

  factory ModelScheduleGroup.fromJson(Map<String, dynamic> rawData) {
    return ModelScheduleGroup(
        entryPublicId:
            rawData[ConstJsonIdentifier.identifierScheduleGroupPublicId],
        scheduleManagerPublicId:
            rawData[ConstJsonIdentifier.identifierScheduleManagerPublicId],
        groupId: rawData[ConstJsonIdentifier.identifierGroupId]);
  }

  @override
  Map<String, dynamic> toJson() {
    MapBuilder mapBuilder = MapBuilder();
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierScheduleGroupPublicId,
        value: entryPublicId);
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierScheduleManagerPublicId,
        value: scheduleManagerPublicId);
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierGroupId, value: groupId);
    return mapBuilder.getDynamicMap;
  }
}
