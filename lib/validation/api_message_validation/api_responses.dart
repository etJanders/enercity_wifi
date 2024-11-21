import 'dart:convert';
import 'package:http/http.dart';

import '../../const/const_json_identifier.dart';

///Description
/// Validate a api json response to check if the response is a message response
///
/// Author: J. Anders
/// created: 29-11-2022
/// changed: 29-11-2022
///
/// History:
///
/// Notes:
///
class ApiMessageresponseValidator {
  bool responeMessageEmpfangen(Response response) {
    bool message = true;
    Map keyMap = jsonDecode(response.body) as Map;
    if (!keyMap.containsKey(ConstJsonIdentifier.identifierMessage)) {
      message = false;
    }
    return message;
  }
}
