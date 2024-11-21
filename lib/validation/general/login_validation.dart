import 'email_validation.dart';

///Description:
///Valdata user data are entered for database login
///
///Author: J. Anders
///created: 30-11-2022
///changed: 30-11-2022
///
///History:
///
///Notes:
class LoginValidation {
  LoginValidationState validateEmailAndPassword(
      {required String email, required String password}) {
    LoginValidationState errorMessage = LoginValidationState.validated;
    if (email.isEmpty || password.isEmpty) {
      errorMessage = LoginValidationState.emptyEntries;
    } else if (!EmailValidator.emailValide(email)) {
      errorMessage = LoginValidationState.wrongMailFormat;
    }
    return errorMessage;
  }
}

enum LoginValidationState { emptyEntries, wrongMailFormat, validated }
