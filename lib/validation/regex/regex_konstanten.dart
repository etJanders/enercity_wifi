///Description
///RegEx are used
///Author: J. Anders
///created: 30-11-2022
///changed: 30-11-2022
///
///History:
///
///Notes:
///
abstract class ConstRegEx {
  static const String passwordRegex =
      "^(?=.*[a-z])(?=.*[A-Z])(?=.*)[a-zA-Z]{8,}\$";
  static const String emailRegex =
      "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+.[A-Z|a-z]{2,}";
  static const String hexRegex = '^[a-fA-F0-9]\$';
  static const String numberRegEx = '^[0-9]\$';
}
