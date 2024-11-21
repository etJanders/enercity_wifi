import '../models/database/model_room_profile.dart';

class DuplicateRoomProfiles {
  final List<String> profileValueList = ["A0","A3","A5","A7","A8","A9","AA","AB","AC","AD","AE","B0"];

  late List<ModelRoomProfile> determinedRoomProfiles = [];
  late String detectedGroupId = '';
  late  List<ModelRoomProfile> IDsRoomProfile = [];
  late  List<ModelRoomProfile> IDsBasedRoomProfile = [];
  DuplicateRoomProfiles(List<ModelRoomProfile> roomProfile, String groupId) {
    determinedRoomProfiles = roomProfile;
    detectedGroupId = groupId;
    _checkDuplicateModels();
  }

  //Pruefe welche Daten fehlen
  void _checkDuplicateModels() {
    for (int j = 0; j < profileValueList.length; j++) {
      IDsBasedRoomProfile = determinedRoomProfiles.where((element) => element.profileId == profileValueList[j]).toList();//step 2 :Extract specific value vbased profiles only
     int originalLength = IDsBasedRoomProfile.length;
      if(IDsBasedRoomProfile.length>1){
        int i = 0;
        for(i = 0;i< IDsBasedRoomProfile.length;i++){

          if(IDsBasedRoomProfile[i].profileValue != "#"){// IF there exists any non # values for profile ID, we remove that from list of IDsBasedRoomProfile
            IDsBasedRoomProfile.remove(IDsBasedRoomProfile[i]);

            break;
          }
        }
        if(originalLength == IDsBasedRoomProfile.length){
          IDsBasedRoomProfile.remove(IDsBasedRoomProfile[0]);// In case, where were #, then we remove the very first element from the list, n retain the rest
          //Note: The retained values will be deleted later to ensure
        }
        IDsRoomProfile.addAll(IDsBasedRoomProfile);
      }
    }
  }

  List<ModelRoomProfile> get getMissingModels => IDsRoomProfile;
}
