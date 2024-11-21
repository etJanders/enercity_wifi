import 'package:wifi_smart_living/const/const_json_identifier.dart';
import 'package:wifi_smart_living/core/map_helper/map_builder.dart';
import 'package:wifi_smart_living/models/database/datenbank_models.dart';

///Description
///Define all Attributes are userd for room profile
///
///Author: J. Anders
///created: 30-11-2022
///changed: 30-11-2022
///
///History:
///
///Notes:
///todo aufpassen mit der deviceTypeId... nicht das bei Aqua dann auch als default die 0012 genutz wird.
class ModelRoomProfile extends DatabaseModel {
  final String groupId;
  final String profileId;
  String profileValue;
  String? deviceTypeId;

  ModelRoomProfile(
      {required super.entryPublicId,
      required this.groupId,
      required this.profileId,
      required this.profileValue,
      required this.deviceTypeId});

  factory ModelRoomProfile.fromJson(Map<String, dynamic> rawData) {
    return ModelRoomProfile(
        entryPublicId:
            rawData[ConstJsonIdentifier.identifierRoomProfilePublicId],
        groupId: rawData[ConstJsonIdentifier.identifierGroupId],
        profileId: rawData[ConstJsonIdentifier.identifierProfileId],
        profileValue: rawData[ConstJsonIdentifier.identifierProfileValue],
        deviceTypeId:
            rawData[ConstJsonIdentifier.identifierDeviceTypeId] ?? '0012');
  }

  @override
  Map<String, dynamic> toJson() {
    MapBuilder mapBuilder = MapBuilder();
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierRoomProfilePublicId,
        value: entryPublicId);
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierGroupId, value: groupId);
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierProfileId, value: profileId);
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierProfileValue, value: profileValue);
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierDeviceTypeId,
        value: deviceTypeId ?? '0012');
    return mapBuilder.getDynamicMap;
  }

  Map<String, dynamic> toDeleteFunctionJson() {
    MapBuilder mapBuilder = MapBuilder();
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierRoomProfilePublicId,
        value: entryPublicId);

    return mapBuilder.getDynamicMap;
  }
}
