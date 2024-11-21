import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wifi_smart_living/api_handler/api_treiber/sync/sync_database_entries.dart';
import 'package:wifi_smart_living/const/const_location.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/presentation/general_widgets/click_buttons/click_button_colored.dart';
import 'package:wifi_smart_living/presentation/general_widgets/click_buttons/click_button_grey.dart';
import 'package:wifi_smart_living/presentation/general_widgets/loading_spinner/loading_circle.dart';

import '../../../api_handler/api_treiber/heating_profile/update_heating_profile_helper.dart';
import '../../../bloc/send_schedule/send_schedule_bloc.dart';
import '../../../provider/heating_profile_provider.dart';
import '../../alert_dialogs/alert_dialog_information.dart';
import '../../general_widgets/click_buttons/click_button_empty.dart';
import '../profile_widgets/intervall_widget.dart';

class ShowHeatingProfileContent extends StatefulWidget {
  //Todo translation
  const ShowHeatingProfileContent({super.key});

  @override
  State<ShowHeatingProfileContent> createState() =>
      _ShowHeatingProfileContentState();
}

class _ShowHeatingProfileContentState extends State<ShowHeatingProfileContent> {
  int anzahlIntervalle = 0;

  @override
  Widget build(BuildContext context) {
    final LoadingCicle loadingCicle = LoadingCicle(context: context);
    AppLocalizations local = AppLocalizations.of(context)!;
    anzahlIntervalle =
        context.watch<HeatingProfileProvider>().getAnzahlIntervalle;
    return BlocConsumer<SendScheduleBloc, SendScheduleState>(
      listener: (context, state) {
        loadingCicle.animationDismiss();
        if (state is MqttConnectionError) {
          InformationAlert().showAlertDialog(
              context: context,
              message: local.noInternetConnectionAvaialable,
              callback: () {});
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
                message: local.timeScheduleSuccesfulSent,
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
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: ((context, index) =>
                              HeatingprofileIntervalWidget(
                                intervalIndex: index,
                              )),
                          separatorBuilder: ((context, index) =>
                              const Divider()),
                          itemCount: anzahlIntervalle),
                      const SizedBox(
                        height: Dimens.sizedBoxDefault,
                      ),
                      context
                              .watch<HeatingProfileProvider>()
                              .getNewIntervallsAllowed
                          ? ClickButtonGrey(
                              buttonText: local.addDay,
                              buttonFunktion: () {
                                Provider.of<HeatingProfileProvider>(context,
                                        listen: false)
                                    .changeAnzahlIntervalle();
                              },
                              width: double.infinity)
                          : Container()
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: Dimens.sizedBoxDefault,
              ),
              context.watch<HeatingProfileProvider>().getDataChanged
                  ? ClickButton(
                      buttonText: local.save,
                      buttonFunktion: () {
                        if (context
                            .read<HeatingProfileProvider>()
                            .schaltzeitenIntervalle
                            .isEmpty) {
                          InformationAlert().showAlertDialog(
                              context: context,
                              message: local.setAnInterval,
                              callback: () {});
                        } else if (!context
                            .read<HeatingProfileProvider>()
                            .alleSchaltzeitenValide()) {
                          InformationAlert().showAlertDialog(
                              context: context,
                              message: local.wrongTimeItem,
                              callback: () {});
                        } else if (!context
                            .read<HeatingProfileProvider>()
                            .weekdaysSelected()) {
                          InformationAlert().showAlertDialog(
                              context: context,
                              message: local.selectWeekDay,
                              callback: () {});
                        } else {
                          loadingCicle.showAnimation(local.sendHeatingProfile);
                          BlocProvider.of<SendScheduleBloc>(context).add(
                              SendNewSchedule(
                                  smPublicId: context
                                      .read<HeatingProfileProvider>()
                                      .getScheduleManager
                                      .entryPublicId,
                                  scheduleMap: context
                                      .read<HeatingProfileProvider>()
                                      .getScheduleMap()));
                        }
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
