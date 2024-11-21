import 'package:flutter/material.dart';
import 'package:wifi_smart_living/dimens.dart';

///Description
///Define the app theme
///
///Author: Julian Anders
///created: 14-10-2022
///changed:
///
///History:
///
///Nodes:
class AppTheme {
  static const Color schriftfarbe = Color(0xFFF1F1F1);
  static const Color hintergrund = Color(0xFFFFFFFF);
  static const Color hintergrundHell = Color(0xFFEDEDED);
  static const Color violet = Color(0xFF990099);
  static const Color textDarkGrey = Color(0xFF636363);
  static const Color textLightGrey = Color(0xFFD0D0D0);
  static const Map<int, Color> materialColorMapping = {
    50: Color.fromRGBO(136, 14, 79, .1),
    100: Color.fromRGBO(136, 14, 79, .2),
    200: Color.fromRGBO(136, 14, 79, .3),
    300: Color.fromRGBO(136, 14, 79, .4),
    400: Color.fromRGBO(136, 14, 79, .5),
    500: Color.fromRGBO(136, 14, 79, .6),
    600: Color.fromRGBO(136, 14, 79, .7),
    700: Color.fromRGBO(136, 14, 79, .8),
    800: Color.fromRGBO(136, 14, 79, .9),
    900: Color.fromRGBO(136, 14, 79, 1),
  };

  static const TextStyle textStyleDefault =
      TextStyle(color: textDarkGrey, fontFamily: 'Titillium');

  static const TextStyle textStyleWhite =
      TextStyle(color: schriftfarbe, fontFamily: 'Titillium');

  static const TextStyle textStyleWhiteTablet =
      TextStyle(color: schriftfarbe, fontFamily: 'Titillium', fontSize: 20);

  static const TextStyle textStyleDefaultBolt = TextStyle(
      color: schriftfarbe,
      fontFamily: 'Titillium',
      fontWeight: FontWeight.bold);

  static const TextStyle textStyleDefaultBold = TextStyle(
      color: textDarkGrey,
      fontFamily: 'Titillium',
      fontWeight: FontWeight.bold);

  static const TextStyle textStyleDefaultBoltEnabled = TextStyle(
      color: textDarkGrey,
      fontFamily: 'Titillium',
      fontWeight: FontWeight.bold);

  static const TextStyle textStyleDefaultUntderlined = TextStyle(
    color: textDarkGrey,
    decoration: TextDecoration.underline,
    fontFamily: 'Titillium',
  );

  static const TextStyle textStyleColoredUnderlined = TextStyle(
    color: violet,
    decoration: TextDecoration.underline,
    fontFamily: 'Titillium',
  );

  static const TextStyle textStyleColoredDisabled =
      TextStyle(color: Color(0x55FAFAFA), fontFamily: 'Titillium');

  static const TextStyle textStyleColored =
      TextStyle(color: violet, fontFamily: 'Titillium');

  static const TextStyle textStyleColoredBold = TextStyle(
      color: violet, fontFamily: 'Titillium', fontWeight: FontWeight.bold);

  static const TextStyle textStyleBackground =
      TextStyle(color: hintergrund, fontFamily: 'Titillium');

  static MaterialColor hintergurndMaterial =
      const MaterialColor(0xFF414141, materialColorMapping);

  static final InputDecorationTheme _inputDecorationTheme =
      InputDecorationTheme(
    floatingLabelStyle: const TextStyle(color: Colors.white),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimens.borderRadius),
        borderSide: const BorderSide(color: violet)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(Dimens.borderRadius),
      borderSide: const BorderSide(color: violet),
    ),
    labelStyle: const TextStyle(color: schriftfarbe),
  );

  static final _switchTheme =
      SwitchThemeData(thumbColor: WidgetStateProperty.resolveWith((states) {
    if (states.contains(WidgetState.selected)) {
      return textDarkGrey;
    }
    return textDarkGrey;
  }), trackColor: WidgetStateProperty.resolveWith((states) {
    if (states.contains(WidgetState.selected)) {
      return textLightGrey;
    }
    return schriftfarbe;
  }), trackOutlineWidth: WidgetStateProperty.resolveWith((states) {
    if (states.contains(WidgetState.selected)) {
      return 0;
    }
    return 0;
  }));

  static final _timePickerTheme = TimePickerThemeData(
    //https://developer.school/snippets/flutter/how-to-customise-the-timepicker-widget
    //hintergrund des Picker-Containers
    backgroundColor: hintergrund,
    //Rahmen um die Stunden und Minuten Boxen des Zeitpcikers
    hourMinuteShape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(Dimens.borderRadius)),
      side: BorderSide(color: violet, width: 1),
    ),
    //Hintergrund der Zeit Boxen, wenn selected und not selected
    hourMinuteColor: WidgetStateColor.resolveWith((states) =>
        states.contains(WidgetState.selected) ? violet : hintergrundHell),
    //Textfarben der uhrzeit
    hourMinuteTextColor: WidgetStateColor.resolveWith((states) =>
        states.contains(WidgetState.selected) ? textLightGrey : violet),
    //Uhrzeiger
    dialHandColor: violet,
    //Ziffernblatt der Uhr
    dialBackgroundColor: hintergrundHell,
    hourMinuteTextStyle: textStyleDefault,
    //Ueberschrift des Uhrzeit Pickers
    helpTextStyle: const TextStyle(
        //fontSize: Dimens.textSize,
        fontWeight: FontWeight.bold,
        fontFamily: 'Titillium',
        color: textDarkGrey),
    inputDecorationTheme: const InputDecorationTheme(
      border: InputBorder.none,
      contentPadding: EdgeInsets.all(0),
    ),
    dialTextColor: WidgetStateColor.resolveWith((states) =>
        states.contains(WidgetState.selected) ? schriftfarbe : textDarkGrey),
    entryModeIconColor: AppTheme.textDarkGrey,
  );

  static final ThemeData defaultTheme = ThemeData(
    scaffoldBackgroundColor: hintergrund,
    colorSchemeSeed: violet,
    inputDecorationTheme: _inputDecorationTheme,
    timePickerTheme: _timePickerTheme,
    fontFamily: "Titillium",
    appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(
        fontSize: 20,
        color: violet,
        fontFamily: "Titillium",
      ),
      color: hintergrund,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    switchTheme: _switchTheme,
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
      foregroundColor: WidgetStateColor.resolveWith((states) => violet),
    )),
  );
}
