import 'package:wifi_smart_living/const/const_json_identifier.dart';
import 'package:wifi_smart_living/core/map_helper/map_builder.dart';
import 'package:wifi_smart_living/models/database/datenbank_models.dart';

///Description
///Define all Attributes are userd for group managament
///
///Author: J. Anders
///created: 29-11-2022
///changed: 29-11-2022
///
///History:
///
///Notes:
///
class ModelGroupManagement extends DatabaseModel {
  final String groupId;
  final int location;
  String groupName;
  String groupImage;
  final String groupOwner;
  int uiPosition;

  @override
  String toString() {
    return "publicId: $entryPublicId groupId: $groupId location: $location groupName: $groupName groupImage: $groupImage groupOwner: $groupOwner uiposition: $uiPosition";
  }

  ModelGroupManagement(
      {required super.entryPublicId,
      required this.groupId,
      required this.location,
      required this.groupName,
      required this.groupImage,
      required this.groupOwner,
      required this.uiPosition});

  factory ModelGroupManagement.fromJosn(Map<String, dynamic> rawData) {
    return ModelGroupManagement(
        entryPublicId:
            rawData[ConstJsonIdentifier.identifierGroupManagamentPublicid],
        groupId: rawData[ConstJsonIdentifier.identifierGroupId],
        location: rawData[ConstJsonIdentifier.identifierLocation],
        groupName: rawData[ConstJsonIdentifier.identifierGroupName],
        groupImage: rawData[ConstJsonIdentifier.identifierGroupImage],
        groupOwner: rawData[ConstJsonIdentifier.identifierGroupOwner],
        uiPosition: rawData[ConstJsonIdentifier.identifierUiPosition]);
  }

  @override
  Map<String, dynamic> toJson() {
    MapBuilder mapBuilder = MapBuilder();
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierGroupManagamentPublicid,
        value: entryPublicId);
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierGroupId, value: groupId);
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierLocation, value: location);
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierGroupName, value: groupName);
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierGroupImage, value: groupImage);
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierGroupOwner, value: groupOwner);
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierUiPosition, value: uiPosition);
    return mapBuilder.getDynamicMap;
  }
}
