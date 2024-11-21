import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:wifi_smart_living/api_handler/api_treiber/login/login_helper.dart';
import 'package:wifi_smart_living/connectivity/network_connection_helper.dart';
import 'package:wifi_smart_living/const/const_api.dart';
import 'package:wifi_smart_living/const/const_json_identifier.dart';
import 'package:wifi_smart_living/const/const_location.dart';
import 'package:wifi_smart_living/core/map_helper/map_builder.dart';
import 'package:wifi_smart_living/helper/init_heating_profile/init_heating_profile_helper.dart';
import 'package:wifi_smart_living/helper/sort_room_view/sort_room_ids.dart';
import 'package:wifi_smart_living/http_helper/http_handler/https_request_helper.dart';
import 'package:wifi_smart_living/http_helper/http_header/http_header_helper.dart';
import 'package:wifi_smart_living/http_helper/uri_helper/uri_parser.dart';
import 'package:wifi_smart_living/jsonParser/sync_data_parser/sync_data_parser.dart';
import 'package:wifi_smart_living/singelton/api_singelton.dart';
import 'package:wifi_smart_living/singelton/helper/api_singelton_helper.dart';
import 'package:wifi_smart_living/singelton/helper/change_room_ui_position.dart';
import 'package:wifi_smart_living/singelton/helper/mqtt_message_puffer.dart';
import 'package:wifi_smart_living/validation/accessTokenValidation/access_token_validation.dart';

import '../../../helper/userSpecificPopUpHelper/user_pop_up_helper.dart';
import '../cleanup_helper/cleanup_helper.dart';

///Description
///Call get all function to get all stored database values
///
///Author: J. Anders
///created: 13-12-2022
///changed: 10-01-2023
///
///History:
///10-01-2023: create heating profile structure if used
///Notes:
///
class DatabaseSync with ChangeNotifier {
  late DatabaseSyncState _databaseSyncState;

  ApiSingelton singelton = ApiSingelton();
  ApiSingeltonHelper helper = ApiSingeltonHelper();
  late RoomDragAndDropHelper dragAndDropHelper;
  final bool _showSyncAnimation = false;

  InitHeatingProfileHelper heatingProfileHelper = InitHeatingProfileHelper();

  Future<void> syncDatabase(String location) async {
    _databaseSyncState = DatabaseSyncState.syncInProgress;
    if (AccessTokenValidation(token: ApiSingelton().getModelAccessToken)
        .tokenNochValide()) {
      Response response = await HttpRequestHelper.postDatabaseEntries(
          apiFunction: await UriParser.createUri(
              apiFunction: ConstApi.getAllEntriesByLocationPost),
          httpHeader: await HttpHeaderHelper.createAccessTokenHeader(
              xaccesstoken: ApiSingelton().getModelAccessToken.tokenString),
          data: _getLocationData(location));


      if (response.statusCode == 200) {
        log(response.body);

        SyncState syncState =
            await SyncDataParser().parseData(responseBody: response.body);
        if (syncState == SyncState.parserError) {
          _databaseSyncState = DatabaseSyncState.parseError;
        } else {
          dragAndDropHelper = RoomDragAndDropHelper();
          if ((heatingProfileHelper.initHeatingProfiles() ||
              heatingProfileHelper.initHolidayProfiles()) && DataSyncHelper().dataSyncPerformed == false) {
            DataSyncHelper().dataSyncPerformed = true;
            await heatingProfileHelper.initTimeSchedules();
            await dragAndDropHelper.updateDatabaseIfNeeded();
            _databaseSyncState = DatabaseSyncState.initTimeSchedule;

          } else {
            await dragAndDropHelper.updateDatabaseIfNeeded();
            _databaseSyncState = DatabaseSyncState.syncSuccesfull;
          }
        }
      } else {
        _databaseSyncState = DatabaseSyncState.httpError;
      }
      MqttMessagePuffer().cleanPuffer();
      await CleanupHelper().addMissingRoomProfiles();
      await CleanupHelper().addMissingDeviceProfiles();
      await CleanupHelper().deleteDuplicateRoomProfile();
      await  CleanupHelper().deleteDuplicateDeviceProfile();
      notifyListeners();
    } else {
      if (await NetworkStateHelper.networkConnectionEstablished()) {
        LoginHelper loginHelper = LoginHelper();
        LoginHelperState state = await loginHelper.databaseLogin(
            userName: ApiSingelton().getDatabaseUserModel.userMailAdress,
            userPassword: ApiSingelton().getDatabaseUserModel.userPassowrd);
        if (state == LoginHelperState.tokenErmittelt) {
          syncDatabase(location);
        } else if (state == LoginHelperState.zugangsdatenFalsch) {
          _databaseSyncState = DatabaseSyncState.credentialsWrong;
          notifyListeners();
        } else {
          _databaseSyncState = DatabaseSyncState.getAccessTokenError;
          notifyListeners();
        }
      } else {
        _databaseSyncState = DatabaseSyncState.noInternetConnection;
        notifyListeners();
      }
    }
    //start sync again to determeine time schedule information
    if (_databaseSyncState == DatabaseSyncState.initTimeSchedule) {
      _databaseSyncState = DatabaseSyncState.syncInProgress;
      syncDatabase(location);
    }
  }


  Future<void> fetchPopUpValues() async {
    _databaseSyncState = DatabaseSyncState.syncInProgress;
    if (AccessTokenValidation(token: ApiSingelton().getModelAccessToken)
        .tokenNochValide()) {
      Response response = await HttpRequestHelper.getDatabaseEntries(
          apiFunction: await UriParser.createUri(
              apiFunction: ConstApi.checkUserSpecificPopup),
          httpHeader: await HttpHeaderHelper.createAccessTokenHeader(
              xaccesstoken: ApiSingelton().getModelAccessToken.tokenString),
          );


      if (response.statusCode == 200) {
        print(response.body);
        final parsedJson = jsonDecode(response.body);
        var popUpHelper = PopUpHelper();
        popUpHelper.popUpStatus = parsedJson["popup"][0]["display"] ?? '';
        popUpHelper.messageEnglish = parsedJson["popup"][0]["message"] ?? '';
        popUpHelper.messageGerman = parsedJson["popup"][0]["message_de"] ?? '';
        popUpHelper.titleEnglish = parsedJson["popup"][0]["title"] ?? '';
        popUpHelper.titleGerman = parsedJson["popup"][0]["title_de"] ?? '';
      }
    }
  }






  Map<String, dynamic> _getLocationData(String location) {
    MapBuilder mapBuilder = MapBuilder();
    if (location == ConstLocationidentifier.locationidentifierIndoor ||
        location == ConstLocationidentifier.locationidentifierOutdoor) {
      mapBuilder.addDynamicMapEntry(
          key: ConstJsonIdentifier.identifierLocation, value: location);
    }
    return mapBuilder.getDynamicMap;
  }

  void updateRoomUiPosition(int oldIndex, int newIndex) async {
    ChangeUIPositionHelper().changeRoomPosition(oldIndex, newIndex);
    notifyListeners();
  }

  DatabaseSyncState get getDatabaseSyncState => _databaseSyncState;

  bool get getSyncAnimationState => _showSyncAnimation;
}



enum DatabaseSyncState {
  noInternetConnection,
  getAccessTokenError,
  syncInProgress,
  syncSuccesfull,
  initTimeSchedule,
  parseError,
  httpError,
  credentialsWrong,
}
