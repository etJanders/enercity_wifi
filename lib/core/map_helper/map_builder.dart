///Description
///Help to create a Maps with dynamic oder string data values
///
///Author: J. Anders
///created: 29-11-2022
///changed: 29-11-2022
///
///History:
///
///Notes:
///
class MapBuilder {
  final Map<String, String> _stringMap = {};
  final Map<String, dynamic> _dynamicMap = {};

  void addStingMapEntry({required String key, required String value}) {
    if (!_stringMap.containsKey(key)) {
      _stringMap[key] = value;
    }
  }

  void addDynamicMapEntry({required String key, required dynamic value}) {
    _dynamicMap[key] = value;
  }

  Map<String, String> get getStringMap => _stringMap;
  Map<String, dynamic> get getDynamicMap => _dynamicMap;
}
