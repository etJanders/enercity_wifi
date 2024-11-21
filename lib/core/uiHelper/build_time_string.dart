import 'package:flutter/material.dart';

import '../../validation/general/data_length_validator.dart';

abstract class BuildTimeString {
  static const String _defaultString = '--:--';

  static String getDisplayTime({required int stunde, required int minute}) {
    ///Hier kommen die Daten schon falsch an!!!
    String output = _defaultString;
    if (stunde != 0x80 && minute != 0x80) {
      output =
          '${DataLengthValidator.validateDataLength(data: stunde.toString(), length: DataLengh.dataLengthTwo)}:${DataLengthValidator.validateDataLengthReverse(data: minute.toString(), length: DataLengh.dataLengthTwo)}';
    }
    return output;
  }

  static String getDisplayTimeWithFormat(BuildContext context,
      {required int hour, required int minute}) {
    String output = _defaultString;

    if (hour != 0x80 && minute != 0x80) {
      if (MediaQuery.of(context).alwaysUse24HourFormat) {
        output =
            '${DataLengthValidator.validateDataLength(data: hour.toString(), length: DataLengh.dataLengthTwo)}:${DataLengthValidator.validateDataLengthReverse(data: minute.toString(), length: DataLengh.dataLengthTwo)}';
      } else {
        String postFix = (hour >= 12) ? 'PM' : 'AM';
        int hoursIn12hrFormat = hour % 12;
        if (hoursIn12hrFormat == 0) {
          hoursIn12hrFormat += 12;
        }
        output =
            '${DataLengthValidator.validateDataLength(data: hoursIn12hrFormat.toString(), length: DataLengh.dataLengthTwo)}:${DataLengthValidator.validateDataLengthReverse(data: minute.toString(), length: DataLengh.dataLengthTwo)} $postFix';

      }
    }

    return output;
  }
}
