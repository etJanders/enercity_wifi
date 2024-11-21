import 'package:http/http.dart';
import 'package:wifi_smart_living/api_handler/response_messages/api_message_response_helper.dart';
import 'package:wifi_smart_living/http_helper/http_handler/https_request_helper.dart';
import 'package:wifi_smart_living/http_helper/http_header/http_header_helper.dart';
import 'package:wifi_smart_living/http_helper/uri_helper/uri_parser.dart';
import 'package:wifi_smart_living/jsonParser/messageParser/http_message_parser.dart';
import 'package:wifi_smart_living/models/database/datenbank_models.dart';
import 'package:wifi_smart_living/models/database/model_to_list/database_model_to_list_helper.dart';

import 'package:wifi_smart_living/singelton/api_singelton.dart';

///Description
///Helper to update databaseentries
///
///Author: J. Anders
///created: 12-12-2022
///history: 12-12-2022
///
///History:
///
///Notes:
class UpdateDatabaseEntryHelper {
  Future<UpdateDatabaseState> updateDatabaseEntry(
      {required DatabaseModel model, required String api}) async {
    UpdateDatabaseState state = UpdateDatabaseState.entryNotFound;
    Response? response = await HttpRequestHelper.putDatabaseEntries(
        apiFunction: await UriParser.createUri(apiFunction: api),
        httpHeader: await HttpHeaderHelper.createAccessTokenHeader(
            xaccesstoken: ApiSingelton().getModelAccessToken.tokenString),
        data: model.toJson());
    if (response != null && response.statusCode == 200) {
      int messageId = ApiResponses()
          .getMessageCode(message: HttpMessageParser.getMessage(response));
      if (messageId == ApiResponses.noPermissionToUpdate) {
        state = UpdateDatabaseState.noPermissionToUpdate;
      } else if (messageId == ApiResponses.databaseEntrySuccesfulUpdated) {
        state = UpdateDatabaseState.updateSuccesfful;
      } else {
        state = UpdateDatabaseState.entryNotFound;
      }
    }
    return state;
  }

  Future<UpdateDatabaseState> updateDatabaseByList(
      {required List<DatabaseModel> databaseModels,
      required String api}) async {
    UpdateDatabaseState state = UpdateDatabaseState.entryNotFound;

    Response? response = await HttpRequestHelper.putDatabaseEntriesDynamic(
        apiFunction: await UriParser.createUri(apiFunction: api),
        httpHeader: await HttpHeaderHelper.createAccessTokenHeader(
            xaccesstoken: ApiSingelton().getModelAccessToken.tokenString),
        data: ModelToListHelper()
            .deviceprofileToList(deviceProfiles: databaseModels));
    if (response?.statusCode == 200) {
      //Todo wertde api response aus und gebe gegebenfalls fehler weiter
    }

    return state;
  }
}

enum UpdateDatabaseState {
  noPermissionToUpdate,
  entryNotFound,
  updateSuccesfful,
}
