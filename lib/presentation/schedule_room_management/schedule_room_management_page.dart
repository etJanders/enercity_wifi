// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wifi_smart_living/bloc/delete_user_account/delete_user_account_bloc.dart';
import 'package:wifi_smart_living/models/database/model_schedule_manager.dart';
import 'package:wifi_smart_living/presentation/general_widgets/back_button_widget/back_button_widget.dart';
import 'package:wifi_smart_living/presentation/schedule_room_management/schedule_room_management_content.dart';
import 'package:wifi_smart_living/theme.dart';

class ScheduleRoomOverviewPage extends StatelessWidget {
  static const routName = "/schedule_room_overview_page";
  const ScheduleRoomOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    ModelScheduleManager scheduleManager =
        ModalRoute.of(context)!.settings.arguments as ModelScheduleManager;
    return BlocProvider(
      create: (context) => DeleteDatabaseEntriesBloc(),
      child: Scaffold(
        appBar: AppBar(
          leading: const BackButtonWidget(),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(scheduleManager.scheduleName),
              Text(
                local.timeSchedule,
                style: AppTheme.textStyleDefault,
              ),
            ],
          ),
        ),
        body: ScheduleRoomManagementContent(scheduleManager: scheduleManager),
      ),
    );
  }
}
