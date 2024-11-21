// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:wifi_smart_living/bloc/delete_user_account/delete_user_account_bloc.dart';
import 'package:wifi_smart_living/const/const_schedule_id.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/ja/check_tablet.dart';
import 'package:wifi_smart_living/presentation/alert_dialogs/alert_dialog_information.dart';
import 'package:wifi_smart_living/presentation/alert_dialogs/alert_dialog_yes_no.dart';
import 'package:wifi_smart_living/presentation/edit_structures/edit_schedule/edit_schedule_page.dart';
import 'package:wifi_smart_living/presentation/general_widgets/loading_spinner/loading_circle.dart';
import 'package:wifi_smart_living/presentation/general_widgets/popup_menu/popup_menu_widget.dart';
import 'package:wifi_smart_living/presentation/heatingProfile/heating_profile_overview/heating_profile_item.dart';
import 'package:wifi_smart_living/provider/edit_schedule_provider.dart';
import 'package:wifi_smart_living/theme.dart';

import '../../../api_handler/api_treiber/delete_room_helper/delete_room_helper.dart';
import '../../../api_handler/api_treiber/sync/sync_database_entries.dart';
import '../../../const/const_location.dart';
import '../../../provider/heating_profile_provider.dart';
import '../../alert_dialogs/alert_dialog_credentials_changed.dart';
import '../../login/login_page.dart';
import '../heating_profile_management/show_heating_profile_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

///Description
///Show time schedule profiles
///
///Author: J. Anders
///created: 10-01-2023
///changed: 10-01-2023
///
///History:
///
///Notes:
///

class HeatingProfileOverviewContent extends StatelessWidget {
  late LoadingCicle loadingCicle;
  HeatingProfileOverviewContent({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    final syncData = Provider.of<DatabaseSync>(context);
    loadingCicle = LoadingCicle(context: context);
    return BlocConsumer<DeleteDatabaseEntriesBloc, DeleteDatabaseEntriesState>(
      listener: (context, state) {
        if (state is DeleteScheduleFromDatabaseState) {
          DeleteEntryState deleteEntryState = state.state;
          if (deleteEntryState == DeleteEntryState.scheduleSuccesfulDeleted) {
            context
                .read<DatabaseSync>()
                .syncDatabase(ConstLocationidentifier.locationidentifierIndoor);
          } else {
            InformationAlert().showAlertDialog(
                context: context, message: local.oopsError, callback: () {});
          }
        } else if (state is ShowLoadingSpinner) {
          if (state.showLoadingSpinner) {
            loadingCicle.showAnimation(local.deleteScheduleInProgress);
          } else {
            //loadingCicle.animationDismissWithDelay();
            loadingCicle.animationDismiss();
          }
        }
      },
      builder: (context, state) {
        return context.watch<DatabaseSync>().getDatabaseSyncState ==
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
                    .getScheduleById(ConstScheduleId.timeScheduleProfileId)
                    .isEmpty
                ? Center(
                    child: Text(
                      local.noTimeScheduleExist,
                      style: AppTheme.textStyleDefault,
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(Dimens.paddingDefault),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            childAspectRatio: 2 / 1,
                            crossAxisSpacing: 5),
                    itemBuilder: (BuildContext context, int index) =>
                        HeatingProfileItem(
                      scheduleManager: context
                          .watch<DatabaseSync>()
                          .singelton
                          .getScheduleById(
                              ConstScheduleId.timeScheduleProfileId)[index],
                      onTapCallback: () {
                        context.read<HeatingProfileProvider>().initProvider(
                            syncData.singelton.getScheduleById(
                                ConstScheduleId.timeScheduleProfileId)[index]);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: ((context) =>
                                const ShowHeatingprofilePage()),
                            settings: RouteSettings(
                                arguments: context
                                    .read<DatabaseSync>()
                                    .singelton
                                    .getScheduleById(ConstScheduleId
                                        .timeScheduleProfileId)[index])));
                      },
                      menuOptionCalled: (value) async {
                        if (value == PopupMenuOption.editOption) {
                          context
                              .read<EditScheduleProvider>()
                              .initScheduleManager(context
                                  .read<DatabaseSync>()
                                  .singelton
                                  .getScheduleById(ConstScheduleId
                                      .timeScheduleProfileId)[index]);
                          Navigator.of(context)
                              .pushNamed(EditSchedulePage.routName);
                        } else if (value == PopupMenuOption.deleteOption) {
                          var response = await AlertDialogYesNo().zeigeDialog(
                              context: context,
                              message: local.wantToDeleteSchedule,
                              positiveButtontext: local.delete,
                              negativeButtonText: local.cancel);
                          if (response) {
                            context.read<EditScheduleProvider>().getDataChanged;
                            BlocProvider.of<DeleteDatabaseEntriesBloc>(context)
                                .add(DeleteScheduleFromDatabase(
                                    smPublicId: context
                                        .read<DatabaseSync>()
                                        .singelton
                                        .getScheduleById(ConstScheduleId
                                            .timeScheduleProfileId)[index]));
                          }
                        }
                      },
                      heatingprofile: true,
                      tabletUsed: TabletHelper().isTablet(context: context),
                    ),
                    itemCount: context
                        .watch<DatabaseSync>()
                        .singelton
                        .getScheduleById(ConstScheduleId.timeScheduleProfileId)
                        .length,
                  );
      },
    );
  }
}
