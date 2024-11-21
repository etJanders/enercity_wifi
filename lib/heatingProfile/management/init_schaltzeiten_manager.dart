import 'package:wifi_smart_living/heatingProfile/compare_array_lists.dart';
import 'package:wifi_smart_living/heatingProfile/management/schaltzeiten_intervall.dart';
import 'package:wifi_smart_living/models/database/model_room_profile.dart';
import 'package:wifi_smart_living/singelton/helper/api_singelton_helper.dart';

import '../../core/calculation/timeSchedule/heatingtime_calculator.dart';
import '../../models/database/model_schedule_manager.dart';
import '../heating_profile_item.dart';

class InitSchaltzeitManager {
  static const int _defaultIndex = -1;
  List<SchaltzeitenIntervall> meineSchaltzeiten = [];

  List<SchaltzeitenIntervall> initSchaltzeitenIntervall(
      ModelScheduleManager manager) {
    List<ModelRoomProfile> raumHeizprofile =
        ApiSingeltonHelper().getProfilesBySchedulemanager(manager);
    for (int i = 0; i < raumHeizprofile.length; i++) {
      ModelRoomProfile roomProfile = raumHeizprofile[i];
      if (!datenbankSchaltzeitLeer(roomProfile) && meineSchaltzeiten.isEmpty) {
        SchaltzeitenIntervall intervall = SchaltzeitenIntervall();
        intervall.initZeitschaltpunkte(
            HeatingtimeCalculatorHelper.getWeekayHeating(
                mqttData: roomProfile.profileValue),
            roomProfile.profileId);
        meineSchaltzeiten.add(intervall);
      } else if (!datenbankSchaltzeitLeer(roomProfile) &&
          meineSchaltzeiten.isNotEmpty) {
        int index = schaltzeitenBereitsBekannt(roomProfile);
        if (index != _defaultIndex) {
          //Die Schaltzeiten sind bereits einem wochentag zugeordnet.
          meineSchaltzeiten[index]
              .neuenWochentagHinzufuegen(roomProfile.profileId);
        } else {
          SchaltzeitenIntervall intervall = SchaltzeitenIntervall();
          intervall.initZeitschaltpunkte(
              HeatingtimeCalculatorHelper.getWeekayHeating(
                  mqttData: roomProfile.profileValue),
              roomProfile.profileId);
          meineSchaltzeiten.add(intervall);
        }
      }
    }
    return meineSchaltzeiten;
  }

  bool datenbankSchaltzeitLeer(ModelRoomProfile modelRoomProfile) {
    return modelRoomProfile.profileValue == '#';
  }

  int schaltzeitenBereitsBekannt(ModelRoomProfile roomProfile) {
    int bereitsBekannt = _defaultIndex;
    List<HeatingProfileDatabaseItem> profiles =
        HeatingtimeCalculatorHelper.getWeekayHeating(
            mqttData: roomProfile.profileValue);
    for (int i = 0; i < meineSchaltzeiten.length; i++) {
      if (CompareArrayLists()
          .arrayListsSame(meineSchaltzeiten[i].zeitschaltpunkte, profiles)) {
        bereitsBekannt = i;
        break;
      }
    }
    return bereitsBekannt;
  }
}
