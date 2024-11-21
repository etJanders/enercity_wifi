import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

///Description:
///Allows Access to the Secured Storage area of a smartphone.
///
///Author: J. Anders
///created: 15-08-2022
///changed: 15-08-2022
///
///History:
///
///Notes:
///https://pub.dev/packages/flutter_secure_storage
///
///
class SecuredStorageHelper {
  AndroidOptions _secureOption() => const AndroidOptions(
    encryptedSharedPreferences: true,
  );
  final _securedStorageHelper =  const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  ///Write data to the secured Storage area
  Future<void> storeData({required String key, required String value}) async {
    await _securedStorageHelper.write(key: key, value: value,aOptions: _secureOption());
  }


  ///read stored data
  ///
  ///
  Future<String> readSecuredStorageData({required String key}) async {
    String storedValue = "";
    try {
      if (await _securedStorageHelper.containsKey(key: key)) {
        storedValue = (await _securedStorageHelper.read(key: key))!;
      }
    }on PlatformException catch (e) {
      // Workaround for https://github.com/mogol/flutter_secure_storage/issues/43
      log(e.toString());
      await _securedStorageHelper.deleteAll();
    }
      return storedValue;

  }

  ///remove all stored entries
  Future<void> removeAllEnries() async {
    await _securedStorageHelper.deleteAll();
  }
}
