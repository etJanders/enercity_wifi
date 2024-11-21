import 'package:wifi_smart_living/const/const_api.dart';
import 'package:wifi_smart_living/core/randomNumberGenerator/random_number_helper.dart';
import 'package:wifi_smart_living/storage_helper/secured_storage_helper.dart';

///Description
///As failover there are two database instances. Bothe database instanes are
///syncrone. So it does no matter whith which instance the app works.
///This class helps do detect a base database url and helps to switch the url
///if something went wrong.
///
///For loadbalancing thes app starts on different apis
///
///
///Author: J. Anders
///created: 30-11-2022
///changed: 30-11-2022
///
///History:
///
///Notes:
class ApiUrlHelper {
  static const String _securedStorageBaseUrlIdentifier = "defaultUrl";
  static const String _securedStoreageUrlInUse = "usedUrl";

  final SecuredStorageHelper helper = SecuredStorageHelper();

  Future<String> getDefaultUrl() async {
    String defaulUrl = await helper.readSecuredStorageData(
        key: _securedStorageBaseUrlIdentifier);
    if (defaulUrl.isEmpty) {
      defaulUrl = await _initStartUrl();
    }
    return defaulUrl;
  }

  //Switch Url if default sotred default url not working
  Future<String> setUseableUrl(bool toDefault) async {
    String defualtUrl;
    if (toDefault) {
      defualtUrl = await getDefaultUrl();
      _saveUrl(idenfifier: _securedStoreageUrlInUse, url: defualtUrl);
    } else {
      defualtUrl = await getDefaultUrl();
      if (defualtUrl == ConstApi.defaultUrl) {
        defualtUrl = ConstApi.secondUrl;
        _saveUrl(idenfifier: _securedStoreageUrlInUse, url: ConstApi.secondUrl);
      } else {
        defualtUrl = ConstApi.defaultUrl;
        _saveUrl(
            idenfifier: _securedStoreageUrlInUse, url: ConstApi.defaultUrl);
      }
    }
    return defualtUrl;
  }

  Future<String> urlToUse() async {
    return await helper.readSecuredStorageData(key: _securedStoreageUrlInUse);
  }

  ///Hilfsfunktion, um Daten im Speicher abzulegen
  ///Auxiliary function to store data in memory
  Future<void> _saveUrl(
      {required String idenfifier, required String url}) async {
    await helper.storeData(key: idenfifier, value: url);
  }

  //Initialisiere die Start Url
  //Initialize the start url
  Future<String> _initStartUrl() async {
    String defaultUrl = _setDefaultUrl();
    _saveUrl(idenfifier: _securedStorageBaseUrlIdentifier, url: defaultUrl);
    _saveUrl(idenfifier: _securedStoreageUrlInUse, url: defaultUrl);
    return defaultUrl;
  }

  /*  
  Initialize the start url is used for api communication

  */
  String _setDefaultUrl() {
    String startUrl = "";
    int randomNumber =
        GenerateRandomNumber.generateRandomNumber(min: 0, max: 10);
    if (randomNumber % 2 == 0) {
      startUrl = ConstApi.defaultUrl;
    } else {
      startUrl = ConstApi.secondUrl;
    }
    return startUrl;
  }
}
