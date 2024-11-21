// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/theme.dart';

import '../../singelton/api_singelton.dart';
import '../general_widgets/checkBoxen/default_check_box.dart';
import '../general_widgets/click_buttons/click_button_colored.dart';
import '../home_page/indoor/homepage_indoor_page.dart';
import '../login/login_page.dart';

class DisplayMaintainancePage extends StatelessWidget {
  //Todo translation
  static const routName = "/display_maintainance_page";

  const DisplayMaintainancePage({super.key, required this.loginType});
  final String loginType;
  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    return Scaffold(
        appBar: AppBar(
          title: Text(local.notice),
        ),
        body: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(Dimens.paddingDefault),
            child: Column(
              children: [
                Image.asset(
                  "assets/images/ic_warning_01.png",
                  width: Dimens.containerWidth,
                  height: Dimens.containerWidth,
                ),
                local.languageCode == 'de'
                    ? Text(
                        ApiSingelton().getTitleGerman,
                        style: AppTheme.textStyleDefault,
                        textAlign: TextAlign.center,
                      )
                    : Text(
                        ApiSingelton().getTitle,
                        style: AppTheme.textStyleDefaultUntderlined,
                        textAlign: TextAlign.center,
                      ),
                const SizedBox(
                  height: Dimens.sizedBoxDefault,
                ),
                const SizedBox(
                  height: Dimens.sizedBoxDefault,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: local.languageCode == 'de'
                          ? Text(
                              ApiSingelton().getMessageGerman,
                              style: AppTheme.textStyleDefault,
                              textAlign: TextAlign.center,
                            )
                          : Text(
                              ApiSingelton().getMessage,
                              style: AppTheme.textStyleDefault,
                              textAlign: TextAlign.center,
                            ),
                    )
                  ],
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      local.doNotShowAgain,
                      style: AppTheme.textStyleDefault,
                    ),
                    CustomeCheckBox(
                        initState: false,
                        callback: (value) {
                          print(value);
                          changePopupPreference(value);
                        })
                  ],
                ),
                ClickButtonFilled(
                    buttonText: local.proceed,
                    buttonFunktion: () {
                      if (loginType == "auto") {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            HomepageIndoorPage.routName,
                            (Route<dynamic> route) => false);
                      } else {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            LoginPage.routName,
                            (Route<dynamic> route) => false);
                      }
                    },
                    width: double.infinity),
              ],
            ),
          ),
        ));
  }

  Future<void> changePopupPreference(value) async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    if (value) {
      sp.setInt("popUpPreference", 1);
    } else {
      sp.setInt("popUpPreference", 0);
    }
  }

  String getLanguageCode() {
    String isoCountryCode = "en";
    final List<Locale> systemLocales = WidgetsBinding.instance.window.locales;
    isoCountryCode = systemLocales.first.countryCode ?? 'en';
    print(isoCountryCode);
    return isoCountryCode;
  }
}
