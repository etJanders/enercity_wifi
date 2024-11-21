import 'package:wifi_smart_living/const/const_json_identifier.dart';
import 'package:wifi_smart_living/core/map_helper/map_builder.dart';
import 'package:wifi_smart_living/models/database/datenbank_models.dart';

///Description
///Define all Attributes are userd for device group
///
///Author: J. Anders
///created: 30-11-2022
///changed: 30-11-2022
///
///History:
///
///Notes:
///
class ModelDeviceGroup extends DatabaseModel {
  final String groupId;
  final String deviceMac;

  ModelDeviceGroup(
      {required super.entryPublicId,
      required this.groupId,
      required this.deviceMac});

  factory ModelDeviceGroup.fromJson(Map<String, dynamic> rawData) {
    return ModelDeviceGroup(
        entryPublicId:
            rawData[ConstJsonIdentifier.identifierDeviceGroupPublicId],
        groupId: rawData[ConstJsonIdentifier.identifierGroupId],
        deviceMac: rawData[ConstJsonIdentifier.identifierDeviceMacAdress]);
  }

  @override
  Map<String, dynamic> toJson() {
    MapBuilder mapBuilder = MapBuilder();
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierDeviceGroupPublicId,
        value: entryPublicId);
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierGroupId, value: groupId);
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierDeviceMacAdress, value: deviceMac);
    return mapBuilder.getDynamicMap;
  }
}
