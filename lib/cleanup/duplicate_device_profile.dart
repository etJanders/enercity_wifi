import '../models/database/model_device_profile.dart';

class DuplicateDeviceProfiles {
  final List<String> profileValueList = ["A2", "A3", "A5", "B0"];
  late List<ModelDeviceProfile> determinedDeviceProfiles = [];
  late String detectedMacId = '';
  late List<ModelDeviceProfile> IDsDeviceProfile = [];
  late List<ModelDeviceProfile> IDsBasedDeviceProfile = [];
  DuplicateDeviceProfiles(
      List<ModelDeviceProfile> deviceProfile, String macId) {
    determinedDeviceProfiles = deviceProfile;
    detectedMacId = macId;
    _checkDuplicateModels();
    // _buildDefaultModels();
  }

  //Pruefe welche Daten fehlen
  void _checkDuplicateModels() {
    for (int j = 0; j < profileValueList.length; j++) {
      IDsBasedDeviceProfile = determinedDeviceProfiles
          .where((element) => element.profileId == profileValueList[j])
          .toList(); //step 2 :Extract specific value vbased profiles only
      int originalLength = IDsBasedDeviceProfile.length;

      if (IDsBasedDeviceProfile.length > 1) {
        int i = 0;
        for (i = 0; i < IDsBasedDeviceProfile.length; i++) {
          if (IDsBasedDeviceProfile[i].profileValue != "#") {
            // If there exists any non # values for profile ID, we remove that from list of IDsBasedRoomProfile
            IDsBasedDeviceProfile.remove(IDsBasedDeviceProfile[i]);

            break;
          }
        }
        if (originalLength == IDsBasedDeviceProfile.length) {
          IDsBasedDeviceProfile.remove(IDsBasedDeviceProfile[
              0]); // In case, where were #, then we remove the very first element from the list, n retain the rest
          //Note: The retained values will be deleted later to ensure no duplication.
        }
        IDsDeviceProfile.addAll(IDsBasedDeviceProfile);
      }
    }
  }

  List<ModelDeviceProfile> get getMissingModels => IDsDeviceProfile;
}
