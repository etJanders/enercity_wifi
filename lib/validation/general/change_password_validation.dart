import 'package:wifi_smart_living/validation/general/password_validatoion.dart';

///Description
///Validate double password inputs
///
///Author: J.Anders
///create: 30-11-2022
///change: 30-11-2022
///
///History:
///
///Notes:
///
class ChangePasswordValidator {
  PasswordValidationState validateNewPassword(
      {required String password, required String confirmedPassword}) {
    PasswordValidationState validationState =
        PasswordValidationState.passwordValid;
    if (password != confirmedPassword) {
      validationState = PasswordValidationState.passwordNotSame;
    } else if (!ValdiatePassword(password: password).passwordValidate()) {
      validationState = PasswordValidationState.wrongFormat;
    }
    return validationState;
  }
}

enum PasswordValidationState { passwordValid, passwordNotSame, wrongFormat }
