import 'dart:convert';

import 'package:http/http.dart';
import 'package:wifi_smart_living/models/database/model_database_user.dart';

import '../../const/const_json_identifier.dart';

///Description
///Convert received json into database user model
///
///Author: J. Anders
///created: 13-12-2022
///changed: 13-12-2022
///
///History:
///
///Notes:
///
abstract class ParseDatabaseUser {
  static ModelDatabaseUser converteDatabaseUser(
      {required Response receivedMessage, required String password}) {
    var body = receivedMessage.body;
    List<dynamic> tagsJson =
        jsonDecode(body)[ConstJsonIdentifier.jsonIdentifierUser];
    return ModelDatabaseUser.fromJson(password: password, rawData: tagsJson[0]);
  }
}
