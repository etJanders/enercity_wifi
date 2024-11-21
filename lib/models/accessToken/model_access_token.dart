import '../../const/const_json_identifier.dart';

///Description
///Every api interaction requires a x-access-token. this token has a life-time
///of 30 Minuts. This class specify the token with all attributes
///
///Author: J. Anders
///created: 30-11-2022
///changed: 30-11-2022
///
///History:
///
///Nodes:
///
class ModelAccessToken {
  //This is the token are used for interaction
  final String tokenString;
  //Description
  final String tokenDescription;
  //Token statet true = serviceToken, false = user token
  final bool serviceToken;
  //Time, when token was determined
  final int tokenCreatedTime;

  ModelAccessToken(
      {required this.tokenString,
      required this.tokenDescription,
      required this.serviceToken,
      required this.tokenCreatedTime});

  factory ModelAccessToken.fromJson(
      {required Map<String, dynamic> data, required bool sevice}) {
    return ModelAccessToken(
        tokenString: data[ConstJsonIdentifier.identifierXAccassToken],
        tokenDescription: data[ConstJsonIdentifier.identifierMessage],
        serviceToken: sevice,
        tokenCreatedTime: DateTime.now().microsecondsSinceEpoch);
  }
}
