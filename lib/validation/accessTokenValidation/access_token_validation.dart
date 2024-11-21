import '../../models/accessToken/model_access_token.dart';

///Description
///Validate a User Access Token to check if x-access-token is valid
///Note: Every token has a validation time of 30 minutes.
///
///Author: J. Anders
///create: 30-11-2022
///change: 30-11-2022
///
///History:
///
///Notes:
///
class AccessTokenValidation {
  static const int _calculateTimeInMs = 60000000;
  static const int _dreisigMinuten = _calculateTimeInMs * 30;

  final ModelAccessToken token;

  AccessTokenValidation({required this.token});

  bool tokenNochValide() {
    bool tokenValide = false;
    if (!token.serviceToken) {
      int currentTime = DateTime.now().microsecondsSinceEpoch;
      int endZeit = (token.tokenCreatedTime + _dreisigMinuten);
      if (endZeit > currentTime &&
          _concertMsInMinute((endZeit - currentTime)) >= 10) {
        tokenValide = true;
      }
    }
    return tokenValide;
  }

  int _concertMsInMinute(int restzeit) {
    int verbleibendeZeit = 0;
    if (restzeit > 0) {
      verbleibendeZeit = (restzeit / _calculateTimeInMs).round();
    }
    return verbleibendeZeit;
  }
}
