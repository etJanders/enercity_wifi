import 'package:wifi_smart_living/const/const_json_identifier.dart';
import 'package:wifi_smart_living/core/map_helper/map_builder.dart';
import 'package:wifi_smart_living/models/database/datenbank_models.dart';

///Description
///Define all Attributes are userd for device management
///
///Author: J. Anders
///created: 30-11-2022
///changed: 30-11-2022
///
///History:
///
///Notes:
///
class ModelDeviceManagament extends DatabaseModel {
  final String deviceMac;
  String deviceName;
  final String deviceTypeId;
  final String ssidName;

  ModelDeviceManagament(
      {required super.entryPublicId,
      required this.deviceMac,
      required this.deviceName,
      required this.deviceTypeId,
      required this.ssidName});

  factory ModelDeviceManagament.fromJson(Map<String, dynamic> rawData) {
    return ModelDeviceManagament(
        entryPublicId:
            rawData[ConstJsonIdentifier.identifierDevicemanagementPublicId],
        deviceMac: rawData[ConstJsonIdentifier.identifierDeviceMacAdress],
        deviceName: rawData[ConstJsonIdentifier.identifierDeviceName],
        deviceTypeId: rawData[ConstJsonIdentifier.identifierDeviceTypeId],
        ssidName: rawData[ConstJsonIdentifier.identifierSsid]);
  }

  @override
  Map<String, dynamic> toJson() {
    MapBuilder mapBuilder = MapBuilder();
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierDevicemanagementPublicId,
        value: entryPublicId);
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierDeviceMacAdress, value: deviceMac);
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierDeviceName, value: deviceName);
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierDeviceTypeId, value: deviceTypeId);
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierSsid, value: ssidName);
    return mapBuilder.getDynamicMap;
  }
}
