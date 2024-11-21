import 'package:wifi_smart_living/api_handler/api_treiber/api_base_url_helper/api_url_helper.dart';

///Decription
///Create Api Url
///
///Author: J. Anders
///created: 29-11-2022
///changed: 29-11-2022
///
///History:
///
///Notes:
abstract class UriParser {
  static Future<Uri> createUri({required String apiFunction}) async {
    return Uri.parse((await ApiUrlHelper().urlToUse() + apiFunction));
  }

  static Uri createUriByBase(
      {required String baseUrl, required String apiFunction}) {
    return Uri.parse(baseUrl + apiFunction);
  }

  static Uri createBasicUri({required String url}) {
    return Uri.parse(url);
  }
}
