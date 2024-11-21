import 'package:flutter/material.dart';
import 'package:wifi_smart_living/models/database/model_group_management.dart';
import 'package:wifi_smart_living/presentation/add_new_thermostat/set_device_name_and_select_room/select_room_grid_tile.dart';
import 'package:wifi_smart_living/singelton/api_singelton.dart';
import '../../../helper/select_room_helper/select_room_for_device_helper.dart';

class SelectRoomGrid extends StatefulWidget {
  final Function roomSelected;
  const SelectRoomGrid({super.key, required this.roomSelected});

  @override
  State<SelectRoomGrid> createState() => _SelectRoomGridState();
}

class _SelectRoomGridState extends State<SelectRoomGrid> {
  late String selectedImageName;
  late SelectDeviceRoomHelper selectRoomHelper;
  late int selectedIndex = 0;

  @override
  void initState() {
    selectRoomHelper =
        SelectDeviceRoomHelper(groups: ApiSingelton().getModelGroupManagement);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: selectRoomHelper.getSelectRoomList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemBuilder: (context, index) => SelectRoomGridTile(
            groupName: selectRoomHelper.getSelectRoomList[index].getRoomName,
            image: selectRoomHelper.getSelectRoomList[index].getImageName,
            onTapCallback: () {
              newImageSelected(index);
            }));
  }

  void newImageSelected(int index) {
    if (index > 0 && index < selectRoomHelper.getSelectRoomList.length) {
      setState(() {
        for (int i = 0; i < selectRoomHelper.getSelectRoomList.length; i++) {
          if (i != index) {
            selectRoomHelper.getSelectRoomList[i].changeRoomSelectedMode(false);
          } else {
            selectRoomHelper.getSelectRoomList[i].changeRoomSelectedMode(true);
          }
        }
        selectRoomHelper.getSelectRoomList[index].changeRoomSelectedMode(true);
        selectedIndex = index;
      });
      selectedImageName =
          selectRoomHelper.getSelectRoomList[index].getImageName;
      widget
          .roomSelected(selectRoomHelper.getSelectedGroupManagemnt(id: index));
    } else {
      widget.roomSelected(ModelGroupManagement(
          entryPublicId: '',
          groupId: '',
          location: 0,
          groupName: '',
          groupImage: '',
          groupOwner: '',
          uiPosition: 0));
    }
  }
}
