abstract class SplitStringHelper {
  static List<String> splitStringOnCharacter(
      {required String character, required String dataString}) {
    return dataString.split(character);
  }

  static List<String> splitStringAfterCharactersString(
      {required String dataString, required int splitPosition}) {
    List<String> splitted = [];
    if (dataString.length % splitPosition == 0) {
      for (int i = 0; i < dataString.length; i += splitPosition) {
        splitted.add(dataString.substring(i, i + splitPosition));
      }
    }
    return splitted;
  }

  static List<int> splitStringAfterCharactersInt(
      {required String dataString, required int splitPosition}) {
    List<int> splitted = [];
    if (dataString.length % splitPosition == 0) {
      for (int i = 0; i < dataString.length; i += splitPosition) {
        splitted.add(
            int.parse(dataString.substring(i, i + splitPosition), radix: 16));
      }
    }
    return splitted;
  }
}
