import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/models/ui/addBatteryModel/model_add_battery.dart';
import 'package:wifi_smart_living/presentation/add_new_thermostat/add_battery_row/add_battery_image__widget.dart';
import 'package:wifi_smart_living/presentation/general_widgets/click_buttons/click_button_colored.dart';

import '../../../theme.dart';

class InsertBatteriesPage extends StatelessWidget {
  final Function nextCallback;
  final List<ModelAddBattery> addBateryTutorialList = [
    ModelAddBattery(
        number: '1', imageName: 'assets/images/remove_battery_cover.png'),
    ModelAddBattery(
        number: '2', imageName: 'assets/images/insert_batteries.png'),
    ModelAddBattery(
        number: '3', imageName: 'assets/images/close_battery_cover.png'),
    ModelAddBattery(
        number: '4', imageName: 'assets/images/pairing_mode_activated.png'),
  ];

  InsertBatteriesPage({super.key, required this.nextCallback});

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
              local.insertBatteriesText,
              style: AppTheme.textStyleDefault,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: Dimens.sizedBoxBigDefault,
            ),
            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 2,
                    mainAxisSpacing: 5),
                itemBuilder: ((context, index) => AddBatyImageWidget(
                    number: addBateryTutorialList[index].number,
                    imageName: addBateryTutorialList[index].imageName)),
                itemCount: addBateryTutorialList.length,
              ),
            ),
            const SizedBox(
              height: Dimens.sizedBoxDefault,
            ),
            ClickButtonFilled(
                buttonText: local.next,
                buttonFunktion: () {
                  nextCallback();
                },
                width: double.infinity)
          ],
        ));
  }
}
