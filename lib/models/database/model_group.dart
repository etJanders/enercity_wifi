import 'package:wifi_smart_living/const/const_json_identifier.dart';
import 'package:wifi_smart_living/core/map_helper/map_builder.dart';
import 'package:wifi_smart_living/models/database/datenbank_models.dart';

///Description
///Database model which represent the database group entries
///
///Author: J. Anders
///created: 30-11-2022
///changed: 30-11-2022
///
///History:
///
///Nodes:
///
class ModelGroup extends DatabaseModel {
  final String userPublicId;
  final bool ownGroup;

  ModelGroup(
      {required super.entryPublicId,
      required this.userPublicId,
      required this.ownGroup});

  factory ModelGroup.fromJson(Map<String, dynamic> rawData) {
    return ModelGroup(
        entryPublicId: rawData[ConstJsonIdentifier.identifierGroupPublicId],
        userPublicId: rawData[ConstJsonIdentifier.identifierUserPublicId],
        ownGroup: rawData[ConstJsonIdentifier.identifierOwnGroup]);
  }

  @override
  Map<String, dynamic> toJson() {
    MapBuilder mapBuilder = MapBuilder();
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierGroupPublicId, value: entryPublicId);
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierUserPublicId, value: userPublicId);
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierOwnGroup, value: ownGroup);
    return mapBuilder.getDynamicMap;
  }
}
