import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wifi_smart_living/bloc/delete_user_account/delete_user_account_bloc.dart';
import 'package:wifi_smart_living/presentation/general_widgets/add_button_app_bar/app_bar_add_widget.dart';
import 'package:wifi_smart_living/presentation/holiday/create_holiday_profile/create_holiday_profile_main.dart';
import 'package:wifi_smart_living/presentation/holiday/overview/holiday_profile_overview_content.dart';

class HolidayProfileOverviewPage extends StatelessWidget {
  const HolidayProfileOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(local.holidayProfile),
        actions: [
          AddWidget(
              onPressCallback: () => Navigator.of(context)
                  .pushNamed(CreateHolidayProfileMainPage.routName))
        ],
      ),
      body: BlocProvider(
        create: (context) => DeleteDatabaseEntriesBloc(),
        child: HolidayProfileOverviewContent(),
      ),
    );
  }
}
