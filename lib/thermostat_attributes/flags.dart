import 'package:wifi_smart_living/converter/hex_bin_converter.dart';
import 'package:wifi_smart_living/core/stringSplitter/string_splitter_builder.dart';
import 'package:wifi_smart_living/thermostat_attributes/helper/database_flag_converter.dart';

///Description
///Manage Flag state for ui and mqtt transmission
///Author: J. Anders
///created: 19-12-2022
///changed: 19-12-2022
///
///History:
///
///Notes:
///
class ThermostatFlags {
  static const int _tastensperreChanged = 1;
  static const int _dstChanged = 2;
  static const int _operationModeChanged = 3;
  static const int _rotateDisplay = 5;
  static const int _advancedkeyLockChanged = 4;

  static const int dstPosition = 0;
  static const int rotateDisplayPosition = 1;
  static const int keyLocPosition = 2;
  static const int advancedkeyLockPosition = 3;
  static const int operationModePosition = 5;

  int _flagByte0 = 0x00;
  int _flagByte1 = 0x00;
  int _flagByte3 = 0x00;

  late bool keyLock = false;
  late bool advancedKeyLock = false;
  late bool rotateDisplay = false;
  late bool operationMode = false;
  late bool dst = true;

  ThermostatFlags(String flagValue) {
    _initThermostatFlags(databaseFlagValue: flagValue);
  }

  void _initThermostatFlags({required String databaseFlagValue}) {
    List<int> values = SplitStringHelper.splitStringAfterCharactersInt(
        dataString: databaseFlagValue, splitPosition: 2);
    DatabaseFlagHelper flagHelper = DatabaseFlagHelper();
    if (values.length == 2) {
      keyLock = flagHelper.getBitState(
          byteValue: values[0], position: keyLocPosition);
      advancedKeyLock = flagHelper.getBitState(
          byteValue: values[0], position: advancedkeyLockPosition);
      rotateDisplay = flagHelper.getBitState(
          byteValue: values[0], position: rotateDisplayPosition);
      operationMode = flagHelper.getBitState(
          byteValue: values[0], position: operationModePosition);
      dst = flagHelper.getBitState(byteValue: values[0], position: dstPosition);
      _flagByte3 = values[1];
    }
  }

  void setTastensperre(bool tastensperre) {
    keyLock = tastensperre;
    if(tastensperre){
      advancedKeyLock = !tastensperre;
      _flagChanged(_advancedkeyLockChanged);
    }
    _flagChanged(_tastensperreChanged);
  }

  void setAdvancedKeyLock(bool advancedkeylockState) {
    advancedKeyLock = advancedkeylockState;
    if(advancedkeylockState){
      keyLock = !advancedkeylockState;
      _flagChanged(_tastensperreChanged);
    }
    _flagChanged(_advancedkeyLockChanged);
  }

  void setAnzeigeDrehen(bool displayRotation) {
    rotateDisplay = displayRotation;
    _flagChanged(_rotateDisplay);
  }

  void setOperationMode(bool mode) {
    operationMode = mode;
    _flagChanged(_operationModeChanged);
  }

  void setDstMode(bool dstChanged) {
    dst = dstChanged;
    _flagChanged(_dstChanged);
  }

  void _flagChanged(int changeId) {

    print(changeId);
    if (changeId == _tastensperreChanged) {
      if (keyLock) {
        _flagByte0 |= 0x04;
      } else {
        _flagByte1 |= 0x04;
      }
    } else if (changeId == _advancedkeyLockChanged) {
      if (advancedKeyLock) {
        _flagByte0 |= 0x08;
      } else {
        _flagByte1 |= 0x08;
      }
    } else if (changeId == _dstChanged) {
      if (dst) {
        _flagByte0 |= 0x01;
      } else {
        _flagByte1 |= 0x01;
      }
    } else if (changeId == _operationModeChanged) {
      if (!operationMode) {
        _flagByte1 |= 0x20;
      } else {
        _flagByte0 |= 0x20;
      }
    } else if (changeId == _rotateDisplay) {
      if (rotateDisplay) {
        _flagByte0 |= 0x02;
      } else {
        _flagByte1 |= 0x02;
      }
    }
  }

  String getDatabaseFlagsForSent() {
    String data =
        "${HexBinConverter.convertIntToHex(2, _flagByte0)}${HexBinConverter.convertIntToHex(2, _flagByte1)}000000";
    _flagByte0 = 0x00;
    _flagByte1 = 0x00;
    return data;
  }

  String getFlagsForDatabaseUpdate() {
    return HexBinConverter.convertIntToHex(2, _determineFlag0State()) +
        HexBinConverter.convertIntToHex(2, _flagByte3);
  }

  int _determineFlag0State() {
    int output = 0x00;
    if (dst) {
      output |= 0x01;
    }
    if (operationMode) {
      output |= 0x20;
    }
    if (rotateDisplay) {
      output |= 0x02;
    }
    if (keyLock) {
      output |= 0x04;
    }
    if (advancedKeyLock) {
      output |= 0x08;
    }
    return output;
  }
}
