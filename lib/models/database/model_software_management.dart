import 'package:wifi_smart_living/const/const_json_identifier.dart';

class ModelSoftwareManagement {
  final String deviceType;
  final String radioModuleVersion;
  final String baseSoftwareVersion;
  final String rtosSoftwareFile;
  final String slibSoftwareFile;
  final String baseVersionSoftwareFile;

  ModelSoftwareManagement(
      {required this.deviceType,
      required this.radioModuleVersion,
      required this.baseSoftwareVersion,
      required this.rtosSoftwareFile,
      required this.slibSoftwareFile,
      required this.baseVersionSoftwareFile});

  factory ModelSoftwareManagement.fromJson(
      Map<String, dynamic> rawData, String deviceType) {
    return ModelSoftwareManagement(
        deviceType: deviceType,
        radioModuleVersion: rawData[ConstJsonIdentifier.identifierRadioVersion],
        baseSoftwareVersion: rawData[ConstJsonIdentifier.identifierBaseVersion],
        rtosSoftwareFile: rawData[ConstJsonIdentifier.identifierWebLinkRtos],
        slibSoftwareFile: rawData[ConstJsonIdentifier.identifierWebLinkSlib],
        baseVersionSoftwareFile:
            rawData[ConstJsonIdentifier.idenifierWebLinkBase]);
  }
}
