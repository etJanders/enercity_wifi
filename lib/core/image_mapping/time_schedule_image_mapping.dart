class TimeScheduleImageMaping {
  final Map<String, String> _imageMapping = <String, String>{};
  final Map<String, String> _imageMappingScheduleToRoom = <String, String>{};

  TimeScheduleImageMaping() {
    _initMap();
  }

  void _initMap() {
    _imageMapping['room_icon_bathroom_enabled_flutter.png'] =
        'heating_profile_bathroom_flutter.png';
    _imageMapping['room_icon_bedroom_enabled_flutter.png'] =
        'heating_profile_bedroom_flutter.png';
    _imageMapping['room_icon_child_room_enabled_flutter.png'] =
        'heating_profile_childroom_flutter.png';
    _imageMapping['room_icon_office_enabled_flutter.png'] =
        'heating_profile_office_flutter.png';
    _imageMapping['room_icon_dining_room_enabled_flutter.png'] =
        'heating_profile_dinig_room_flutter.png';
    _imageMapping['room_icon_kitchen_enabled_flutter.png'] =
        'heating_profile_kitchen_flutter.png';
    _imageMapping['room_icons_living_room_enabled_flutter.png'] =
        'hetaing_profiel_living_room_flutter.png';
    _imageMapping['room_icon_stairs_enabled_flutter.png'] =
        'heating_profile_stairs_flutter.png';
    _imageMappingScheduleToRoom['holida_profile_autumn_flutter.png'] =
        'holida_profile_autumn_enabled.png';
    _imageMapping['holida_profile_autumn_enabled.png'] =
        'holida_profile_autumn_flutter.png';
    _imageMapping['holiday_profile_easter_enabled.png'] =
        'holiday_profile_easter_flutter.png';
    _imageMapping['holiday_profile_xmas_enabled.png'] =
        'holiday_profile_xmas_flutter.png';
    _imageMapping['holiday_profile_sailing_enabled.png'] =
        'holiday_profile_sailing_flutter.png';
    _imageMapping['holiday_profile_skiing_enabled.png'] =
        'holiday_profile_skiing_flutter.png';
    _imageMapping['holiday_profile_summer_enabled.png'] =
        'holiday_profile_summer_flutter.png';
    _imageMapping['holiday_profile_summer_two_enabled.png'] =
        'holiday_profile_summer_two_flutter.png';
    _imageMapping['holiday_profile_camping_enabled.png'] =
        'holiday_profile_camping_flutter.png';
    _imageMapping['holiday_profile_xmas_flutter.png'] =
        'holiday_profile_xmas_flutter.png';
    _imageMapping['holiday_profile_tent_enabled.png'] =
        'holiday_profile_tent_flutter.png';
    _imageMapping['holiday_profile_traveling_enabled.png'] =
        'holiday_profile_traveling_flutter.png';
    _imageMappingScheduleToRoom['holiday_profile_easter_flutter.png'] =
        'holiday_profile_easter_enabled.png';
    _imageMappingScheduleToRoom['holiday_profile_xmas_flutter.png'] =
        'holiday_profile_xmas_enabled.png';
    _imageMappingScheduleToRoom['holiday_profile_sailing_flutter.png'] =
        'holiday_profile_sailing_enabled.png';
    _imageMappingScheduleToRoom['holiday_profile_skiing_flutter.png'] =
        'holiday_profile_skiing_enabled.png';
    _imageMappingScheduleToRoom['holiday_profile_summer_flutter.png'] =
        'holiday_profile_summer_enabled.png';
    _imageMappingScheduleToRoom['holiday_profile_summer_two_flutter.png'] =
        'holiday_profile_summer_two_enabled.png';
    _imageMappingScheduleToRoom['holiday_profile_camping_flutter.png'] =
        'holiday_profile_camping_enabled.png';
    _imageMappingScheduleToRoom['holiday_profile_xmas_flutter.png'] =
        'holiday_profile_xmas_enabled.png';
    _imageMappingScheduleToRoom['holiday_profile_tent_flutter.png'] =
        'holiday_profile_tent_enabled.png';
    _imageMappingScheduleToRoom['holiday_profile_traveling_flutter.png'] =
        'holiday_profile_traveling_enabled.png';
    _imageMapping['room_icon_heating_profile_one_enabled.png'] =
        'heating_profile_one_flutter.png';
    _imageMapping['room_icon_heating_profile_two_enabled.png'] =
        'heating_profile_two_flutter.png';
    _imageMappingScheduleToRoom['heating_profile_one_flutter.png'] =
        'room_icon_heating_profile_one_enabled.png';
    _imageMappingScheduleToRoom['heating_profile_two_flutter.png'] =
        'room_icon_heating_profile_two_enabled.png';
    _imageMappingScheduleToRoom['heating_profile_bathroom_flutter.png'] =
        'room_icon_bathroom_enabled_flutter.png';
    _imageMappingScheduleToRoom['heating_profile_bedroom_flutter.png'] =
        'room_icon_bedroom_enabled_flutter.png';
    _imageMappingScheduleToRoom['heating_profile_childroom_flutter.png'] =
        'room_icon_child_room_enabled_flutter.png';
    _imageMappingScheduleToRoom['heating_profile_office_flutter.png'] =
        'room_icon_office_enabled_flutter.png';
    _imageMappingScheduleToRoom['heating_profile_dinig_room_flutter.png'] =
        'room_icon_dining_room_enabled_flutter.png';
    _imageMappingScheduleToRoom['heating_profile_kitchen_flutter.png'] =
        'room_icon_kitchen_enabled_flutter.png';
    _imageMappingScheduleToRoom['hetaing_profiel_living_room_flutter.png'] =
        'room_icons_living_room_enabled_flutter.png';
    _imageMappingScheduleToRoom['heating_profile_stairs_flutter.png'] =
        'room_icon_stairs_enabled_flutter.png';
  }

  String getMappiedImageName(String key) {
    String mappedImage = 'heating_profile_stairs_flutter.png';
    print(key);
    if (_imageMapping.containsKey(key)) {
      mappedImage = _imageMapping[key]!;
    }
    return mappedImage;
  }

  String getScheduleToRoom(String key) {
    String mappedImage = 'room_icon_stairs_enabled_flutter.png';
    if (_imageMappingScheduleToRoom.containsKey(key)) {
      mappedImage = _imageMappingScheduleToRoom[key]!;
    }
    return mappedImage;
  }
}
