import 'package:wifi_smart_living/const/const_api.dart';
import 'package:wifi_smart_living/device_specification/thermostat_interface.dart';
import 'package:wifi_smart_living/http_helper/http_handler/https_request_helper.dart';
import 'package:wifi_smart_living/http_helper/http_header/http_header_helper.dart';
import 'package:wifi_smart_living/http_helper/uri_helper/uri_parser.dart';
import 'package:wifi_smart_living/models/database/model_room_profile.dart';
import 'package:wifi_smart_living/singelton/api_singelton.dart';
import 'package:wifi_smart_living/singelton/helper/api_singelton_helper.dart';

class ResetHeatingProfileHelper {
  Future<void> resetHeatingProfiles({required String smPublicId}) async {
    List<String> profileIds = ApiSingeltonHelper()
        .getGroupIdsFromHeatingProfile(smPublicId: smPublicId);

    for (int i = 0; i < profileIds.length; i++) {
      List<ModelRoomProfile> profiles = getRoomProfiles(profileIds[i]);
      await Future.forEach(profiles, (element) async {
        await HttpRequestHelper.putDatabaseEntries(
            apiFunction: await UriParser.createUri(
                apiFunction: ConstApi.updateRoomProfilePut),
            httpHeader: await HttpHeaderHelper.createAccessTokenHeader(
                xaccesstoken: ApiSingelton().getModelAccessToken.tokenString),
            data: element.toJson());
      });
    }
  }

  Future<void> resetHolidayProfiles({required String smPublicId}) async {
    List<String> profileIds = ApiSingeltonHelper()
        .getGroupIdsFromHeatingProfile(smPublicId: smPublicId);

    for (int i = 0; i < profileIds.length; i++) {
      List<ModelRoomProfile> profiles = getHolidayRoomProfiles(profileIds[i]);
      await Future.forEach(profiles, (element) async {
        await HttpRequestHelper.putDatabaseEntries(
            apiFunction: await UriParser.createUri(
                apiFunction: ConstApi.updateRoomProfilePut),
            httpHeader: await HttpHeaderHelper.createAccessTokenHeader(
                xaccesstoken: ApiSingelton().getModelAccessToken.tokenString),
            data: element.toJson());
      });
    }
  }

  Future<void> resetSingleHeatingProfiles({required String smPublicId,required String groupId}) async {
      List<ModelRoomProfile> profiles = getRoomProfiles(groupId);
      await Future.forEach(profiles, (element) async {
        await HttpRequestHelper.putDatabaseEntries(
            apiFunction: await UriParser.createUri(
                apiFunction: ConstApi.updateRoomProfilePut),
            httpHeader: await HttpHeaderHelper.createAccessTokenHeader(
                xaccesstoken: ApiSingelton().getModelAccessToken.tokenString),
            data: element.toJson());
      });
  //  }
  }

  Future<void> resetSingleHolidayProfiles({required String smPublicId,required String groupId}) async {
    List<ModelRoomProfile> profiles = getHolidayRoomProfiles(groupId);
    await Future.forEach(profiles, (element) async {
      await HttpRequestHelper.putDatabaseEntries(
          apiFunction: await UriParser.createUri(
              apiFunction: ConstApi.updateRoomProfilePut),
          httpHeader: await HttpHeaderHelper.createAccessTokenHeader(
              xaccesstoken: ApiSingelton().getModelAccessToken.tokenString),
          data: element.toJson());
    });
    //  }
  }

  Future<void> resetHolidayprofile({required String smPublicId}) async {
    List<String> profileIds = ApiSingeltonHelper()
        .getGroupIdsFromHeatingProfile(smPublicId: smPublicId);
    for (int i = 0; i < profileIds.length; i++) {
      ModelRoomProfile holidayProfile = ApiSingeltonHelper().getRoomProfile(
          groupId: profileIds[i],
          profileIdentifier: ThermostatInterface.holidayProfile);
      holidayProfile.profileValue = "#";
      await HttpRequestHelper.putDatabaseEntries(
          apiFunction: await UriParser.createUri(
              apiFunction: ConstApi.updateRoomProfilePut),
          httpHeader: await HttpHeaderHelper.createAccessTokenHeader(
              xaccesstoken: ApiSingelton().getModelAccessToken.tokenString),
          data: holidayProfile.toJson());
    }
  }

  List<ModelRoomProfile> getRoomProfiles(String groupId) {
    List<ModelRoomProfile> list =
        ApiSingeltonHelper().getHeatingProfile(groupId);
    for (int i = 0; i < list.length; i++) {
      list[i].profileValue = '#';
    }
    return list;
  }

  List<ModelRoomProfile> getHolidayRoomProfiles(String groupId) {
    List<ModelRoomProfile> list =
    ApiSingeltonHelper().getHolidayProfileExisting(groupId);
    for (int i = 0; i < list.length; i++) {
      list[i].profileValue = '#';
    }
    return list;
  }
}
