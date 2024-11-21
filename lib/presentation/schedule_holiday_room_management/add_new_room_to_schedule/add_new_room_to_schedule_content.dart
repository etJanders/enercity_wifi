import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wifi_smart_living/api_handler/api_treiber/add_room_to_schedule/add_rooms_to_schedule_helper.dart';
import 'package:wifi_smart_living/api_handler/api_treiber/sync/sync_database_entries.dart';
import 'package:wifi_smart_living/bloc/add_room_to_schedule/add_room_to_schedule_bloc.dart';
import 'package:wifi_smart_living/const/const_location.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/presentation/alert_dialogs/alert_dialog_information.dart';
import 'package:wifi_smart_living/presentation/general_widgets/click_buttons/click_button_colored.dart';
import 'package:wifi_smart_living/presentation/general_widgets/click_buttons/click_button_empty.dart';
import 'package:wifi_smart_living/presentation/general_widgets/loading_spinner/loading_circle.dart';
import 'package:wifi_smart_living/provider/holiday_profile_provider.dart';
import 'package:wifi_smart_living/theme.dart';

import '../../../const/const_schedule_id.dart';
import '../../../models/database/model_group_management.dart';
import '../../general_widgets/radio_list_tile/radio_list_tile.dart';

class AddRoomToHolidayScheduleContent extends StatefulWidget {
  final String smPublicId;
  const AddRoomToHolidayScheduleContent({super.key, required this.smPublicId});

  @override
  State<AddRoomToHolidayScheduleContent> createState() =>
      _AddRoomToScheduleContentState();
}

class _AddRoomToScheduleContentState
    extends State<AddRoomToHolidayScheduleContent> {
  List<String> selectedRooms = [];
  @override
  Widget build(BuildContext context) {
    LoadingCicle loadingCicle = LoadingCicle(context: context);
    AppLocalizations local = AppLocalizations.of(context)!;
    return BlocListener<AddRoomToScheduleBloc, AddRoomToScheduleState>(
      listener: (context, state) {
        loadingCicle.animationDismiss();
        if (state is AddRoomToScheduleResponse) {
          AddRoomsToScheduleHelperState helperState = state.state;
          if (helperState ==
              AddRoomsToScheduleHelperState.noInternetConnection) {
            InformationAlert().showAlertDialog(
                context: context,
                message: local.noInternetConnectionAvaialable,
                callback: () {});
          } else if (helperState ==
              AddRoomsToScheduleHelperState.generalerror) {
            InformationAlert().showAlertDialog(
                context: context,
                message: AddRoomsToScheduleHelperState.generalerror.name,
                callback: () {});
          } else if (helperState ==
              AddRoomsToScheduleHelperState.succesfullAdded) {
            context
                .read<DatabaseSync>()
                .syncDatabase(ConstLocationidentifier.locationidentifierIndoor);

            InformationAlert().showAlertDialog(
                context: context,
                message: local.roomsAddedToHolidayProfile,
                callback: () {
                  Navigator.of(context).pop();
                });
          } else {
            InformationAlert().showAlertDialog(
                context: context,
                message: AddRoomsToScheduleHelperState.generalerror.name,
                callback: () {});
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(Dimens.paddingDefault),
        child: Column(
          children: [
            Text(
              local.selectRoomsForHolidayProfile,
              style: AppTheme.textStyleColored,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Expanded(
                child: context
                        .read<DatabaseSync>()
                        .helper
                        .getGroupsWithoutHolidayProfile()
                        .isEmpty
                    ? Center(
                        child: Text(
                          local.allRoomsEditToHeatingProfile,
                          textAlign: TextAlign.center,
                          style: AppTheme.textStyleDefault,
                        ),
                      )
                    : ListView.separated(
                        itemBuilder: (BuildContext context, int index) =>
                            RadioListTileItem(
                                groupManagement: context
                                    .read<DatabaseSync>()
                                    .helper
                                    .getGroupsWithoutHolidaySchedule()[index],
                                itemClicked: () {
                                  addOrRemoveNewRoom(context
                                          .read<DatabaseSync>()
                                          .helper
                                          .getGroupsWithoutHolidaySchedule()[
                                      index]);
                                }),
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(
                              color: AppTheme.textDarkGrey,
                            ),
                        itemCount: context
                            .read<DatabaseSync>()
                            .helper
                            .getGroupsWithoutHolidaySchedule()
                            .length)),
            const SizedBox(height: 10),
            selectedRooms.isEmpty
                ? ClickButton(
                    buttonText: local.save,
                    buttonFunktion: () {},
                    width: double.infinity)
                : ClickButtonFilled(
                    buttonText: local.save,
                    buttonFunktion: () {
                      loadingCicle.showAnimation(
                          local.addRoomsToHolidayScheduleInProgress);
                      BlocProvider.of<AddRoomToScheduleBloc>(context).add(
                          AddRoomsToHolidaySchedule(
                              groupIds: selectedRooms,
                              smPublicId: widget.smPublicId,
                              type: ConstScheduleId.holidayProfileScheduleId,
                              holidayProfile: context
                                  .read<HolidayProfileProvider>()
                                  .getHolidayProfile));
                    },
                    width: double.infinity),
          ],
        ),
      ),
    );
  }

  void addOrRemoveNewRoom(ModelGroupManagement management) {
    setState(() {
      if (selectedRooms.contains(management.groupId)) {
        selectedRooms.remove(management.groupId);
      } else {
        selectedRooms.add(management.groupId);
      }
    });
  }
}
