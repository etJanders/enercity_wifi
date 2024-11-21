import 'package:http/http.dart';
import 'package:wifi_smart_living/const/const_api.dart';
import 'package:wifi_smart_living/const/const_json_identifier.dart';
import 'package:wifi_smart_living/core/map_helper/map_builder.dart';
import 'package:wifi_smart_living/http_helper/http_handler/https_request_helper.dart';
import 'package:wifi_smart_living/http_helper/http_header/http_header_helper.dart';
import 'package:wifi_smart_living/http_helper/uri_helper/uri_parser.dart';
import 'package:wifi_smart_living/models/accessToken/model_access_token.dart';
import 'package:wifi_smart_living/models/database/model_database_user.dart';

class UpdateSelfHelper {
  void updateSelf(
      {required ModelDatabaseUser user, required ModelAccessToken token}) {
    if (!user.isMultiUser) {
      UpdateSelfHelper().updateSelfMulti(token: token.tokenString);
    }
    if (!user.usedClient[ConstApi.currentAppCode]) {
      UpdateSelfHelper().updateSelfUsedClient(token: token.tokenString);
    }
  }

  Future<Response?> updateSelfMulti({required String token}) async {
    MapBuilder mapBuilder = MapBuilder();
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierMulti, value: true);
    Response? response = await HttpRequestHelper.putDatabaseEntries(
        apiFunction:
            await UriParser.createUri(apiFunction: ConstApi.updateSelfPut),
        httpHeader:
            await HttpHeaderHelper.createAccessTokenHeader(xaccesstoken: token),
        data: mapBuilder.getDynamicMap);

    return response;
  }

  Future<Response?> updateSelfUsedClient({required String token}) async {
    MapBuilder mapBuilder = MapBuilder();
    mapBuilder.addDynamicMapEntry(
        key: ConstJsonIdentifier.identifierUsedClient,
        value: <String, bool>{ConstApi.currentAppCode: true});
    Response? response = await HttpRequestHelper.putDatabaseEntries(
        apiFunction:
            await UriParser.createUri(apiFunction: ConstApi.updateSelfPut),
        httpHeader:
            await HttpHeaderHelper.createAccessTokenHeader(xaccesstoken: token),
        data: mapBuilder.getDynamicMap);

    return response;
  }
}
