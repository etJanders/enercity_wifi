abstract class BuildTemperatureString {
  static const String _defaultValue = '--.-';
  static String bildTemperatureString({required int temperature}) {
    String output = _defaultValue;
    if (temperature != 0x80) {
      if (temperature == 15) {
        output = 'off';
      } else if (temperature == 57) {
        output = 'on';
      } else {
        output = '${temperature / 2} °C';
      }
    }
    return output;
  }

  static String bildTemperatureStringBasic({required int temperature}) {
    String output = _defaultValue;
    if (temperature != 0x80) {
      if (temperature == 15) {
        output = 'off';
      } else if (temperature == 57) {
        output = 'on';
      } else {
        output = '${temperature / 2}';
      }
    }
    return output;
  }
}
