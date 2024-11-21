// class AddNewDeviceHelper {
//   bool popUpSatus  = true;
// }

class PopUpHelper {
  static final PopUpHelper _singleton = PopUpHelper._internal();

  factory PopUpHelper() {
    return _singleton;
  }

  PopUpHelper._internal();
  bool popUpStatus  = false;
  bool popUpDisplayStatus = true;
  String titleGerman = "";
  String titleEnglish = "";
  String messageGerman = "";
  String messageEnglish = "";
  bool statusIntermediateCheckbox = false;
}


class DataSyncHelper {
  static final DataSyncHelper _singleton = DataSyncHelper._internal();

  factory DataSyncHelper() {
    return _singleton;
  }

  DataSyncHelper._internal();
  bool dataSyncPerformed  = false;

}