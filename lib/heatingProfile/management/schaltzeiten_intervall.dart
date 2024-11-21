import '../heating_profile_item.dart';

///Ein Schaltzeitenintervall gibt an, für welche Wochentage ein Intervall genutzt werden soll und
///welche Zeiten verwendet werden
class SchaltzeitenIntervall {
  //Wochentage, für die das Intervall genutzt werdne soll
  List<String> wochentage = [];

  ///Zeitschaltpunkte, die einem Intervall hinzugefuegt wurden
  List<HeatingProfileDatabaseItem> zeitschaltpunkte = [];

  void initZeitschaltpunkte(
      List<HeatingProfileDatabaseItem> initData, String profileId) {
    zeitschaltpunkte = initData;
    neuenWochentagHinzufuegen(profileId);
  }

  ///Fuege dem Intervall einen neuen Wochentag hinzu
  void neuenWochentagHinzufuegen(String wochentagProfilIdentifier) {
    if (!istWochentagSelected(wochentagProfilIdentifier)) {
      wochentage.add(wochentagProfilIdentifier);
    }
  }

  void neuesIntervallHinzufuegen(HeatingProfileDatabaseItem item) {
    zeitschaltpunkte.add(item);
  }

  void leeresIntervallHinzufuegen() {
    zeitschaltpunkte.add(HeatingProfileDatabaseItem(0x80, 0x80, 0x80, 0x80));
  }

  void entferneBestehendesIntervall(int index) {
    if (index > -1 && index < zeitschaltpunkte.length) {
      zeitschaltpunkte.removeAt(index);
    }
  }

  ///Gebe an, ob ein Wochentag bereits genutz wird
  bool istWochentagSelected(String wochentag) {
    return wochentage.contains(wochentag);
  }

  bool zeitBereitsBekannt(int stunde, int minute) {
    bool zeitBekannt = false;
    if (stunde != 0x80 && minute != 0x80) {
      for (int i = 0; i < zeitschaltpunkte.length; i++) {
        HeatingProfileDatabaseItem item = zeitschaltpunkte[i];
        if (item.getStartHour == stunde && item.getStartMinute == minute) {
          zeitBekannt = true;
          break;
        }
      }
    }
    return zeitBekannt;
  }

  ///Entferne eine Wochentag, sofern dieser bereits vorhanden ist
  void entferneWochentag(String entferneWochentag) {
    if (istWochentagSelected(entferneWochentag)) {
      wochentage.remove(entferneWochentag);
    }
  }

  bool intervalleOhneZeitOderTemperatur() {
    bool intervalleValiede = false;
    for (int i = 0; i < zeitschaltpunkte.length; i++) {
      HeatingProfileDatabaseItem item = zeitschaltpunkte[i];
      if (!punktNull(
          item.getStartHour, item.getStartMinute, item.getTemperature)) {
        if (item.getStartHour != 0x80 &&
            item.getStartMinute != 0x80 &&
            item.getTemperature != 0x80) {
          intervalleValiede = true;
          break;
        }
      }
    }
    return intervalleValiede;
  }

  bool punktNull(int stunde, int minute, int temperatur) {
    return stunde == 0x80 && minute == 0x80 && temperatur == 0x80;
  }
}
