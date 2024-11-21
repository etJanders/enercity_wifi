import 'dart:convert';

import 'package:http/http.dart';
import 'package:wifi_smart_living/const/const_json_identifier.dart';

///Description
///Check if the received database response is a message response
///
///Author: J. Anders
///created: 01-12-2022
///changed: 01-12-2022
///
///History:
///
///Notes:
class ApiMessageresponseDetection {
  bool responeMessageEmpfangen(Response response) {
    bool message = true;
    Map keyMap = jsonDecode(response.body) as Map;
    if (!keyMap.containsKey(ConstJsonIdentifier.identifierMessage)) {
      message = false;
    }
    return message;
  }
}
