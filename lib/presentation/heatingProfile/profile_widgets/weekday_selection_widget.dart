import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wifi_smart_living/device_specification/thermostat_interface.dart';
import 'package:wifi_smart_living/models/ui/heating_profile/model_select_weekday.dart';
import 'package:wifi_smart_living/presentation/alert_dialogs/alert_dialog_information.dart';
import 'package:wifi_smart_living/presentation/heatingProfile/profile_widgets/weekday_selection_item.dart';
import 'package:wifi_smart_living/provider/heating_profile_provider.dart';

class WeekdaySelectionContainer extends StatefulWidget {
  final int intervalIndex;

  const WeekdaySelectionContainer({super.key, required this.intervalIndex});

  @override
  State<WeekdaySelectionContainer> createState() =>
      _WeekdaySelectionContainerState();
}

class _WeekdaySelectionContainerState extends State<WeekdaySelectionContainer> {
  late List<ModelSelectWeekday> weekdaySelection;
  late HeatingProfileProvider profileProvider;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    weekdaySelection = [
      ModelSelectWeekday(
          title: local.mondayShort,
          selected: context
              .watch<HeatingProfileProvider>()
              .schaltzeitenIntervalle[widget.intervalIndex]
              .wochentage
              .contains(ThermostatInterface.weekdayMonday)),
      ModelSelectWeekday(
          title: local.tuesdayShort,
          selected: context
              .watch<HeatingProfileProvider>()
              .schaltzeitenIntervalle[widget.intervalIndex]
              .wochentage
              .contains(ThermostatInterface.weekdayTuesday)),
      ModelSelectWeekday(
          title: local.wednesdayShort,
          selected: context
              .watch<HeatingProfileProvider>()
              .schaltzeitenIntervalle[widget.intervalIndex]
              .wochentage
              .contains(ThermostatInterface.weekdayWednesday)),
      ModelSelectWeekday(
          title: local.thursdayShort,
          selected: context
              .watch<HeatingProfileProvider>()
              .schaltzeitenIntervalle[widget.intervalIndex]
              .wochentage
              .contains(ThermostatInterface.weekdayThursday)),
      ModelSelectWeekday(
          title: local.fridayShort,
          selected: context
              .watch<HeatingProfileProvider>()
              .schaltzeitenIntervalle[widget.intervalIndex]
              .wochentage
              .contains(ThermostatInterface.weekdayFriday)),
      ModelSelectWeekday(
          title: local.saturdayShort,
          selected: context
              .watch<HeatingProfileProvider>()
              .schaltzeitenIntervalle[widget.intervalIndex]
              .wochentage
              .contains(ThermostatInterface.weekdaySaturday)),
      ModelSelectWeekday(
          title: local.sundayShort,
          selected: context
              .watch<HeatingProfileProvider>()
              .schaltzeitenIntervalle[widget.intervalIndex]
              .wochentage
              .contains(ThermostatInterface.weekdaySunday)),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1.25,
        crossAxisSpacing: 2,
      ),
      itemBuilder: ((context, index) => WeekdaySelectionItem(
          selectWeekday: weekdaySelection[index],
          itemClicked: () {
            bool response = context
                .read<HeatingProfileProvider>()
                .changeWeekday(
                    widget.intervalIndex, getWeekdayIdentifier(index));
            if (!response) {
              InformationAlert().showAlertDialog(
                  context: context,
                  message: local.weekDaySelected,
                  callback: () {});
            }
          })),
      itemCount: weekdaySelection.length,
    );
  }

  String getWeekdayIdentifier(int index) {
    String identifier;
    if (index == 0) {
      identifier = ThermostatInterface.weekdayMonday;
    } else if (index == 1) {
      identifier = ThermostatInterface.weekdayTuesday;
    } else if (index == 2) {
      identifier = ThermostatInterface.weekdayWednesday;
    } else if (index == 3) {
      identifier = ThermostatInterface.weekdayThursday;
    } else if (index == 4) {
      identifier = ThermostatInterface.weekdayFriday;
    } else if (index == 5) {
      identifier = ThermostatInterface.weekdaySaturday;
    } else {
      identifier = ThermostatInterface.weekdaySunday;
    }
    return identifier;
  }
}
