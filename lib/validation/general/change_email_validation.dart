import 'package:wifi_smart_living/validation/general/email_validation.dart';

///Description:
///Check if Mails are in correct format for changing mail adress
///
///Author: J. Anders
///created: 16-12-2022
///changed: 16-12-2022
///
///History:
///
///Notes:
///
abstract class ChangeMailValidation {
  static MailValidationState validateMail(
      {required String mail, required String confirmMail}) {
    MailValidationState state;
    if (mail.isEmpty || confirmMail.isEmpty) {
      state = MailValidationState.noEmailEnterd;
    } else if (mail != confirmMail) {
      state = MailValidationState.mailsNotSame;
    } else if (!EmailValidator.emailValide(mail)) {
      state = MailValidationState.mailWrongFormat;
    } else {
      state = MailValidationState.mailValid;
    }
    return state;
  }
}

enum MailValidationState {
  mailsNotSame,
  mailWrongFormat,
  mailValid,
  noEmailEnterd
}
