import 'dart:convert';
import 'package:http/http.dart';
import '../../const/const_json_identifier.dart';

///Description
///Parse API Json Messages
///
///Author: J. Anders
///created: 01-12-2022
///changed: 01-12-2022
///
///History:
///
///Notes:
///
abstract class HttpMessageParser {
  static String getMessage(Response receivedMessage) {
    var body = receivedMessage.body;
    var message = jsonDecode(body);
    return message[ConstJsonIdentifier.identifierMessage] as String;
  }
}
