import '../heating_profile_item.dart';

class BubblSortHeatingTime {
  static List<HeatingProfileDatabaseItem> sortiereZeitenNachBubbleSort(
      List<HeatingProfileDatabaseItem> profile) {
    for (int i = 0; i < profile.length; i++) {
      for (int j = 0; j < profile.length - 1; j++) {
        if (profile[j].getStartHour > profile[j + 1].getStartHour) {
          HeatingProfileDatabaseItem temp = profile[j];
          profile[j] = profile[j + 1];
          profile[j + 1] = temp;
        } else if (profile[j].getStartHour == profile[j + 1].getStartHour) {
          if (profile[j].getStartMinute > profile[j + 1].getStartMinute) {
            HeatingProfileDatabaseItem temp = profile[j];
            profile[j] = profile[j + 1];
            profile[j + 1] = temp;
          }
        }
      }
    }
    return profile;
  }
}
