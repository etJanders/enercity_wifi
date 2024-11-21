import 'package:wifi_smart_living/core/map_helper/map_builder.dart';

///Description
///The Flutter app do not support the Room icons of the old apps. This mapping helps
///to oder old images and help to support the current images
///
///Author: J. Anders
///created: 18-12-2022
///changed:
///
///History:
///
///Notes
class ImageMapping {
  MapBuilder mapBuilder = MapBuilder();

  ImageMapping() {
    _initImageMap();
  }

  String getImageNameToShow({required String imageName}) {
    String image = "room_icon_stairs_enabled_flutter.png";
    if (mapBuilder.getStringMap.containsKey(imageName)) {
      image = mapBuilder.getStringMap[imageName]!;
    }
    return image;
  }

  void _initImageMap() {
    _addEndtries(
        key: 'room_icon_bathroom',
        value: 'room_icon_bathroom_enabled_flutter.png');
    _addEndtries(
        key: 'room_icon_bathroom_enabled_flutter.png',
        value: 'room_icon_bathroom_enabled_flutter.png');

    _addEndtries(
        key: 'room_icon_bedroom',
        value: 'room_icon_bedroom_enabled_flutter.png');
    _addEndtries(
        key: 'room_icon_bedroom_enabled_flutter.png',
        value: 'room_icon_bedroom_enabled_flutter.png');

    _addEndtries(
        key: 'room_icon_child_room',
        value: 'room_icon_child_room_enabled_flutter.png');
    _addEndtries(
        key: 'room_icon_child_room_enabled_flutter.png',
        value: 'room_icon_child_room_enabled_flutter.png');

    _addEndtries(
        key: 'room_icon_dining_room',
        value: 'room_icon_dining_room_enabled_flutter.png');
    _addEndtries(
        key: 'room_icon_dining_room_enabled_flutter.png',
        value: 'room_icon_dining_room_enabled_flutter.png');

    _addEndtries(
        key: 'room_icon_kitchen',
        value: 'room_icon_kitchen_enabled_flutter.png');
    _addEndtries(
        key: 'room_icon_kitchen_enabled_flutter.png',
        value: 'room_icon_kitchen_enabled_flutter.png');

    _addEndtries(
        key: 'room_icon_living_room',
        value: 'room_icon_wohnzimmer_enabled_flutter.png');
    _addEndtries(
        key: 'room_icons_living_room_enabled_flutter.png',
        value: 'room_icons_living_room_enabled_flutter.png');

    _addEndtries(
        key: 'room_icon_office_enabled_flutter.png',
        value: 'room_icon_office_enabled_flutter.png');
    _addEndtries(
        key: 'room_icon_office', value: 'room_icon_office_enabled_flutter.png');

    _addEndtries(
        key: 'room_icon_open_door',
        value: 'room_icon_stairs_enabled_flutter.png');
    _addEndtries(
        key: 'room_icon_stairs_enabled_flutter.png',
        value: 'room_icon_stairs_enabled_flutter.png');
    _addEndtries(
        key: 'room_icon_wohnzimmer_enabled_flutter.png',
        value: 'room_icon_wohnzimmer_enabled_flutter.png');
    _addEndtries(
        key: 'room_icon_kitchen_two_enabled_flutter.png',
        value: 'room_icon_kitchen_two_enabled_flutter.png');
  }

  //Add a new entry to image map
  void _addEndtries({required String key, required String value}) {
    if (!mapBuilder.getStringMap.containsKey(key)) {
      mapBuilder.addStingMapEntry(key: key, value: value);
    }
  }
}
