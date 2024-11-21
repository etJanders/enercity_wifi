import 'dart:convert';

import 'package:http/http.dart';

import '../../const/const_json_identifier.dart';
import '../../models/accessToken/model_access_token.dart';

///Description
///Parse a json file which inclueds a xAccessToken
///
///Author: J. Anders
///created: 30-11-2022
///changed: 30-11-2022
///
///History:
///
///Nodes:
///Todo check if received message is a token
abstract class ParseAccessToken {
  static ModelAccessToken converteToken(
      {required Response receivedMessage, required bool serviceUser}) {
    var body = receivedMessage.body;
    List<dynamic> tagsJson =
        jsonDecode(body)[ConstJsonIdentifier.identifierTokenState];
    return ModelAccessToken.fromJson(data: tagsJson[0], sevice: serviceUser);
  }
}
