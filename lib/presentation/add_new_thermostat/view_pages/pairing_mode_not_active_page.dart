import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/presentation/general_widgets/click_buttons/click_button_colored.dart';

import '../../../theme.dart';

class PairingModeNotActivePage extends StatelessWidget {
  final Function deviceResetCallback;
  const PairingModeNotActivePage(
      {super.key, required this.deviceResetCallback});

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(Dimens.paddingDefault),
      child: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: Dimens.sizedBoxBigDefault,
              ),
              Text(
                local.activatePairingModeHelperText,
                style: AppTheme.textStyleDefault,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: Dimens.sizedBoxBigDefault,
              ),
              Image.asset(
                'assets/images/reset_outline.png',
                width: Dimens.pairingModeWidth,
                height: Dimens.pairingModeHight,
              ),
            ],
          ),
          const Spacer(),
          ClickButtonFilled(
              buttonText: local.understood,
              buttonFunktion: () => deviceResetCallback(),
              width: double.infinity),
        ],
      ),
    );
  }
}
