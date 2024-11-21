import 'package:wifi_smart_living/models/database/model_device_profile.dart';
import 'package:wifi_smart_living/singelton/helper/api_singelton_helper.dart';
import '../../../cleanup/duplicate_device_profile.dart';
import '../../../cleanup/duplicate_room_profile.dart';
import '../../../cleanup/missing_device_profiles.dart';
import '../../../cleanup/missing_room_profiles.dart';
import '../../../connectivity/network_connection_helper.dart';
import '../../../const/const_api.dart';
import '../../../http_helper/http_handler/https_request_helper.dart';
import '../../../http_helper/http_header/http_header_helper.dart';
import '../../../http_helper/uri_helper/uri_parser.dart';
import '../../../models/database/model_room_profile.dart';
import '../../../singelton/api_singelton.dart';
import '../../../validation/accessTokenValidation/access_token_validation.dart';
import '../login/login_helper.dart';

class CleanupHelper {

  Future<void>  addMissingRoomProfiles()async {
    List<String> groupIds = ApiSingeltonHelper().getAllGroupIds();
    for(int i = 0; i< groupIds.length;i++){
      List<ModelRoomProfile> profiles= ApiSingeltonHelper().getRoomProfileByGroupID(groupId: groupIds[i]);
      var missingModels = MissingRoomProfiles(profiles,groupIds[i]).getMissingModels;

     if(missingModels.isNotEmpty){
       for(int j = 0; j< missingModels.length;j++){
         createMissingRoomProfiles(missingModels[j]);

       }
     }
    }

  }
  Future<void>  addMissingDeviceProfiles()async {
    List<String> MACIds = ApiSingeltonHelper().getAllMacIds();
    for(int i = 0; i< MACIds.length;i++){
      List<ModelDeviceProfile> profiles= ApiSingeltonHelper().getDeviceProfileByMACID(macID: MACIds[i]);
      var missingModels = MissingDeviceProfiles(deviceMacAdress: MACIds[i], storedDeviceProfiles: profiles).getMissingModles;
      if(missingModels.isNotEmpty){
        for(int j = 0; j< missingModels.length;j++) {
          createMissingDeviceProfiles(missingModels[j]);
        }
      }
    }

  }
  Future<void> deleteDuplicateRoomProfile() async {
    List<String> groupIds = ApiSingeltonHelper().getAllGroupIds();
    for(int i = 0; i< groupIds.length;i++){
      List<ModelRoomProfile> profiles= ApiSingeltonHelper().getRoomProfileByGroupIDs(groupId: groupIds[i]);
      var missingModels = DuplicateRoomProfiles(profiles,groupIds[i]).getMissingModels;
      if(missingModels.isNotEmpty){
        for(int j = 0; j< missingModels.length;j++){
          deleteMissingRoomProfiles(missingModels[j]);

        }
      }
    }
  }
  Future<void> deleteDuplicateDeviceProfile()async {
    List<String> macIds = ApiSingeltonHelper().getAllMacIds();
    for(int i = 0; i< macIds.length;i++){
      List<ModelDeviceProfile> profiles= ApiSingeltonHelper().getDeviceProfileByGroupIDs(macId: macIds[i]);
      var missingModels = DuplicateDeviceProfiles(profiles,macIds[i]).getMissingModels;
      if(missingModels.isNotEmpty){
        for(int j = 0; j< missingModels.length;j++){
          deleteMissingDeviceProfiles(missingModels[j]);
        }
      }else{


      }
    }
  }

  Future<CleanupHelperState> createMissingRoomProfiles(CleanUpModelRoomProfile missingModels) async {
    CleanupHelperState state = CleanupHelperState.noInternetConnection;
    if (await NetworkStateHelper.networkConnectionEstablished()) {
      if (AccessTokenValidation(token: ApiSingelton().getModelAccessToken)
          .tokenNochValide()) {
         await HttpRequestHelper.postDatabaseEntries(
            apiFunction: await UriParser.createUri(
                apiFunction: ConstApi.createRoomProfilePost),
            httpHeader: await HttpHeaderHelper.createAccessTokenHeader(
                xaccesstoken: ApiSingelton().getModelAccessToken.tokenString),
            data: missingModels.toJson());
      } else {
        LoginHelperState loginHelperState = await LoginHelper().databaseLogin(
            userName: ApiSingelton().getDatabaseUserModel.userMailAdress,
            userPassword: ApiSingelton().getDatabaseUserModel.userPassowrd);
        if (loginHelperState == LoginHelperState.tokenErmittelt) {
          createMissingRoomProfiles(missingModels);
        } else if (loginHelperState == LoginHelperState.zugangsdatenFalsch) {
          state = CleanupHelperState.userCredentialsChanged;
        } else {
          state = CleanupHelperState.unknownError;
        }
      }
    }

    return state;
  }



