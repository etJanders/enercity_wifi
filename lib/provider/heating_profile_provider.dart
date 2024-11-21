import 'package:flutter/material.dart';
import 'package:wifi_smart_living/heatingProfile/management/init_schaltzeiten_manager.dart';
import 'package:wifi_smart_living/models/database/model_schedule_manager.dart';

import '../converter/hetaing_profile_schedule_to_mqtt.dart';
import '../heatingProfile/heatingTimeSort/bubble_sort_heating.dart';
import '../heatingProfile/management/schaltzeiten_intervall.dart';

///Description
///Provider which manages the heating profile management
///
///Author: J. Anders
///created: 17-01-2023
///changed: 17-01-2023
///
///History:
///
///Note:
///
class HeatingProfileProvider with ChangeNotifier {
  ///Zeitplan, der verwaltet werden soll
  late ModelScheduleManager _scheduleManager;
  //Intervalle der UI
  late List<SchaltzeitenIntervall> schaltzeitenIntervalle = [];
  late HeatintProfileToMqttHelper profileValidator;

  //gibt an, ob noch weitere intervalle erstellt werden können.
  bool _addNewIntervallsAllowed = true;
  bool _dataChanged = false;

  //Init die Datenverwaltung
  void initProvider(ModelScheduleManager manager) {
    _scheduleManager = manager;
    schaltzeitenIntervalle =
        InitSchaltzeitManager().initSchaltzeitenIntervall(manager);
    _addNewIntervallsAllowed = !_alleWochentageBelegt();
    _dataChanged = false;
  }

  //Add new heating time interval to the UI
  void changeAnzahlIntervalle() {
    SchaltzeitenIntervall intervall = SchaltzeitenIntervall();
    intervall.leeresIntervallHinzufuegen();
    schaltzeitenIntervalle.add(intervall);
    notifyListeners();
  }

  bool weekdayAdded(String weekday) {
    bool weekdayAdded = false;
    for (int i = 0; i < schaltzeitenIntervalle.length; i++) {
      if (schaltzeitenIntervalle[i].istWochentagSelected(weekday)) {
        weekdayAdded = true;
        break;
      }
    }
    return weekdayAdded;
  }

  void leeresIntervallHinzufuegen(int intervall) {
    if (schaltzeitenIntervalle[intervall].zeitschaltpunkte.length < 9) {
      schaltzeitenIntervalle[intervall].leeresIntervallHinzufuegen();
      notifyListeners();
    }
  }

  void entferneIntervall(int intervall, int intervallIndex) {
    if (intervall > -1 && intervall < schaltzeitenIntervalle.length) {
      if (intervallIndex > -1 &&
          intervallIndex <
              schaltzeitenIntervalle[intervall].zeitschaltpunkte.length) {
        schaltzeitenIntervalle[intervall]
            .entferneBestehendesIntervall(intervallIndex);
        if (schaltzeitenIntervalle[intervall].zeitschaltpunkte.isEmpty) {
          schaltzeitenIntervalle.removeAt(intervall);
          _addNewIntervallsAllowed = true;
        }
        toggelDataChanged();
        notifyListeners();
      }
    }
  }

  bool changeWeekday(int intervall, String weekday) {
    bool weekdayChanged = false;
    if (intervall > -1 && intervall < schaltzeitenIntervalle.length) {
      if (schaltzeitenIntervalle[intervall].istWochentagSelected(weekday)) {
        schaltzeitenIntervalle[intervall].entferneWochentag(weekday);
        weekdayChanged = true;
      } else if (!schaltzeitenIntervalle[intervall]
              .istWochentagSelected(weekday) &&
          weekdayAdded(weekday)) {
        weekdayChanged = false;
      } else {
        schaltzeitenIntervalle[intervall].neuenWochentagHinzufuegen(weekday);
        weekdayChanged = true;
      }
      toggelDataChanged();
      _addNewIntervallsAllowed = !_alleWochentageBelegt();
      notifyListeners();
    }
    return weekdayChanged;
  }

  bool weekdaysSelected() {
    bool weekdaySelectedSate = false;
    for (int i = 0; i < schaltzeitenIntervalle.length; i++) {
      if (schaltzeitenIntervalle[i].wochentage.isNotEmpty) {
        weekdaySelectedSate = true;
      }
    }
    return weekdaySelectedSate;
  }

  void changeTime(int indexinterval, int indexTime, TimeOfDay timeOfDay) {
    schaltzeitenIntervalle[indexinterval]
        .zeitschaltpunkte[indexTime]
        .setNewTime(hour: timeOfDay.hour, minute: timeOfDay.minute);
    schaltzeitenIntervalle[indexinterval].zeitschaltpunkte =
        BubblSortHeatingTime.sortiereZeitenNachBubbleSort(
            schaltzeitenIntervalle[indexinterval].zeitschaltpunkte);
    toggelDataChanged();
    notifyListeners();
  }

  void changeTemperature(int indexInterval, int indexTemp, int temperature) {
    schaltzeitenIntervalle[indexInterval]
        .zeitschaltpunkte[indexTemp]
        .setTemperature(temperature: temperature);
    toggelDataChanged();
    notifyListeners();
  }

  bool timeAlreadyExist(int indexinterval, TimeOfDay timeOfDay) {
    return schaltzeitenIntervalle[indexinterval]
        .zeitBereitsBekannt(timeOfDay.hour, timeOfDay.minute);
  }

  bool _alleWochentageBelegt() {
    int belegteWochentage = 0;
    for (int i = 0; i < schaltzeitenIntervalle.length; i++) {
      belegteWochentage =
          belegteWochentage + schaltzeitenIntervalle[i].wochentage.length;
    }
    return belegteWochentage >= 7;
  }

  List<String> getWeekday(int schaltzeitIndex) {
    if (schaltzeitIndex > -1 &&
        schaltzeitIndex < schaltzeitenIntervalle.length) {
      return schaltzeitenIntervalle[schaltzeitIndex].wochentage;
    }
    return [];
  }

  bool alleSchaltzeitenValide() {
    bool alleZeitenValide = true;
    for (int i = 0; i < schaltzeitenIntervalle.length; i++) {
      if (!schaltzeitenIntervalle[i].intervalleOhneZeitOderTemperatur()) {
        alleZeitenValide = false;
        break;
      }
    }
    return alleZeitenValide;
  }

  Map<String, String> getScheduleMap() {
    profileValidator = HeatintProfileToMqttHelper(
        schaltzeitenIntervalle: schaltzeitenIntervalle);
    return profileValidator.getMapBuilder.getMap;
  }

  void toggelDataChanged() {
    if (weekdaysSelected() && alleSchaltzeitenValide()) {
      _dataChanged = true;
    } else {
      _dataChanged = false;
    }
  }

  int get getAnzahlIntervalle => schaltzeitenIntervalle.length;
  bool get getNewIntervallsAllowed => _addNewIntervallsAllowed;
  ModelScheduleManager get getScheduleManager => _scheduleManager;
  bool get getDataChanged => _dataChanged;
}
