import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wifi_smart_living/api_handler/api_treiber/sync/sync_database_entries.dart';
import 'package:wifi_smart_living/presentation/add_new_thermostat/add_new_thermostat.dart';
import 'package:wifi_smart_living/presentation/chang_notification/change_notification_page.dart';
import 'package:wifi_smart_living/presentation/change_account_mail/change_account_mail.dart';
import 'package:wifi_smart_living/presentation/change_password/change_user_password.dart';
import 'package:wifi_smart_living/presentation/create_user_account/create_user_account_page.dart';
import 'package:wifi_smart_living/presentation/display_notification/display_notification_page.dart';
import 'package:wifi_smart_living/presentation/edit_structures/edit_room/edit_room_page.dart';
import 'package:wifi_smart_living/presentation/edit_structures/edit_schedule/edit_schedule_page.dart';
import 'package:wifi_smart_living/presentation/edit_structures/edit_thermostat/edit_thermostat_page.dart';
import 'package:wifi_smart_living/presentation/heatingProfile/createNewProfile/create_heating_profile.dart';
import 'package:wifi_smart_living/presentation/heatingProfile/heating_profile_management/show_heating_profile_page.dart';
import 'package:wifi_smart_living/presentation/help/help_page.dart';
import 'package:wifi_smart_living/presentation/holiday/create_holiday_profile/create_holiday_profile_main.dart';
import 'package:wifi_smart_living/presentation/holiday/set_holiday_profile/show_holiday_profile_page.dart';
import 'package:wifi_smart_living/presentation/holiday_room_management/holiday_room_management_page.dart';
import 'package:wifi_smart_living/presentation/home_page/indoor/homepage_indoor_page.dart';
import 'package:wifi_smart_living/presentation/legal_nodes/legal_nodes_page.dart';
import 'package:wifi_smart_living/presentation/login/login_page.dart';
import 'package:wifi_smart_living/presentation/mail_verification/mail_verification_page.dart';
import 'package:wifi_smart_living/presentation/maintainanace_display/display_maintainance_message.dart';
import 'package:wifi_smart_living/presentation/password_reset/password_reset_page.dart';
import 'package:wifi_smart_living/presentation/room_thermostat_overview/room_thermostat_overview_page.dart';
import 'package:wifi_smart_living/presentation/schedule_holiday_room_management/add_new_room_to_schedule/add_new_room_to_schedule.dart';
import 'package:wifi_smart_living/presentation/schedule_room_management/schedule_room_management_page.dart';
import 'package:wifi_smart_living/presentation/splash_screen/splash_screen_page.dart';
import 'package:wifi_smart_living/presentation/thermostat_control/control_thermostat_room_page.dart';
import 'package:wifi_smart_living/presentation/user_account_management/user_account_management_page.dart';
import 'package:wifi_smart_living/provider/edit_room_provider.dart';
import 'package:wifi_smart_living/provider/edit_schedule_provider.dart';
import 'package:wifi_smart_living/provider/heating_profile_provider.dart';
import 'package:wifi_smart_living/provider/holiday_profile_provider.dart';
import 'package:wifi_smart_living/singelton/helper/mqtt_message_puffer.dart';
import 'package:wifi_smart_living/theme.dart';
import 'l10n/l10n.dart';
//Localization: https://www.youtube.com/watch?v=aIEegP0cUOQ

void main() async {
  ///https://stackoverflow.com/questions/54285172/how-to-solve-flutter-certificate-verify-failed-error-while-performing-a-post-req
  WidgetsFlutterBinding.ensureInitialized();
  ByteData data =
      await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
  SecurityContext.defaultContext
      .setTrustedCertificatesBytes(data.buffer.asUint8List());
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<DatabaseSync>(
          create: ((context) => DatabaseSync())),
      ChangeNotifierProvider<MqttMessagePuffer>(
          create: (context) => MqttMessagePuffer()),
      ChangeNotifierProvider<HeatingProfileProvider>(
          create: ((context) => HeatingProfileProvider())),
      ChangeNotifierProvider<HolidayProfileProvider>(
          create: ((context) => HolidayProfileProvider())),
      ChangeNotifierProvider<EditScheduleProvider>(
          create: ((context) => EditScheduleProvider())),
      ChangeNotifierProvider<EditRoomProvider>(
          create: ((context) => EditRoomProvider())),
    ],
    child: const MyApp(),
  ));
}

///https://api.flutter.dev/flutter/widgets/RouteObserver-class.html
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //Allows only portrait mode: https://stackoverflow.com/questions/49418332/flutter-how-to-prevent-device-orientation-changes-and-force-portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'enercity smarte Thermostate',
      theme: AppTheme.defaultTheme,
      supportedLocales: L10n.all,
      localeResolutionCallback: (locale, supportedLocales) {
        for (Locale supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      navigatorObservers: [routeObserver],
      routes: <String, WidgetBuilder>{
        LoginPage.routName: (context) => const LoginPage(),
        CreateUserAccountViewPagerPage.routName: (context) =>
            const CreateUserAccountViewPagerPage(),
        PasswordResetPage.routName: (context) => const PasswordResetPage(),
        HomepageIndoorPage.routName: (context) => const HomepageIndoorPage(),
        LegalNotesPage.routname: (context) => const LegalNotesPage(),
        AddNewThermostatViewPage.routName: (context) =>
            const AddNewThermostatViewPage(),
        UserAccountManagementPage.routName: (context) =>
            const UserAccountManagementPage(),
        ChangeAccountMailPage.routName: (context) =>
            const ChangeAccountMailPage(),
        ChangeNotificationPage.routName: (context) =>
            const ChangeNotificationPage(),
        ControlThermostatRoomPage.routName: (context) =>
            const ControlThermostatRoomPage(),
        RoomThermostatOverviewPage.routName: (context) =>
            const RoomThermostatOverviewPage(),
        EditThermostatNamePage.routName: (context) =>
            const EditThermostatNamePage(),
        CreateHeatingProfilePage.routName: (context) =>
            const CreateHeatingProfilePage(),
        ShowHeatingprofilePage.routName: (context) =>
            const ShowHeatingprofilePage(),
        ChangeUserPasswordPage.routName: (context) =>
            const ChangeUserPasswordPage(),
        EditRoomStructurePage.routName: (context) =>
            const EditRoomStructurePage(),
        CreateHolidayProfileMainPage.routName: (context) =>
            const CreateHolidayProfileMainPage(),
        HelpPage.routName: (context) => const HelpPage(),
        ShowHolidayProfilePage.routName: (context) =>
            const ShowHolidayProfilePage(),
        ScheduleRoomOverviewPage.routName: (context) =>
            const ScheduleRoomOverviewPage(),
        AddRoomToSchedulePage.routName: (context) =>
            const AddRoomToSchedulePage(),
        EditSchedulePage.routName: (context) => const EditSchedulePage(),
        HolidayScheduleRoomOverviewPage.routName: (context) =>
            const HolidayScheduleRoomOverviewPage(),
        MailVerificationPage.routName: (context) =>
            const MailVerificationPage(),
        DisplayNotificationPage.routName: (context) =>
            const DisplayNotificationPage(),
        DisplayMaintainancePage.routName: (context) =>
            const DisplayMaintainancePage(loginType: ''),
      },
      home: const SplashScreenPage(),
    );
  }
}