  Future<CleanupHelperState> deleteMissingRoomProfiles(ModelRoomProfile missingModels) async {
    CleanupHelperState state = CleanupHelperState.noInternetConnection;
    if (await NetworkStateHelper.networkConnectionEstablished()) {
      if (AccessTokenValidation(token: ApiSingelton().getModelAccessToken)
          .tokenNochValide()) {
        await HttpRequestHelper.deletedatabaseEntries(
            apiFunction: await UriParser.createUri(
                apiFunction: ConstApi.deleteRoomProfileDel),
            httpHeader: await HttpHeaderHelper.createAccessTokenHeader(
                xaccesstoken: ApiSingelton().getModelAccessToken.tokenString),
            data: missingModels.toDeleteFunctionJson());
      } else {
        LoginHelperState loginHelperState = await LoginHelper().databaseLogin(
            userName: ApiSingelton().getDatabaseUserModel.userMailAdress,
            userPassword: ApiSingelton().getDatabaseUserModel.userPassowrd);
        if (loginHelperState == LoginHelperState.tokenErmittelt) {
          deleteMissingRoomProfiles(missingModels);
        } else if (loginHelperState == LoginHelperState.zugangsdatenFalsch) {
          state = CleanupHelperState.userCredentialsChanged;
        } else {
          state = CleanupHelperState.unknownError;
        }
      }
    }

    return state;
  }


  Future<CleanupHelperState> createMissingDeviceProfiles(CleanUpModelDeviceProfile missingModels) async {
    CleanupHelperState state = CleanupHelperState.noInternetConnection;
    if (await NetworkStateHelper.networkConnectionEstablished()) {
      if (AccessTokenValidation(token: ApiSingelton().getModelAccessToken)
          .tokenNochValide()) {
        await HttpRequestHelper.postDatabaseEntries(
            apiFunction: await UriParser.createUri(
                apiFunction: ConstApi.createDeviceProfilePost),
            httpHeader: await HttpHeaderHelper.createAccessTokenHeader(
                xaccesstoken: ApiSingelton().getModelAccessToken.tokenString),
            data: missingModels.toJson());
        }
       else {
        LoginHelperState loginHelperState = await LoginHelper().databaseLogin(
            userName: ApiSingelton().getDatabaseUserModel.userMailAdress,
            userPassword: ApiSingelton().getDatabaseUserModel.userPassowrd);
        if (loginHelperState == LoginHelperState.tokenErmittelt) {
          createMissingDeviceProfiles(missingModels);
        } else if (loginHelperState == LoginHelperState.zugangsdatenFalsch) {
          state = CleanupHelperState.userCredentialsChanged;
        } else {
          state = CleanupHelperState.unknownError;
        }
      }
    }

    return state;
  }


  Future<CleanupHelperState> deleteMissingDeviceProfiles(ModelDeviceProfile missingModels) async {
    CleanupHelperState state = CleanupHelperState.noInternetConnection;
    if (await NetworkStateHelper.networkConnectionEstablished()) {
      if (AccessTokenValidation(token: ApiSingelton().getModelAccessToken)
          .tokenNochValide()) {
        await HttpRequestHelper.deletedatabaseEntries(
            apiFunction: await UriParser.createUri(
                apiFunction: ConstApi.deleteDeviceProfileDel),
            httpHeader: await HttpHeaderHelper.createAccessTokenHeader(
                xaccesstoken: ApiSingelton().getModelAccessToken.tokenString),
            data: missingModels.toDeleteFunctionJson());
      } else {
        LoginHelperState loginHelperState = await LoginHelper().databaseLogin(
            userName: ApiSingelton().getDatabaseUserModel.userMailAdress,
            userPassword: ApiSingelton().getDatabaseUserModel.userPassowrd);
        if (loginHelperState == LoginHelperState.tokenErmittelt) {
          deleteMissingDeviceProfiles(missingModels);
        } else if (loginHelperState == LoginHelperState.zugangsdatenFalsch) {
          state = CleanupHelperState.userCredentialsChanged;
        } else {
          state = CleanupHelperState.unknownError;
        }
      }
    }

    return state;
  }


}

enum CleanupHelperState {
  noInternetConnection,
  unknownError,
  successful,
  databaseProblem,
  serviceLevelProblem,
  userCredentialsChanged,
  tokenAbgelaufen

}
