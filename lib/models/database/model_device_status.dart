import 'package:wifi_smart_living/const/const_json_identifier.dart';

class ModelDeviceStatus {
  static const String _deviceOnline = 'online';

  final String macAdress;
  final String onlineState;

  ModelDeviceStatus({required this.macAdress, required this.onlineState});

  factory ModelDeviceStatus.fromJson(Map<String, dynamic> rawData) {
    return ModelDeviceStatus(
        macAdress: rawData[ConstJsonIdentifier.identifierDeviceMacAdress],
        onlineState: rawData[ConstJsonIdentifier.jsonIdentifierDeviceStatus]);
  }

  bool isDeviceOnline() {
    return _deviceOnline == onlineState;
  }
}
