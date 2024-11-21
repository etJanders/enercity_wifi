import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wifi_smart_living/connectivity/network_connection_helper.dart';

import '../../api_handler/api_treiber/api_base_url_helper/api_url_helper.dart';
import '../../api_handler/api_treiber/login/auto_login_helper.dart';
import '../../api_handler/api_treiber/ping/api_ping_helper.dart';
import '../../api_handler/api_treiber/user_management/get_self_helper.dart';
import '../../const/const_api.dart';
import '../../const/const_sharedpreference_storage.dart';
import '../../http_helper/http_handler/https_request_helper.dart';
import '../../http_helper/uri_helper/uri_parser.dart';
import '../../singelton/api_singelton.dart';

part 'auto_login_event.dart';
part 'auto_login_state.dart';

///Description
///Handle Auto Login Events
///
///Author: J. Anders
///created: 16-12-2022
///changed: 16-12-2022
///
///History:
///
///Notes:
class AutoLoginBloc extends Bloc<AutoLoginBlocEvent, AutoLoginBlocState> {
  late String password = "";

  AutoLoginBloc() : super(AutoLoginInProgressState()) {
    on<AutoLoginInitEvent>((event, emit) async {
      if (Platform.isAndroid || Platform.isIOS) {
        if (await NetworkStateHelper.networkConnectionEstablished()) {
          AutoLoginHelper helper = AutoLoginHelper();

          AutoLoginState state = await helper.autoLogin();
          if (state == AutoLoginState.notDataStored) {
            emit(AutoLoginSuccessErrorState());
          } else if (state == AutoLoginState.credentialsWrong) {
            emit(AutoLoginSuccessErrorState());
          } else if (state == AutoLoginState.timeout) {
            emit(TimeOutErrorState());
          } else {
            password = helper.password;
            emit(AutoLoginSuccessState());
          }
        } else {
          emit(NetworkErrorState());
        }
      } else {
        emit(AutoLoginSuccessErrorState());
      }
    });

    on<DetermineSelfDataFromDatabase>((event, emit) async {
      GetSelfState state = await GetSelfHelper().callGetSelf(
          token: ApiSingelton().getModelAccessToken, password: password);
      if (state == GetSelfState.getSelfDetermined) {
        emit(GetSelfeCalledState());
      } else {
        emit(AutoLoginSuccessErrorState());
      }
    });

    on<DeterminePopUpStatusForAutoLogin>((event, emit) async {
      try {
        await _ping();
        Uri uri;

        uri = await UriParser.createUri(apiFunction: ConstApi.checkPopup)
            .timeout(const Duration(seconds: 15));

        Response response = await HttpRequestHelper.getDatabaseEntries(
            apiFunction: uri,
            httpHeader: {}).timeout(const Duration(seconds: 5));

        final dynamic parsedJson;
        try {
          final parsedJson1 = jsonDecode(response.body);
          parsedJson = parsedJson1;
        } catch (e) {
          emit(PopUpStateFalse());
          return;
        }
        bool popupStatus = parsedJson["popup"][0]["display"] ?? '';
        String message = parsedJson["popup"][0]["message"] ?? '';
        String messageDe = parsedJson["popup"][0]["message_de"] ?? '';
        String title = parsedJson["popup"][0]["title"] ?? '';
        String titleDe = parsedJson["popup"][0]["title_de"] ?? '';
        print(messageDe);
        print(titleDe);
        if (title.isEmpty) {
          title = "Our app is getting a little tune up";
          // This is kept to handle any scenerios where API comes without a title or message
        }
        if (message.isEmpty) {
          message =
              "We truly apologise for the inconvenience.Data may not represent the real time data. We will be back soon";
        }
        SharedPreferences sp = await SharedPreferences.getInstance();
        int popUpPreference = sp.getInt("popUpPreference") ?? 0;
        String popUpMessage = sp.getString("popUpMessage") ?? "";
        String popUpTitle = sp.getString("popUpTitle") ?? "";

        if (popupStatus) {
          ApiSingelton().initPopUpMessage(
            message: message,
            title: title,
            messageDe: messageDe,
            titleDe: titleDe,
          );
          if (popUpPreference == 1 &&
              (message != popUpMessage) &&
              (title != popUpTitle)) {
            sp.setInt(ConstSharedPreferenceNames.key, 1);
            sp.setString(ConstSharedPreferenceNames.messageEnglish, message);
            sp.setString(ConstSharedPreferenceNames.titleEnglish, title);
            sp.setString(ConstSharedPreferenceNames.messageGerman, messageDe);
            sp.setString(ConstSharedPreferenceNames.titleGerman, titleDe);
            emit(PopUpStateSuccess());
          } else if (popUpPreference == 0) {
            sp.setString(ConstSharedPreferenceNames.messageEnglish, message);
            sp.setString(ConstSharedPreferenceNames.titleEnglish, title);
            sp.setString(ConstSharedPreferenceNames.messageGerman, messageDe);
            sp.setString(ConstSharedPreferenceNames.titleGerman, titleDe);
            emit(PopUpStateSuccess());
          } else {
            emit(PopUpStateFalse());
          }
          // emit(PopUpStateSuccess());
        } else {
          emit(PopUpStateFalse());
        }
      } on TimeoutException catch (_) {
        emit(PopUpManualStateFalse());
        return;
      } catch (e) {
        emit(PopUpManualStateFalse());
      }
    });

    on<DeterminePopUpStatusForManualLogin>((event, emit) async {
      try {
        await _ping();
        Uri uri;

        uri = await UriParser.createUri(apiFunction: ConstApi.checkPopup)
            .timeout(const Duration(seconds: 15));
        Response response = await HttpRequestHelper.getDatabaseEntries(
            apiFunction: uri,
            httpHeader: {}).timeout(const Duration(seconds: 15));

        final parsedJson = jsonDecode(response.body);
        print(response.body);
        // print("value of parsed repsonse in list format is ${parsedJson["popup"][0]["display"]}");
        bool popupStatus = parsedJson["popup"][0]["display"] ?? "";
        String message = parsedJson["popup"][0]["message"] ?? "";
        String messageDe = parsedJson["popup"][0]["message_de"] ?? "";
        String title = parsedJson["popup"][0]["title"] ?? "";
        String titleDe = parsedJson["popup"][0]["title_de"] ?? "";

        if (title.isEmpty) {
          title = "Our app is getting a little tune up";
        }
        if (message.isEmpty) {
          message =
              "We truly apologise for the inconvenience.Data may nor represent the real time data. We will be back soon";
        }

        //Global pop up
        SharedPreferences sp = await SharedPreferences.getInstance();
        int popUpPreference = sp.getInt("popUpPreference") ?? 0;
        String popUpMessage = sp.getString("popUpMessage") ?? "";
        String popUpTitle = sp.getString("popUpTitle") ?? "";
        //Clearing user specific values from shared preference
        sp.setBool(ConstSharedPreferenceNames.keySpecific, false);

        if (popupStatus) {
          ApiSingelton().initPopUpMessage(
              message: message,
              title: title,
              messageDe: messageDe,
              titleDe: titleDe);
          if (popUpPreference == 1 &&
              (message != popUpMessage) &&
              (title != popUpTitle)) {
            sp.setInt(ConstSharedPreferenceNames.key, 1);
            sp.setString(ConstSharedPreferenceNames.messageEnglish, message);
            sp.setString(ConstSharedPreferenceNames.titleEnglish, title);
            sp.setString(ConstSharedPreferenceNames.messageGerman, messageDe);
            sp.setString(ConstSharedPreferenceNames.titleGerman, titleDe);
            emit(PopUpManualStateSuccess());
          } else if (popUpPreference == 0) {
            sp.setString(ConstSharedPreferenceNames.messageEnglish, message);
            sp.setString(ConstSharedPreferenceNames.titleEnglish, title);
            sp.setString(ConstSharedPreferenceNames.messageGerman, messageDe);
            sp.setString(ConstSharedPreferenceNames.titleGerman, titleDe);
            emit(PopUpManualStateSuccess());
          } else {
            emit(PopUpManualStateFalse());
          }
          // emit(PopUpStateSuccess());
        } else {
          emit(PopUpManualStateFalse());
        }
      } on TimeoutException catch (_) {
        emit(PopUpManualStateFalse());
        return;
      } catch (e) {
        emit(PopUpManualStateFalse());
      }
    });
  }

  Future<void> _ping() async {
    PingState state = await PingHelper()
        .sendApiPing(baseUrl: await ApiUrlHelper().getDefaultUrl());
    if (state == PingState.apiAvailable) {
      ApiUrlHelper().setUseableUrl(true);
    } else {
      ApiUrlHelper().setUseableUrl(false);
    }
  }
}
