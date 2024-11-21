// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:interval_time_picker/interval_time_picker.dart';
import 'package:interval_time_picker/models/visible_step.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/presentation/alert_dialogs/alert_dialog_information.dart';
import 'package:wifi_smart_living/presentation/general_widgets/click_buttons/click_button_colored.dart';
import 'package:wifi_smart_living/presentation/general_widgets/click_buttons/click_button_empty.dart';
import 'package:wifi_smart_living/presentation/holiday/widgets/date_time_box.dart';
import 'package:wifi_smart_living/presentation/holiday/widgets/temperature_box.dart';
import 'package:wifi_smart_living/provider/holiday_profile_provider.dart';
import 'package:wifi_smart_living/theme.dart';

import '../../../api_handler/api_treiber/heating_profile/update_heating_profile_helper.dart';
import '../../../api_handler/api_treiber/sync/sync_database_entries.dart';
import '../../../bloc/send_schedule/send_schedule_bloc.dart';
import '../../../const/const_location.dart';
import '../../../converter/hex_bin_converter.dart';
import '../../../validation/general/data_length_validator.dart';
import '../../alert_dialogs/select_temperature_alert.dart';
import '../../general_widgets/loading_spinner/loading_circle.dart';

//Todo translation
class ShowHolidayProfilConetnt extends StatelessWidget {
  const ShowHolidayProfilConetnt({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    final LoadingCicle loadingCicle = LoadingCicle(context: context);
    return BlocConsumer<SendScheduleBloc, SendScheduleState>(
      listener: (context, state) {
        loadingCicle.animationDismiss();
        if (state is MqttConnectionError) {
          InformationAlert().showAlertDialog(
              context: context, message: local.oopsError, callback: () {});
        } else if (state is UpdateScheduleDatabase) {
          UpdateTimeScheduleState updateState = state.updateState;
          if (updateState == UpdateTimeScheduleState.noInternetConnection) {
            InformationAlert().showAlertDialog(
                context: context,
                message: local.noInternetConnectionAvaialable,
                callback: () {});
          } else if (updateState == UpdateTimeScheduleState.allEntiresUpdated) {
            context
                .read<DatabaseSync>()
                .syncDatabase(ConstLocationidentifier.locationidentifierIndoor);
            InformationAlert().showAlertDialog(
                context: context,
                message: local.holidayProfileSuccesfulSend,
                callback: () {
                  Navigator.of(context).pop();
                });
          } else {
            InformationAlert().showAlertDialog(
                context: context, message: local.oopsError, callback: () {});
          }
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(Dimens.paddingDefault),
          child: Column(
            children: [
              const SizedBox(
                height: Dimens.sizedBoxBigDefault,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      HolidayDateTimeBox(
                        startDate: true,
                        changeDate: () async {
                          DateTimeRange? dateRange = await showDateRangePicker(
                            context: context,
                            initialEntryMode: DatePickerEntryMode.calendarOnly,
                            firstDate: DateTime(DateTime.now().year),
                            lastDate: DateTime((DateTime.now().year + 2)),
                            builder: (context, child) => Theme(
                                data: ThemeData.light().copyWith(
                                  scaffoldBackgroundColor: AppTheme.hintergrund,
                                  textTheme: Theme.of(context).textTheme.apply(
                                      bodyColor: AppTheme.textDarkGrey,
                                      displayColor: AppTheme.textDarkGrey),
                                  colorScheme: const ColorScheme.light(
                                      primary: AppTheme.violet,
                                      onPrimary: AppTheme.schriftfarbe,
                                      secondary: AppTheme.textLightGrey),
                                ),
                                child: child!),
                          );

                          if (dateRange != null) {
                            DateTime startTime = dateRange.start;
                            DateTime endTime = dateRange.end;
                            if (startTime.day == endTime.day &&
                                startTime.month == endTime.month &&
                                startTime.year == endTime.year) {
                              InformationAlert().showAlertDialog(
                                  context: context,
                                  message: local.starDateSameLikeEndDate,
                                  callback: () {});
                            } else {
                              context
                                  .read<HolidayProfileProvider>()
                                  .setNewDate(true, dateRange.start);
                              context
                                  .read<HolidayProfileProvider>()
                                  .setNewDate(false, dateRange.end);
                            }
                          }
                        },
                        changeTime: () async {
                          TimeOfDay? response = await showIntervalTimePicker(
                              context: context,
                              interval: 60,
                              visibleStep: VisibleStep.sixtieth,
                              initialTime: context
                                  .read<HolidayProfileProvider>()
                                  .getHolidayProfile
                                  .endTime);

                          if (response != null) {
                            context
                                .read<HolidayProfileProvider>()
                                .setNewTime(true, response);
                          }
                        },
                      ),
                      const SizedBox(
                        height: Dimens.sizedBoxDefault,
                      ),
                      HolidayDateTimeBox(
                        startDate: false,
                        changeDate: () async {
                          DateTimeRange? dateRange = await showDateRangePicker(
                            context: context,
                            initialEntryMode: DatePickerEntryMode.calendarOnly,
                            firstDate: DateTime(DateTime.now().year),
                            lastDate: DateTime((DateTime.now().year) + 2),
                            builder: (context, child) => Theme(
                                data: ThemeData.light().copyWith(
                                  scaffoldBackgroundColor: AppTheme.hintergrund,
                                  textTheme: Theme.of(context).textTheme.apply(
                                      bodyColor: AppTheme.textDarkGrey,
                                      displayColor: AppTheme.textDarkGrey),
                                  colorScheme: const ColorScheme.light(
                                      primary: AppTheme.violet,
                                      onPrimary: AppTheme.schriftfarbe,
                                      secondary: AppTheme.textLightGrey),
                                ),
                                child: child!),
                          );
                          if (dateRange != null) {
                            DateTime startTime = dateRange.start;
                            DateTime endTime = dateRange.end;
                            if (startTime.day == endTime.day &&
                                startTime.month == endTime.month &&
                                startTime.year == endTime.year) {
                              InformationAlert().showAlertDialog(
                                  context: context,
                                  message: local.starDateSameLikeEndDate,
                                  callback: () {});
                            } else {
                              context
                                  .read<HolidayProfileProvider>()
                                  .setNewDate(true, dateRange.start);
                              context
                                  .read<HolidayProfileProvider>()
                                  .setNewDate(false, dateRange.end);
                            }
                          }
                        },
                        changeTime: () async {
                          TimeOfDay? response = await showIntervalTimePicker(
                              context: context,
                              interval: 60,
                              visibleStep: VisibleStep.sixtieth,
                              initialTime: context
                                  .read<HolidayProfileProvider>()
                                  .getHolidayProfile
                                  .endTime);

                          if (response != null) {
                            context
                                .read<HolidayProfileProvider>()
                                .setNewTime(false, response);
                          }
                        },
                      ),
                      const SizedBox(
                        height: Dimens.sizedBoxDefault,
                      ),
                      TemperatureBox(
                        changeTemperature: () {
                          int temperature = context
                              .read<HolidayProfileProvider>()
                              .getHolidayProfile
                              .temperature;
                          SelectTemperatureAlert().showAlertDialog(
                              context: context,
                              callback: (value) {
                                context
                                    .read<HolidayProfileProvider>()
                                    .changeTemperature(
                                        HexBinConverter.convertHexStringToInt(
                                            hexString: value));
                              },
                              titleText: HexBinConverter.convertIntToHex(
                                  DataLengh.dataLengthTwo, temperature),
                              positiveButtontext: local.okay,
                              negativeButtonText: local.cancel);
                        },
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: Dimens.sizedBoxDefault,
              ),
              context.watch<HolidayProfileProvider>().getDataChanged
                  ? ClickButton(
                      buttonText: local.save,
                      buttonFunktion: () {
                        loadingCicle.showAnimation(local.sendHolidayProfile);
                        BlocProvider.of<SendScheduleBloc>(context).add(
                            SendNewHolidayProfiel(
                                smPublicId: context
                                    .read<HolidayProfileProvider>()
                                    .getSchedulemanager
                                    .entryPublicId,
                                holidayProfile: context
                                    .read<HolidayProfileProvider>()
                                    .getHolidayProfile));
                      },
                      width: double.infinity)
                  : ClickButtonFilled(
                      buttonText: local.save,
                      buttonFunktion: () {},
                      width: double.infinity)
            ],
          ),
        );
      },
    );
  }
}
