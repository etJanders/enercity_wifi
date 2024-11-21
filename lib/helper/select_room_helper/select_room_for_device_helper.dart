import 'package:wifi_smart_living/core/image_mapping/select_room_image_mapping.dart';
import 'package:wifi_smart_living/models/database/model_group_management.dart';
import 'package:wifi_smart_living/models/ui/select_room/model_select_room.dart';

class SelectDeviceRoomHelper {
  final List<ModelGroupManagement> groups;
  late final List<ModelSelectRoom> _selectRoomList = [];

  SelectDeviceRoomHelper({required this.groups}) {
    _initSelectRoom();
  }

  void _initSelectRoom() {
    _selectRoomList.add(
        ModelSelectRoom("", 'add_device.png', 'add_device.png', false, true));
    SelectImageMapping mapping = SelectImageMapping();
    for (int i = 0; i < groups.length; i++) {
      ImageMappingHelper helper =
          mapping.getImageMappingObject(imageName: groups[i].groupImage);
      _selectRoomList.add(ModelSelectRoom(groups[i].groupName,
          helper.enabledImageName, helper.disabledImageName, false, false));
    }
  }

  List<ModelSelectRoom> get getSelectRoomList => _selectRoomList;

  ModelGroupManagement? getSelectedGroupManagemnt({required int id}) {
    int index = id - 1;
    return index >= 0 && index < groups.length ? groups[index] : null;
  }
}
