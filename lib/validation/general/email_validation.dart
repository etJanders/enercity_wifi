import '../regex/regex_helper.dart';
import '../regex/regex_konstanten.dart';

///Description:
///Validiere eine Email Adresse auf atenintegrität
///
///Author: Julian Anders
///created: 01-08-2022
///changed: 01-08-2022
///
///History:
///
///Notes:
///
abstract class EmailValidator {
  static bool emailValide(String input) {
    return RegexHelper.inputValide(ConstRegEx.emailRegex, input);
  }
}
