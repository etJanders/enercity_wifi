import 'package:wifi_smart_living/models/accessToken/model_access_token.dart';

///Description
///Summery of information are used for password reset process
///
///Author: J. Anders
///created: 26-01-2023
///changed: 26-01-2023
///
///History:
///
///Notes:
///
class PasswordResetHelper {
  late String _userMailAdress;
  late String _resetToken;
  late ModelAccessToken _modelAccessToken;

  void setUserMail(String currentuserMail) {
    _userMailAdress = currentuserMail;
  }

  void setresetToken(String receivedResetToken) {
    _resetToken = receivedResetToken;
  }

  void setAccessToken(ModelAccessToken resetToken) {
    _modelAccessToken = resetToken;
  }

  String get getUserMail => _userMailAdress;
  String get getResetToken => _resetToken;
  ModelAccessToken get getAccessToken => _modelAccessToken;
}
