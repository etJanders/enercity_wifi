import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wifi_smart_living/api_handler/api_treiber/sync/sync_database_entries.dart';
import 'package:wifi_smart_living/bloc/delete_user_account/delete_user_account_bloc.dart';
import 'package:wifi_smart_living/const/const_location.dart';
import 'package:wifi_smart_living/models/database/model_schedule_manager.dart';
import 'package:wifi_smart_living/presentation/alert_dialogs/alert_dialog_yes_no.dart';
import 'package:wifi_smart_living/presentation/general_widgets/loading_spinner/loading_circle.dart';
import 'package:wifi_smart_living/presentation/schedule_room_management/schedule_room_grid_tile.dart';
import 'package:wifi_smart_living/singelton/helper/api_singelton_helper.dart';

import '../../api_handler/api_treiber/delete_room_helper/delete_room_helper.dart';
import '../../const/const_schedule_id.dart';
import '../../dimens.dart';
import '../../models/database/model_group_management.dart';
import '../../theme.dart';
import '../alert_dialogs/alert_dialog_information.dart';
import '../general_widgets/click_buttons/click_button_colored.dart';
import '../schedule_holiday_room_management/add_new_room_to_schedule/add_new_room_to_schedule.dart';

class ScheduleRoomManagementContent extends StatelessWidget {
  final ModelScheduleManager scheduleManager;
  const ScheduleRoomManagementContent(
      {super.key, required this.scheduleManager});

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    LoadingCicle loadingCicle = LoadingCicle(context: context);
    List<ModelGroupManagement> management = context
        .watch<DatabaseSync>()
        .helper
        .groupsOfTimeSchedule(smPubblicId: scheduleManager.entryPublicId);

    return BlocConsumer<DeleteDatabaseEntriesBloc, DeleteDatabaseEntriesState>(
      listener: (context, state) {
        if (state is DeleteScheduleFromDatabaseState) {
          DeleteEntryState responseState = state.state;
          if (responseState == DeleteEntryState.roomSuccesfulDeleted) {
            context
                .read<DatabaseSync>()
                .syncDatabase(ConstLocationidentifier.locationidentifierIndoor);
          } else {
            InformationAlert().showAlertDialog(
                context: context, message: local.oopsError, callback: () {});
          }
        } else if (state is ShowLoadingSpinner) {
          if (state.showLoadingSpinner) {
            if (scheduleManager.scheduleId ==
                ConstScheduleId.timeScheduleProfileId) {
              loadingCicle.showAnimation(local.removeRoomFromHeatingprofile);
            } else {
              loadingCicle.showAnimation(local.removeRoomFromHolidayProfile);
            }
          } else {
            loadingCicle.animationDismissWithDelay();
          }
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(Dimens.paddingDefault),
          child: Column(
            children: [
              Text(
                local.roomsOfHeatingProfile,
                style: AppTheme.textStyleColored,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: Dimens.sizedBoxBigDefault,
              ),
              Expanded(
                child: management.isNotEmpty
                    ? SingleChildScrollView(
                        child: GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  childAspectRatio: 3 / 2,
                                  mainAxisSpacing: 10),
                          itemBuilder: (context, index) => ScheduleRoomTile(
                            deleteRoomFromSchedule: () {
                              if (scheduleManager.scheduleId ==
                                  ConstScheduleId.timeScheduleProfileId) {
                                AlertDialogYesNo()
                                    .zeigeDialog(
                                        context: context,
                                        message: local.heatintProfileRemoveRoom,
                                        positiveButtontext: local.delete,
                                        negativeButtonText: local.cancel)
                                    .then((value) {
                                  if (value) {
                                    BlocProvider.of<DeleteDatabaseEntriesBloc>(
                                            context)
                                        .add(DeleteSingelRoomFromSchedule(
                                            scheduleGroup: ApiSingeltonHelper()
                                                .getHeatingScheduleGroupOfRoom(
                                                    management:
                                                        management[index])));
                                  }
                                });
                              } else if (scheduleManager.scheduleId ==
                                  ConstScheduleId.holidayProfileScheduleId) {
                                AlertDialogYesNo()
                                    .zeigeDialog(
                                        context: context,
                                        message: local.holidayProfileRemoveRoom,
                                        positiveButtontext: local.delete,
                                        negativeButtonText: local.cancel)
                                    .then((value) {
                                  if (value) {
                                    BlocProvider.of<DeleteDatabaseEntriesBloc>(
                                            context)
                                        .add(DeleteSingelRoomFromHolidaySchedule(
                                            scheduleGroup: ApiSingeltonHelper()
                                                .getHolidayScheduleGroupOfRoom(
                                                    management:
                                                        management[index])));
                                  }
                                });
                              }
                            },
                            groupManagement: management[index],
                          ),
                          itemCount: management.length,
                        ),
                      )
                    : Center(
                        child: Text(
                          local.heatingprofileWithoutRooms,
                          style: AppTheme.textStyleDefault,
                          textAlign: TextAlign.center,
                        ),
                      ),
              ),
              const SizedBox(
                height: Dimens.sizedBoxDefault,
              ),
              ClickButtonFilled(
                  buttonText: local.addRoomToSchedule,
                  buttonFunktion: () {
                    if (scheduleManager.scheduleId ==
                        ConstScheduleId.timeScheduleProfileId) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) =>
                                  const AddRoomToSchedulePage()),
                              settings:
                                  RouteSettings(arguments: scheduleManager)));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) =>
                                  const AddRoomToHoldiaySchedulePage()),
                              settings:
                                  RouteSettings(arguments: scheduleManager)));
                    }
                  },
                  width: double.infinity),
            ],
          ),
        );
      },
    );
  }
}
