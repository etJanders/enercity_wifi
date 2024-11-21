// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:interval_time_picker/interval_time_picker.dart';
import 'package:interval_time_picker/models/visible_step.dart';
import 'package:provider/provider.dart';
import 'package:wifi_smart_living/converter/hex_bin_converter.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/heatingProfile/heating_profile_item.dart';
import 'package:wifi_smart_living/presentation/alert_dialogs/alert_dialog_information.dart';
import 'package:wifi_smart_living/presentation/alert_dialogs/select_temperature_alert.dart';
import 'package:wifi_smart_living/presentation/heatingProfile/profile_widgets/time_schedule_row.dart';
import 'package:wifi_smart_living/presentation/heatingProfile/profile_widgets/weekday_selection_widget.dart';
import 'package:wifi_smart_living/provider/heating_profile_provider.dart';
import 'package:wifi_smart_living/theme.dart';
import 'package:wifi_smart_living/validation/general/data_length_validator.dart';

class HeatingprofileIntervalWidget extends StatefulWidget {
  //Gibt das Intervall an, über welches im provider zugegriffen werden kann
  final int intervalIndex;
  const HeatingprofileIntervalWidget({super.key, required this.intervalIndex});

  @override
  State<HeatingprofileIntervalWidget> createState() =>
      _HeatingprofileIntervalWidgetState();
}

class _HeatingprofileIntervalWidgetState
    extends State<HeatingprofileIntervalWidget> {
  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(Dimens.paddingDefault),
      child: Column(
        children: [
          WeekdaySelectionContainer(
            intervalIndex: widget.intervalIndex,
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(Dimens.paddingDefault),
            decoration: BoxDecoration(
              color: AppTheme.hintergrundHell,
              borderRadius: BorderRadius.circular(Dimens.borderRadius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: ((context, index) => TimeScheduleRow(
                      item: context
                          .watch<HeatingProfileProvider>()
                          .schaltzeitenIntervalle[widget.intervalIndex]
                          .zeitschaltpunkte[index],
                      callbackTime: () async {
                        TimeOfDay? response = await showIntervalTimePicker(
                          context: context,
                          interval: 10,
                          visibleStep: VisibleStep.tenths,
                          initialTime: initTimeOfDay(context
                              .read<HeatingProfileProvider>()
                              .schaltzeitenIntervalle[widget.intervalIndex]
                              .zeitschaltpunkte[index]),
                        );
                        if (response != null) {
                          if (!context
                              .read<HeatingProfileProvider>()
                              .timeAlreadyExist(
                                  widget.intervalIndex, response)) {
                            context.read<HeatingProfileProvider>().changeTime(
                                widget.intervalIndex, index, response);
                          } else {
                            InformationAlert().showAlertDialog(
                                context: context,
                                message: local.doubleTimeError,
                                callback: () {});
                          }
                        }
                      },
                      callbackTemperature: () {
                        int temperature = context
                            .read<HeatingProfileProvider>()
                            .schaltzeitenIntervalle[widget.intervalIndex]
                            .zeitschaltpunkte[index]
                            .getTemperature;
                        SelectTemperatureAlert().showAlertDialog(
                            context: context,
                            callback: (value) {
                              context
                                  .read<HeatingProfileProvider>()
                                  .changeTemperature(
                                      widget.intervalIndex,
                                      index,
                                      HexBinConverter.convertHexStringToInt(
                                          hexString: value));
                            },
                            titleText: HexBinConverter.convertIntToHex(
                                DataLengh.dataLengthTwo, temperature),
                            positiveButtontext: local.okay,
                            negativeButtonText: local.cancel);
                      },
                      callbackDelete: () {
                        context
                            .read<HeatingProfileProvider>()
                            .entferneIntervall(widget.intervalIndex, index);
                      })),
                  itemCount: context
                      .watch<HeatingProfileProvider>()
                      .schaltzeitenIntervalle[widget.intervalIndex]
                      .zeitschaltpunkte
                      .length,
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(
                    color: AppTheme.textDarkGrey,
                  ),
                ),
                const SizedBox(
                  height: Dimens.sizedBoxDefault,
                ),
                context
                            .watch<HeatingProfileProvider>()
                            .schaltzeitenIntervalle[widget.intervalIndex]
                            .zeitschaltpunkte
                            .length <
                        9
                    ? InkWell(
                        onTap: () {
                          context
                              .read<HeatingProfileProvider>()
                              .leeresIntervallHinzufuegen(widget.intervalIndex);
                        },
                        child: Text(
                          local.addNewHeatingTime,
                          style: AppTheme.textStyleDefaultUntderlined,
                          textAlign: TextAlign.start,
                        ),
                      )
                    : Container(),
              ],
            ),
          )
        ],
      ),
    );
  }

  TimeOfDay initTimeOfDay(HeatingProfileDatabaseItem item) {
    if (item.getStartHour == 0x80 || item.getStartMinute == 0x80) {
      return TimeOfDay(hour: DateTime.now().hour, minute: 0);
    } else {
      return TimeOfDay(hour: item.getStartHour, minute: item.getStartMinute);
    }
  }
}
