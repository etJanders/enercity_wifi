import 'package:wifi_smart_living/const/const_json_identifier.dart';
import 'package:wifi_smart_living/core/map_helper/map_builder.dart';
import 'package:wifi_smart_living/models/database/datenbank_models.dart';

///Description
///Define all Attributes are userd for device profile
///
///Author: J. Anders
///created: 30-11-2022
///changed: 30-11-2022
///
///History:
///
///Notes:
///
class ModelDeviceProfile extends DatabaseModel {
  final String macAdress;
  final String profileId;
  String profileValue;

  ModelDeviceProfile(
      {required super.entryPublicId,
      required this.macAdress,
      required this.profileId,
      required this.profileValue});

  factory ModelDeviceProfile.fromJson(Map<String, dynamic> rawData) {
    return ModelDeviceProfile(
        entryPublicId:
            rawData[ConstJsonIdentifier.identifierDeviceProfilePublicId],
        macAdress: rawData[ConstJsonIdentifier.identifierDeviceMacAdress],
        profileId: rawData[ConstJsonIdentifier.identifierProfileId],
        profileValue: rawData[ConstJsonIdentifier.identifierProfileValue]);
  }

  @override
  Map<String, dynamic> toJson() {
    MapBuilder mapBuilder = MapBuilder();
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierDeviceProfilePublicId,
        value: entryPublicId);
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierDeviceMacAdress, value: macAdress);
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierProfileId, value: profileId);
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierProfileValue, value: profileValue);
    return mapBuilder.getDynamicMap;
  }

  @override
  Map<String, dynamic> toDeleteFunctionJson() {
    MapBuilder mapBuilder = MapBuilder();
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierDeviceProfilePublicId,
        value: entryPublicId);
    return mapBuilder.getDynamicMap;
  }
}
