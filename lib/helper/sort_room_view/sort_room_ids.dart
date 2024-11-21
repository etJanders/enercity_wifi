import 'package:wifi_smart_living/api_handler/api_treiber/update_ui_components/update_ui_components_helper.dart';
import 'package:wifi_smart_living/const/const_location.dart';
import 'package:wifi_smart_living/models/database/model_group_management.dart';
import 'package:wifi_smart_living/singelton/api_singelton.dart';

///Beschreibung:
///Initialisiert die Drag and Drop option.
///Weise allen Räumen, die einen Index von 0 haben einen neuen Index zu und lege
///den neuen Index in der Datenbank ab. Räume werden nach Index sortiert in der UI
///angezeigt.
///Der zugewiesene Index startet immer mit 1. Hat ein Raum einen Index 0, wurde
///dieser von der alten App angelegt und muss mit einem neuen Index belegt werden.
///Jetzt kann per Drag and Drop problemlos die Reiehnfolge geändert werden
///
///Author: J. Anders
///created: 25-01-2023
///changed: 25-01-2023
///
///History:
///
///Notes:
///
class RoomDragAndDropHelper {
  late List<ModelGroupManagement> updatabelValues = [];

  RoomDragAndDropHelper() {
    sortiereUiPositions();
    updatabelValues = updateUiPositionIndex();
  }

  ///Sortiere die Groups nach UI position
  void sortiereUiPositions() {
    for (int i = 0;
        i < ApiSingelton().getModelGroupManagement.length - 1;
        i++) {
      for (int j = 0;
          j < ApiSingelton().getModelGroupManagement.length - i - 1;
          j++) {
        if (ApiSingelton().getModelGroupManagement[j].uiPosition >
            ApiSingelton().getModelGroupManagement[j + 1].uiPosition) {
          ModelGroupManagement temp = ApiSingelton().getModelGroupManagement[j];
          ApiSingelton().getModelGroupManagement[j] =
              ApiSingelton().getModelGroupManagement[j + 1];
          ApiSingelton().getModelGroupManagement[j + 1] = temp;
        }
      }
    }
  }

  bool allePositionen0() {
    bool allePostioionen0 = true;
    for (int i = 0;
        i < ApiSingelton().getModelGroupManagement.length - 1;
        i++) {
      if (ApiSingelton().getModelGroupManagement[i].uiPosition != 0 &&
          _locationIndoor(i)) {
        allePostioionen0 = false;
        break;
      }
    }
    return allePostioionen0;
  }

  List<ModelGroupManagement> updateUiPositionIndex() {
    List<ModelGroupManagement> updateEntries = [];
    int highestIndex = _bestimmeHoechstenIndex();
    for (int i = 0; i < ApiSingelton().getModelGroupManagement.length; i++) {
      if (ApiSingelton().getModelGroupManagement[i].uiPosition == 0 &&
          _locationIndoor(i)) {
        highestIndex++;
        ApiSingelton().getModelGroupManagement[i].uiPosition = highestIndex;
        updateEntries.add(ApiSingelton().getModelGroupManagement[i]);
      }
    }
    sortiereUiPositions();
    return updateEntries;
  }

  int _bestimmeHoechstenIndex() {
    int highestIndex = 0;
    for (int i = 0; i < ApiSingelton().getModelGroupManagement.length; i++) {
      if (_locationIndoor(i) &&
          ApiSingelton().getModelGroupManagement[i].uiPosition > highestIndex) {
        highestIndex = ApiSingelton().getModelGroupManagement[i].uiPosition;
      }
    }
    return highestIndex;
  }

  Future<void> updateDatabaseIfNeeded() async {
    if (updatabelValues.isNotEmpty) {
      await Future.forEach(updatabelValues, (element) async {
        await UpdateUiComponentsHelper().updateDatabase(databaseModel: element);
        print(element.groupId);
      });
    }
  }

  Future<void> updateDatabaseIfNeededExternalList(
      List<ModelGroupManagement> updatabelValues) async {
    if (updatabelValues.isNotEmpty) {
      await Future.forEach(updatabelValues, (element) async {
        await UpdateUiComponentsHelper().updateDatabase(databaseModel: element);
        print(element.groupId);
      });
    }
  }

  bool _locationIndoor(int index) {
    return ApiSingelton().getModelGroupManagement[index].location ==
        ConstLocationidentifier.locationidentifierIndoorInt;
  }
}
