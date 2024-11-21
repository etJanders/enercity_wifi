
import 'package:flutter/material.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:io';

class SapModeConfigErrorView extends StatelessWidget {
  const SapModeConfigErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    return SizedBox(
      width: double.infinity,
      child: Center(
        child: Column(
          children: [
            Text(
              local.oopsError,
              style: AppTheme.textStyleDefault,
              textAlign: TextAlign.center
            ),
            const SizedBox(
              height: Dimens.sizedBoxDefault,
            ),
          Text(
             local.pleasetryAgain,
              style: AppTheme.textStyleDefault,
              textAlign: TextAlign.center
            ),
            Platform.isIOS ? const SizedBox(
              height: Dimens.sizedBoxDefault,
            ) : const SizedBox(
              height: 0,
            ),
            Platform.isIOS ?
            Text(
              local.pleaseProvideLocalAreaNetwrokPermission,
              style: AppTheme.textStyleDefault,
              textAlign: TextAlign.center
            ) : const Text(''),
          ],
        ),
      ),
    );
  }
}
