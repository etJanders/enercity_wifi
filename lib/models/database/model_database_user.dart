import 'package:wifi_smart_living/const/const_json_identifier.dart';
import 'package:wifi_smart_living/models/database/datenbank_models.dart';

import '../../core/map_helper/map_builder.dart';

///Description
///Define all Attributes are userd for user management
///
///Author: J. Anders
///created: 29-11-2022
///changed: 29-11-2022
///
///History:
///
///Notes:
///
class ModelDatabaseUser extends DatabaseModel {
  String userMailAdress;
  String userPassowrd;
  final String mqttUserName;
  final String mqttUserPassword;
  final bool updateMail;
  final bool betaUser;
  bool notification;
  final String broker;
  final bool isMultiUser;
  final Map<String, dynamic> usedClient;

  ModelDatabaseUser(
      {required super.entryPublicId,
      required this.userMailAdress,
      required this.userPassowrd,
      required this.mqttUserName,
      required this.mqttUserPassword,
      required this.updateMail,
      required this.betaUser,
      required this.notification,
      required this.broker,
      required this.isMultiUser,
      required this.usedClient});

  factory ModelDatabaseUser.fromJson(
      {required Map<String, dynamic> rawData, required String password}) {
    if (rawData[ConstJsonIdentifier.identifierUsedClient].runtimeType == List) {
      rawData[ConstJsonIdentifier.identifierUsedClient] = <String, bool>{
        'EC': false,
        'ET': false,
        'VM': false,
      };
    }
    return ModelDatabaseUser(
        entryPublicId: rawData[ConstJsonIdentifier.identifierUserPublicId],
        userMailAdress: rawData[ConstJsonIdentifier.identifierUserMail],
        userPassowrd: password,
        mqttUserName: rawData[ConstJsonIdentifier.identifierMqttUserName],
        mqttUserPassword:
            rawData[ConstJsonIdentifier.identifierMqttuserPassword],
        updateMail: rawData[ConstJsonIdentifier.identifierNewMail],
        betaUser: rawData[ConstJsonIdentifier.identifierBeta],
        notification: rawData[ConstJsonIdentifier.identifierNotification],
        broker: rawData[ConstJsonIdentifier.identifierBroker],
        isMultiUser: rawData[ConstJsonIdentifier.identifierMulti],
        usedClient: rawData[ConstJsonIdentifier.identifierUsedClient]);
  }

  @override
  Map<String, dynamic> toJson() {
    MapBuilder mapBuilder = MapBuilder();
    return mapBuilder.getStringMap;
  }
}
