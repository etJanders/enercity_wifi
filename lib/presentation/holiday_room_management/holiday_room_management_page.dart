import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wifi_smart_living/bloc/delete_user_account/delete_user_account_bloc.dart';
import 'package:wifi_smart_living/presentation/holiday_room_management/holiday_room_management_content.dart';

import '../../models/database/model_schedule_manager.dart';
import '../../theme.dart';
import '../general_widgets/back_button_widget/back_button_widget.dart';
import '../schedule_room_management/schedule_room_management_content.dart';

class HolidayRoomOverviewPage extends StatelessWidget {
  static const routName = "/holiday_room_overview_page";
  const HolidayRoomOverviewPage({super.key});

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
                local.holidayProfile,
                style: AppTheme.textStyleColored,
              ),
            ],
          ),
        ),
        body: HolidayRoomManagementContent(scheduleManager: scheduleManager),
      ),
    );
  }
}

class HolidayScheduleRoomOverviewPage extends StatelessWidget {
  static const routName = "/schedule_room_overview_page";
  const HolidayScheduleRoomOverviewPage({super.key});

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
              Text(local.holidaySchedule, style: AppTheme.textStyleDefault),
            ],
          ),
        ),
        body: ScheduleRoomManagementContent(scheduleManager: scheduleManager),
      ),
    );
  }
}
