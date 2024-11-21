// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wifi_smart_living/bloc/delete_user_account/delete_user_account_bloc.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/presentation/alert_dialogs/alert_dialog_yes_no.dart';
import 'package:wifi_smart_living/presentation/general_widgets/loading_spinner/loading_circle.dart';
import 'package:wifi_smart_living/presentation/holiday/set_holiday_profile/show_holiday_profile_page.dart';
import 'package:wifi_smart_living/provider/holiday_profile_provider.dart';

import '../../../api_handler/api_treiber/delete_room_helper/delete_room_helper.dart';
import '../../../api_handler/api_treiber/sync/sync_database_entries.dart';
import '../../../const/const_location.dart';
import '../../../const/const_schedule_id.dart';
import '../../../provider/edit_schedule_provider.dart';
import '../../../theme.dart';
import '../../alert_dialogs/alert_dialog_credentials_changed.dart';
import '../../alert_dialogs/alert_dialog_information.dart';
import '../../edit_structures/edit_schedule/edit_schedule_page.dart';
import '../../general_widgets/popup_menu/popup_menu_widget.dart';
import '../../login/login_page.dart';
import 'holiday_profile_item.dart';

///Description
///Overview of created Holiday Profiles
///
///Author:
///J. Anders
///created: 19-01-2023
///changed: 19-01-2023
///
///History:
///
///Notes:
///
class HolidayProfileOverviewContent extends StatelessWidget {
  late LoadingCicle loadingCicle;
  HolidayProfileOverviewContent({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    loadingCicle = LoadingCicle(context: context);
    return BlocConsumer<DeleteDatabaseEntriesBloc, DeleteDatabaseEntriesState>(
      listener: (context, state) {
        if (state is ShowLoadingSpinner) {
          if (state.showLoadingSpinner) {
            loadingCicle.showAnimation(local.deletingHolidayProfile);
          } else {
            loadingCicle.animationDismissWithDelay();
          }
        } else if (state is DeleteScheduleFromDatabaseState) {
          DeleteEntryState deleteEntryState = state.state;
          if (deleteEntryState == DeleteEntryState.scheduleSuccesfulDeleted) {
            context
                .read<DatabaseSync>()
                .syncDatabase(ConstLocationidentifier.locationidentifierIndoor);
          } else {
            InformationAlert().showAlertDialog(
                context: context, message: local.oopsError, callback: () {});
          }
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(Dimens.paddingDefault),
          child: context.watch<DatabaseSync>().getDatabaseSyncState ==
                  DatabaseSyncState.credentialsWrong
              ? Center(
                  child: AlertDialogCredentialsChanged()
                      .showAlertDialogWidget(context, () {
                    Navigator.of(context).popAndPushNamed(LoginPage.routName);
                  }),
                )
              : context
                      .watch<DatabaseSync>()
                      .singelton
                      .getScheduleById(ConstScheduleId.holidayProfileScheduleId)
                      .isEmpty
                  ? Center(
                      child: Text(
                        local.noHolidayProfileExist,
                        style: AppTheme.textStyleDefault,
                      ),
                    )
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              childAspectRatio: 2 / 1,
                              crossAxisSpacing: 5),
                      itemBuilder: ((context, index) => HolidayProfileItem(
                            scheduleManager: context
                                .watch<DatabaseSync>()
                                .singelton
                                .getScheduleById(ConstScheduleId
                                    .holidayProfileScheduleId)[index],
                            onTapCallback: () {
                              context
                                  .read<HolidayProfileProvider>()
                                  .initProvider(
                                      manager: context
                                              .read<DatabaseSync>()
                                              .singelton
                                              .getScheduleById(ConstScheduleId
                                                  .holidayProfileScheduleId)[
                                          index]);
                              Navigator.of(context)
                                  .pushNamed(ShowHolidayProfilePage.routName);
                            },
                            menuOptionCalled: (value) async {
                              if (value == PopupMenuOption.editOption) {
                                context
                                    .read<EditScheduleProvider>()
                                    .initScheduleManager(context
                                        .read<DatabaseSync>()
                                        .singelton
                                        .getScheduleById(ConstScheduleId
                                            .holidayProfileScheduleId)[index]);
                                Navigator.of(context)
                                    .pushNamed(EditSchedulePage.routName);
                              } else if (value ==
                                  PopupMenuOption.deleteOption) {
                                var response = await AlertDialogYesNo()
                                    .zeigeDialog(
                                        context: context,
                                        message:
                                            local.areYouShureToDeleteHoliday,
                                        positiveButtontext: local.delete,
                                        negativeButtonText: local.cancel);
                                if (response) {
                                  BlocProvider.of<DeleteDatabaseEntriesBloc>(
                                          context)
                                      .add(DeleteHolidayScheduleFromDatabase(
                                          smPublicId: context
                                                  .read<DatabaseSync>()
                                                  .singelton
                                                  .getScheduleById(ConstScheduleId
                                                      .holidayProfileScheduleId)[
                                              index]));
                                }
                              }
                            },
                            heatingprofile: false,
                          )),
                      itemCount: context
                          .watch<DatabaseSync>()
                          .singelton
                          .getScheduleById(
                              ConstScheduleId.holidayProfileScheduleId)
                          .length,
                    ),
        );
      },
    );
  }
}
