import 'package:wifi_smart_living/const/const_mqtt.dart';
import 'package:wifi_smart_living/singelton/api_singelton.dart';

import '../../storage_helper/secured_storage_helper.dart';

///Description
///Determine the base url for mqtt broker and help to switch to second url if
///default url is not reachabel
///
///Author: J. Anders
///created: 07-12-2022
///changed: 07-12-2022
///
///History:
///
///Nodes:
class BrokerUrlHelper {
  static const String _securedStorageBaseBrokerUrlIdentifier =
      "defaultBrokerUrl";

  final SecuredStorageHelper helper = SecuredStorageHelper();

  Future<String> getDefaultUrl() async {
    String defaulUrl = await helper.readSecuredStorageData(
        key: _securedStorageBaseBrokerUrlIdentifier);
    if (defaulUrl.isEmpty) {
      defaulUrl = await _initStartUrl();
    }
    return defaulUrl;
  }

  Future<void> clearDefaultUrl() async {
    await helper.storeData(
      key: _securedStorageBaseBrokerUrlIdentifier,
      value: "",
    );
  }

  Future<String> _initStartUrl() async {
    String defaultUrl = _setDefaultUrl();
    _saveUrl(
        idenfifier: _securedStorageBaseBrokerUrlIdentifier, url: defaultUrl);
    return defaultUrl;
  }

  //Hilfsfunktion, um Daten im Speicher abzulegen
  Future<void> _saveUrl(
      {required String idenfifier, required String url}) async {
    await helper.storeData(key: idenfifier, value: url);
  }

  String _setDefaultUrl() {
    String brokerUrlNumber;
    String brokerNumber = ApiSingelton().getDatabaseUserModel.broker;
    if (brokerNumber == ConstMqtt.defaultBrokerNumber) {
      brokerUrlNumber = "";
    } else {
      brokerUrlNumber = ((int.parse(brokerNumber) - 3) * 4).toString();
    }
    return ConstMqtt.brokerUrlStart + brokerUrlNumber + ConstMqtt.brokerUrlEnd;
  }

  // switchbrokenUrl function enables the user to switch between two broken urls.
  // Future<String> switchbrokerUrl({required String usedUrl}) async {
  //   String switchedUrl = "";
  //   if (usedUrl == ConstMqtt.firstBrokerUrl) {
  //     switchedUrl = ConstMqtt.secondBrokerUrl;
  //   } else {
  //     switchedUrl = ConstMqtt.firstBrokerUrl;
  //   }
  //   return switchedUrl;
  // }
}
