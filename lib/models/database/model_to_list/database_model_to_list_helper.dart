import 'package:wifi_smart_living/const/const_json_identifier.dart';
import 'package:wifi_smart_living/core/map_helper/map_builder.dart';
import '../datenbank_models.dart';

class ModelToListHelper {
  ///create a device profile list to update device profiles
  Map<String, dynamic> deviceprofileToList(
      {required List<DatabaseModel> deviceProfiles}) {
    MapBuilder mapBuilder = MapBuilder();
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.jsonIdentifierDevieProfileList,
        value: deviceProfiles);
    return mapBuilder.getDynamicMap;
  }
}
