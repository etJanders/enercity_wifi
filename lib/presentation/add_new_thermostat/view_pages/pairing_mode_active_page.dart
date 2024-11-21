import 'package:flutter/material.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/presentation/general_widgets/click_buttons/click_button_colored.dart';
import 'package:wifi_smart_living/presentation/general_widgets/textWidgets/clickebal_text_widget.dart';
import 'package:wifi_smart_living/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

///Description
///Infomration UI describe a device which is in the pairing mode
///
///Author: J. Anders
///created: 15-12-2022
///changed: 15-12-2022
///
///History:
///
///Notes:
class PairingModeActivePage extends StatelessWidget {
  ///Switch to reset ui
  final Function resetDeviceCallback;

  ///go forward
  final Function nextCallback;

  const PairingModeActivePage(
      {super.key,
      required this.nextCallback,
      required this.resetDeviceCallback});

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(Dimens.paddingDefault),
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                const SizedBox(
                  height: Dimens.sizedBoxBigDefault,
                ),
                Text(
                  local.pairingModeState,
                  style: AppTheme.textStyleDefault,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: Dimens.sizedBoxBigDefault,
                ),
                Image.asset(
                  'assets/images/pairing_mode_activated.png',
                  width: Dimens.pairingModeWidth,
                  height: Dimens.pairingModeHight,
                ),
              ],
            ),
          ),
          ClickButtonFilled(
              buttonText: local.next,
              buttonFunktion: () {
                nextCallback();
              },
              width: double.infinity),
          const SizedBox(
            height: Dimens.sizedBoxHalf,
          ),
          ClickedText(
              text: local.activatePairingMode,
              textColor: AppTheme.violet,
              onClick: () {
                resetDeviceCallback();
              }),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
