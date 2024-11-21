import 'package:wifi_smart_living/validation/general/email_validation.dart';
import 'package:wifi_smart_living/validation/general/password_validatoion.dart';

///Description:
///Validate input filds are entered during the user account creating process
///
///Author:  J.Anders
///created: 30-11-2022
///changed: 13-12-2022
///
///History:
///13-12-2022 Mail Adress should be entered double. Check that both adresses are the same
///
///Notes:
class ValidateCreateUserAccount {
  final String userMail;
  final String confirmUserMail;
  final String userPassword;
  final String confirmedPassword;
  final bool agbState;

  ValidateCreateUserAccount(
      {required this.userMail,
      required this.confirmUserMail,
      required this.userPassword,
      required this.confirmedPassword,
      required this.agbState});

  ValidateCreateUserState validateData() {
    ValidateCreateUserState valideState =
        ValidateCreateUserState.allInformationValide;
    if (_eingabenLeer()) {
      valideState = ValidateCreateUserState.emptyFields;
    } else if (!EmailValidator.emailValide(userMail)) {
      valideState = ValidateCreateUserState.emailNotValide;
    } else if (!_mailAdressesSame()) {
      valideState = ValidateCreateUserState.mailNotSame;
    } else if (!agbState) {
      valideState = ValidateCreateUserState.agbNotaccepted;
    } else if (!_passworteGleich()) {
      valideState = ValidateCreateUserState.passwordNotSame;
    } else if (!ValdiatePassword(password: userPassword).passwordValidate()) {
      valideState = ValidateCreateUserState.passwordNotValide;
    }
    return valideState;
  }

  bool _eingabenLeer() {
    return userMail.isEmpty ||
        confirmUserMail.isEmpty ||
        userPassword.isEmpty ||
        confirmedPassword.isEmpty;
  }

  bool _passworteGleich() {
    return userPassword == confirmedPassword;
  }

  bool _mailAdressesSame() {
    return userMail == confirmUserMail;
  }
}

enum ValidateCreateUserState {
  emptyFields,
  emailNotValide,
  agbNotaccepted,
  passwordNotSame,
  passwordNotValide,
  allInformationValide,
  mailNotSame
}
