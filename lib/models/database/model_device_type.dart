import 'package:wifi_smart_living/const/const_json_identifier.dart';
import 'package:wifi_smart_living/core/map_helper/map_builder.dart';
import 'package:wifi_smart_living/models/database/datenbank_models.dart';

///Description
///Define all Attributes are userd for device definition
///
///Author: J. Anders
///created: 30-11-2022
///changed: 30-11-2022
///
///History:
///
///Notes:
///
class ModelDeviceType extends DatabaseModel {
  final String devicetypeId;
  final String deviceDescription;

  ModelDeviceType(
      {required super.entryPublicId,
      required this.devicetypeId,
      required this.deviceDescription});

  factory ModelDeviceType.fromJson(Map<String, dynamic> rawData) {
    return ModelDeviceType(
        entryPublicId:
            rawData[ConstJsonIdentifier.identifierDeviceTypePublicid],
        devicetypeId: rawData[ConstJsonIdentifier.identifierDeviceTypeId],
        deviceDescription:
            rawData[ConstJsonIdentifier.identifierdeviceTypeDescription]);
  }

  @override
  Map<String, dynamic> toJson() {
    MapBuilder mapBuilder = MapBuilder();
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierDeviceTypePublicid,
        value: entryPublicId);
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierDeviceTypeId, value: devicetypeId);
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierdeviceTypeDescription,
        value: deviceDescription);
    return mapBuilder.getDynamicMap;
  }
}
