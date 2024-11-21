import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/presentation/general_widgets/click_buttons/click_button_colored.dart';

import '../../../theme.dart';

class MountAndAdapPage extends StatelessWidget {
  final Function nextCallback;
  const MountAndAdapPage({super.key, required this.nextCallback});

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(Dimens.paddingDefault),
      child: Column(
        children: [
          const SizedBox(
            height: Dimens.sizedBoxBigDefault,
          ),
          Text(
            local.mountThermostat,
            textAlign: TextAlign.center,
            style: AppTheme.textStyleDefault,
          ),
          const SizedBox(
            height: Dimens.sizedBoxDefault,
          ),
          Text(
            local.adaptThermostat,
            textAlign: TextAlign.center,
            style: AppTheme.textStyleDefault,
          ),
          const SizedBox(
            height: Dimens.sizedBoxDefault,
          ),
          Text(
            local.adaptAnimationHint,
            textAlign: TextAlign.center,
            style: AppTheme.textStyleDefault,
          ),
          const SizedBox(
            height: Dimens.sizedBoxBigDefault,
          ),
          Image.asset(
            'assets/images/thermostat_adaptieren.png',
            width: Dimens.insertBatteryWidth,
            height: Dimens.insertBatteriesHight,
          ),
          const Spacer(),
          ClickButtonFilled(
              buttonText: local.next,
              buttonFunktion: () {
                nextCallback();
              },
              width: double.infinity)
        ],
      ),
    );
  }
}
