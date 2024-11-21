///Description
/// Check if data input matches with a regex
///Author: J. Anders
///created: 30-11-2022
///changed: 30-11-2022
///
///History:
///
///Notes:
///
abstract class RegexHelper {
  static bool inputValide(String regex, String input) =>
      RegExp(regex).hasMatch(input);
}
