import 'dart:convert';
import '../../core/map_helper/map_builder.dart';

///Description
///Create a HTTP Header to call database functions. There a two kinds of header
///supported:
///- Header with x-access-token
///- header for base auth
///
///Author: Julian Anders
///created: 05-10-2022
///changed: 05-10-2022
///
///History:
///
///Notes:
abstract class HttpHeaderHelper {
  ///HTTP Header for basic authentification
  static Future<Map<String, String>> createBaseAuthHeader(
      {required String mail, required String password}) async {
    MapBuilder mapBuilder = MapBuilder();
    final String basicAuth =
        'Basic ${base64.encode(utf8.encode('$mail:$password'))}';
    mapBuilder.addStingMapEntry(key: 'authorization', value: basicAuth);
    //Help to difference between android and ios apps
    /*
    mapBuilder.addStingMapEntry(
        key: 'User-Agent',
        value: await SmartphoneBuild.defineSmartphoneIdenificationString());*/
    return mapBuilder.getStringMap;
  }

  ///Header includes x-access-token
  static Future<Map<String, String>> createAccessTokenHeader(
      {required String xaccesstoken}) async {
    MapBuilder mapBuilder = MapBuilder();
    mapBuilder.addStingMapEntry(
        key: "Content-Type", value: "application/json; charset=UTF-8");
    mapBuilder.addStingMapEntry(key: "x-access-token", value: xaccesstoken);
    //Help to difference between android and ios apps
    /*
    mapBuilder.addStingMapEntry(
        key: 'User-Agent',
        value: await SmartphoneBuild.defineSmartphoneIdenificationString());*/
    return mapBuilder.getStringMap;
  }
}
