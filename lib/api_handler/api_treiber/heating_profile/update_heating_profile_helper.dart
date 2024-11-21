import 'package:wifi_smart_living/api_handler/api_treiber/login/login_helper.dart';
import 'package:wifi_smart_living/connectivity/network_connection_helper.dart';
import 'package:wifi_smart_living/const/const_api.dart';
import 'package:wifi_smart_living/device_specification/thermostat_interface.dart';
import 'package:wifi_smart_living/http_helper/http_handler/https_request_helper.dart';
import 'package:wifi_smart_living/http_helper/http_header/http_header_helper.dart';
import 'package:wifi_smart_living/http_helper/uri_helper/uri_parser.dart';
import 'package:wifi_smart_living/models/database/model_room_profile.dart';
import 'package:wifi_smart_living/singelton/api_singelton.dart';
import 'package:wifi_smart_living/singelton/helper/api_singelton_helper.dart';
import 'package:wifi_smart_living/validation/accessTokenValidation/access_token_validation.dart';

class UpdateTimeScheduleHelper {
  Future<UpdateTimeScheduleState> updateTimeScheduleProfile(
      {required List<String> groupIds,
      required Map<String, String> profileData}) async {
    //Daten werden korrekt hier uebergeben aber beim Updaten falsch
    UpdateTimeScheduleState state = UpdateTimeScheduleState.networkerror;
    if (await NetworkStateHelper.networkConnectionEstablished()) {
      if (AccessTokenValidation(token: ApiSingelton().getModelAccessToken)
          .tokenNochValide()) {
        for (int i = 0; i < groupIds.length; i++) {
          List<ModelRoomProfile> roomProfileList =
              roomProfile(groupIds[i], profileData);
          await Future.forEach(roomProfileList, (element) async {
            await HttpRequestHelper.putDatabaseEntries(
                apiFunction: await UriParser.createUri(
                    apiFunction: ConstApi.updateRoomProfilePut),
                httpHeader: await HttpHeaderHelper.createAccessTokenHeader(
                    xaccesstoken:
                        ApiSingelton().getModelAccessToken.tokenString),
                data: element.toJson());
          });
        }
        state = UpdateTimeScheduleState.allEntiresUpdated;
      } else {
        LoginHelperState loginHelperState = await LoginHelper().databaseLogin(
            userName: ApiSingelton().getDatabaseUserModel.userMailAdress,
            userPassword: ApiSingelton().getDatabaseUserModel.userPassowrd);

        if (loginHelperState == LoginHelperState.tokenErmittelt) {
          updateTimeScheduleProfile(
              groupIds: groupIds, profileData: profileData);
        } else {
          state = UpdateTimeScheduleState.networkerror;
        }
      }
    }
    return state;
  }

  Future<UpdateTimeScheduleState> updateHolidayProfile(
      {required List<String> groupIds, required String profileValue}) async {
    //Daten werden korrekt hier uebergeben aber beim Updaten falsch
    UpdateTimeScheduleState state = UpdateTimeScheduleState.networkerror;
    if (await NetworkStateHelper.networkConnectionEstablished()) {
      if (AccessTokenValidation(token: ApiSingelton().getModelAccessToken)
          .tokenNochValide()) {
        for (int i = 0; i < groupIds.length; i++) {
          ModelRoomProfile roomProfileList =
              holidayProfile(groupIds[i], profileValue);
          await HttpRequestHelper.putDatabaseEntries(
              apiFunction: await UriParser.createUri(
                  apiFunction: ConstApi.updateRoomProfilePut),
              httpHeader: await HttpHeaderHelper.createAccessTokenHeader(
                  xaccesstoken: ApiSingelton().getModelAccessToken.tokenString),
              data: roomProfileList.toJson());
        }
        state = UpdateTimeScheduleState.allEntiresUpdated;
      } else {
        LoginHelperState loginHelperState = await LoginHelper().databaseLogin(
            userName: ApiSingelton().getDatabaseUserModel.userMailAdress,
            userPassword: ApiSingelton().getDatabaseUserModel.userPassowrd);

        if (loginHelperState == LoginHelperState.tokenErmittelt) {
          updateHolidayProfile(groupIds: groupIds, profileValue: profileValue);
        } else {
          state = UpdateTimeScheduleState.networkerror;
        }
      }
    }
    return state;
  }

  List<ModelRoomProfile> roomProfile(String groupId, Map<String, String> data) {
    List<ModelRoomProfile> list =
        ApiSingeltonHelper().getHeatingProfile(groupId);
    for (int i = 0; i < list.length; i++) {
      list[i].profileValue = data[list[i].profileId]!;
    }
    return list;
  }

  List<ModelRoomProfile> roomHolidayProfile(String groupId, Map<String, String> data) {
    List<ModelRoomProfile> list =
    ApiSingeltonHelper().getHolidayProfileExisting(groupId);
    for (int i = 0; i < list.length; i++) {
      list[i].profileValue = data[list[i].profileId]!;
    }
    return list;
  }

  ModelRoomProfile holidayProfile(String groupId, String value) {
    ModelRoomProfile profile = ApiSingeltonHelper().getRoomProfile(
        groupId: groupId,
        profileIdentifier: ThermostatInterface.holidayProfile);
    profile.profileValue = value;
    return profile;
  }
}

enum UpdateTimeScheduleState {
  noInternetConnection,
  networkerror,
  allEntiresUpdated,
}
