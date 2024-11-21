import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/models/database/model_schedule_manager.dart';

import '../../api_handler/api_treiber/delete_room_helper/delete_room_helper.dart';
import '../../api_handler/api_treiber/sync/sync_database_entries.dart';
import '../../bloc/delete_user_account/delete_user_account_bloc.dart';
import '../../const/const_location.dart';
import '../../models/database/model_group_management.dart';
import '../../singelton/helper/api_singelton_helper.dart';
import '../../theme.dart';
import '../alert_dialogs/alert_dialog_information.dart';
import '../alert_dialogs/alert_dialog_yes_no.dart';
import '../general_widgets/click_buttons/click_button_colored.dart';
import '../general_widgets/loading_spinner/loading_circle.dart';
import '../schedule_room_management/schedule_room_grid_tile.dart';

class HolidayRoomManagementContent extends StatelessWidget {
  final ModelScheduleManager scheduleManager;

  const HolidayRoomManagementContent(
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
            Provider.of<DatabaseSync>(context, listen: false)
                .syncDatabase(ConstLocationidentifier.locationidentifierIndoor);
          } else {
            InformationAlert().showAlertDialog(
                context: context, message: local.oopsError, callback: () {});
          }
        } else if (state is ShowLoadingSpinner) {
          if (state.showLoadingSpinner) {
            loadingCicle.showAnimation(local.removeRoomFromHolidayProfile);
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
                local.roomsAddedToHolidayProfile,
                style: AppTheme.textStyleDefault,
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
                              AlertDialogYesNo()
                                  .zeigeDialog(
                                      context: context,
                                      message:
                                          local.removeRoomFromHolidayProfile,
                                      positiveButtontext: local.delete,
                                      negativeButtonText: local.cancel)
                                  .then((value) {
                                if (value) {
                                  BlocProvider.of<DeleteDatabaseEntriesBloc>(
                                          context)
                                      .add(DeleteSingelRoomFromSchedule(
                                          scheduleGroup: ApiSingeltonHelper()
                                              .getHolidayScheduleGroupOfRoom(
                                                  management:
                                                      management[index])));
                                }
                              });
                            },
                            groupManagement: management[index],
                          ),
                          itemCount: management.length,
                        ),
                      )
                    : Center(
                        child: Text(
                          local.noRoomsAddedToHolidayProfile,
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
                    /*
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) =>
                                const AddRoomToSchedulePage()),
                            settings:
                                RouteSettings(arguments: scheduleManager)));*/
                  },
                  width: double.infinity),
            ],
          ),
        );
      },
    );
  }
}
