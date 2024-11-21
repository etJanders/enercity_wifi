import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wifi_smart_living/presentation/general_widgets/back_button_widget/back_button_widget.dart';
import 'package:wifi_smart_living/presentation/holiday/set_holiday_profile/show_hoilday_profile_content.dart';
import 'package:wifi_smart_living/provider/holiday_profile_provider.dart';
import 'package:wifi_smart_living/theme.dart';

import '../../../bloc/send_schedule/send_schedule_bloc.dart';
import '../../holiday_room_management/holiday_room_management_page.dart';

class ShowHolidayProfilePage extends StatefulWidget {
  static const routName = '/show_holiday_profile';

  const ShowHolidayProfilePage({super.key});
  @override
  State<ShowHolidayProfilePage> createState() => _ShowHolidayprofilePageState();
}

class _ShowHolidayprofilePageState extends State<ShowHolidayProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) => SendScheduleBloc(),
      child: Scaffold(
        backgroundColor: AppTheme.hintergrund,
        appBar: AppBar(
          leading: const BackButtonWidget(),
          backgroundColor: AppTheme.hintergrund,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(local.holidaySettings),
            ],
          ),
          actions: [
            InkWell(
              onTap: () {
                print("tapped");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const HolidayScheduleRoomOverviewPage(),
                        settings: RouteSettings(
                            arguments: context
                                .read<HolidayProfileProvider>()
                                .getSchedulemanager)));
              },
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                width: 35,
                height: 24,
                child: const Center(
                  child: Icon(
                    Icons.menu,
                    color: AppTheme.violet,
                  ),
                ),
              ),
            )
          ],
        ),
        body: const ShowHolidayProfilConetnt(),
      ),
    );
  }
}
