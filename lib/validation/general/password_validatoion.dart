///Description
///Validate user password
///
///Author: J. Anders
///created: 30-11-2022
///changed: 30-11-2022
///
///History:
///
///Notes:
///Optimice this. Take on expression for all cases.
class ValdiatePassword {
  final String password;

  ValdiatePassword({required this.password});

  bool passwordValidate() {
    bool number = RegExp("(?=.*[0-9])").hasMatch(password);
    bool smallLetter = RegExp("(?=.*[a-z])").hasMatch(password);
    bool bigLetter = RegExp("(?=.*[A-Z])").hasMatch(password);
    bool size = password.length >= 8;
    return number && smallLetter && bigLetter && size;
  }
}
