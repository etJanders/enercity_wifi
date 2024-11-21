import 'package:mqtt_client/mqtt_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wifi_smart_living/helper/userSpecificPopUpHelper/user_pop_up_helper.dart';
import 'package:wifi_smart_living/singelton/api_singelton.dart';
import 'package:wifi_smart_living/singelton/mqtt_singelton.dart';
import 'package:wifi_smart_living/storage_helper/secured_storage_helper.dart';

import '../../const/const_sharedpreference_storage.dart';

///Description
///Handle Logout event
///
///Author: J. Anders
///created: 30-11-2022
///changed: 13-03-2023
///
///History:
///13-03-2023: Close MQTT Connection if connection is established
///
///Motes:
///
class LogoutHelper {
  ApiSingelton apiSingelton = ApiSingelton();
  MqttSingelton mqttSingelton = MqttSingelton();
  final Function logoutCallback;

  LogoutHelper({required this.logoutCallback});

  void logoutHandler() {
    _cleanSingelton();
    _trenneMqttConnection();
    removeAllEnries();
    SecuredStorageHelper().removeAllEnries().then((value) => logoutCallback());
  }

  void _cleanSingelton() {
    apiSingelton.deleteSingeltonData();
    DataSyncHelper().dataSyncPerformed = false;
  }

  void _trenneMqttConnection() {
    MqttConnectionState state = mqttSingelton.getMqttConnectionSate();
    if (state == MqttConnectionState.connected) {
      mqttSingelton.closeMqttConnection();
    }
  }

  removeAllEnries() async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool(ConstSharedPreferenceNames.keySpecific, false);
    PopUpHelper().popUpDisplayStatus=true;
  }
}
