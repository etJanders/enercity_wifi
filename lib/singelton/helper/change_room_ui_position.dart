import 'package:wifi_smart_living/const/const_location.dart';
import 'package:wifi_smart_living/helper/sort_room_view/sort_room_ids.dart';
import 'package:wifi_smart_living/models/database/model_group_management.dart';
import 'package:wifi_smart_living/singelton/api_singelton.dart';
import 'package:wifi_smart_living/singelton/helper/api_singelton_helper.dart';

///Description
///Drag and Drop helper to reorganice the room structure
///
///Author: J. Anders
///created:30-11-2022
///changed: 30-11-2022
///
///History:
///
///Notes:
///
class ChangeUIPositionHelper {
  void changeRoomPosition(int oldIndex, int newIndex) {
    List<ModelGroupManagement> groups = ApiSingeltonHelper()
        .groupManagementsByLocation(
            ConstLocationidentifier.locationidentifierIndoorInt);
    ModelGroupManagement temp = groups.removeAt(oldIndex);
    groups.insert(newIndex, temp);
    changeUiPositionNumber(groups);
  }

  void changeUiPositionNumber(List<ModelGroupManagement> management) {
    //Rooms where ui position has changed to update this rooms in database
    List<ModelGroupManagement> positionChanged = [];
    for (int i = 0; i < management.length; i++) {
      int index = i;
      if (management[i].uiPosition != (index + 1)) {
        management[i].uiPosition = (index + 1);
        positionChanged.add(management[i]);
      }
    }
    updateInternalPufferUndDatenbank(positionChanged);
  }

  void updateInternalPufferUndDatenbank(
      List<ModelGroupManagement> management) async {
    for (int i = 0; i < management.length; i++) {
      ModelGroupManagement temp = management[i];
      for (int j = 0; j < ApiSingelton().getModelGroupManagement.length; j++) {
        if (ApiSingelton().getModelGroupManagement[j].groupId == temp.groupId) {
          ApiSingelton().getModelGroupManagement[j].uiPosition =
              temp.uiPosition;
        }
      }
    }
    RoomDragAndDropHelper helper = RoomDragAndDropHelper();
    helper.sortiereUiPositions();
    await helper.updateDatabaseIfNeededExternalList(management);
  }
}
