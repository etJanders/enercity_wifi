import 'package:wifi_smart_living/core/image_mapping/image_name_mapping.dart';

class SelectImageMapping {
  final List<String> supportedImageNames = [];
  final List<ImageMappingHelper> roomIconImageMapping = [];

  SelectImageMapping() {
    _initLists();
  }

  void _initLists() {
    supportedImageNames.add('room_icon_stairs_enabled_flutter.png');
    roomIconImageMapping.add(ImageMappingHelper(
        enabledImageName: 'room_icon_stairs_enabled_flutter.png',
        disabledImageName: 'room_icon_stairs_disabled_flutter.png'));
    supportedImageNames.add('room_icon_bedroom_enabled_flutter.png');
    roomIconImageMapping.add(ImageMappingHelper(
        enabledImageName: 'room_icon_bedroom_enabled_flutter.png',
        disabledImageName: 'room_icon_bedroom_disabled_flutter.png'));

    supportedImageNames.add('room_icon_bathroom_enabled_flutter.png');
    roomIconImageMapping.add(ImageMappingHelper(
        enabledImageName: 'room_icon_bathroom_enabled_flutter.png',
        disabledImageName: 'room_icon_bathroom_disabled_flutter.png'));

    supportedImageNames.add('room_icon_child_room_enabled_flutter.png');
    roomIconImageMapping.add(ImageMappingHelper(
        enabledImageName: 'room_icon_child_room_enabled_flutter.png',
        disabledImageName: 'room_icon_child_room_disabled_flutter.png'));

    supportedImageNames.add('room_icon_office_enabled_flutter.png');
    roomIconImageMapping.add(ImageMappingHelper(
        enabledImageName: 'room_icon_office_enabled_flutter.png',
        disabledImageName: 'room_icon_office_disabled_flutter.png'));

    supportedImageNames.add('room_icon_dining_room_disabled_flutter.png');
    roomIconImageMapping.add(ImageMappingHelper(
        enabledImageName: 'room_icon_dining_room_disabled_flutter.png',
        disabledImageName: 'room_icon_dining_room_enabled_flutter.png'));

    supportedImageNames.add('room_icon_kitchen_disabled_flutter.png');
    roomIconImageMapping.add(ImageMappingHelper(
        enabledImageName: 'room_icon_kitchen_disabled_flutter.png',
        disabledImageName: 'room_icon_kitchen_enabled_flutter.png'));

    supportedImageNames.add('room_icons_living_room_enabled_flutter.png');
    roomIconImageMapping.add(ImageMappingHelper(
        enabledImageName: 'room_icons_living_room_enabled_flutter.png',
        disabledImageName: 'room_icons_living_room_disabled_flutter.png'));
  }

  ImageMappingHelper getImageMappingObject({required String imageName}) {
    return roomIconImageMapping[_getImageIndex(
        ImageMapping().getImageNameToShow(imageName: imageName))];
  }

  int _getImageIndex(String imageName) {
    int index = 0;
    for (int i = 0; i < supportedImageNames.length; i++) {
      if (supportedImageNames[i] == imageName) {
        index = i;
        break;
      }
    }
    return index;
  }
}

class ImageMappingHelper {
  final String enabledImageName;
  final String disabledImageName;
  ImageMappingHelper(
      {required this.enabledImageName, required this.disabledImageName});
}
