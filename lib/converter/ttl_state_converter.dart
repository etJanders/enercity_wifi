import 'package:wifi_smart_living/converter/hex_bin_converter.dart';
import 'package:wifi_smart_living/models/database/model_device_profile.dart';
import 'package:wifi_smart_living/thermostat_attributes/ttl_state.dart';

abstract class TTLStateConverter {
  static TTLState buildTtlState(
      {required ModelDeviceProfile modelDeviceProfile}) {
    final TTLState ttlState;

    if (modelDeviceProfile.profileValue != '#') {
      int data = HexBinConverter.convertHexStringToInt(
          hexString: modelDeviceProfile.profileValue);
      //Todo muss noch getestet werden, am besten mit dart pad

      /*
        Auszug Mail von Brederlow vom 12.03.2023 
        TTL_RES % 16 ergibt den Adaptierstatus 0 bis 15 nur 0,1,2,3,6,7 in Benutzung)
        TTL_RES and 16 ergibt das Fenster Offen Timer Aktiv Bit 0/1 bzw. true / false
        TTL_RES and 32 ergibt den Urlaubsflag 0/1
      */
      ttlState = TTLState(
          windowOpenState: data & 16 == 16,
          adaptionState: data % 16,
          holidayState: data & 32 == 32);
    } else {
      ttlState = TTLState(
          windowOpenState: false, adaptionState: 0, holidayState: false);
    }
    return ttlState;
  }
}
