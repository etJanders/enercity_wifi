// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wifi_smart_living/bloc/send_schedule/send_schedule_bloc.dart';
import 'package:wifi_smart_living/presentation/general_widgets/back_button_widget/back_button_widget.dart';
import 'package:wifi_smart_living/presentation/heatingProfile/heating_profile_management/show_heating_profile_content.dart';
import 'package:wifi_smart_living/presentation/schedule_room_management/schedule_room_management_page.dart';
import 'package:wifi_smart_living/provider/heating_profile_provider.dart';

import '../../../theme.dart';

///Description
///Page to show a new heating profile
///
///Author: J. Anders
///created: 10-01-2023
///changed: 10-01-2023
///
///History:
///
///Notes:
///
class ShowHeatingprofilePage extends StatefulWidget {
  static const routName = "/show_heating_profile_page";
  const ShowHeatingprofilePage({super.key});

  @override
  State<ShowHeatingprofilePage> createState() => _ShowHeatingprofilePageState();
}

class _ShowHeatingprofilePageState extends State<ShowHeatingprofilePage> {
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
              Text(local.heatinProfile),
              Text(
                context
                    .read<HeatingProfileProvider>()
                    .getScheduleManager
                    .scheduleName,
                style: AppTheme.textStyleDefault.copyWith(fontSize: 16.0),
              ),
            ],
          ),
          actions: [
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ScheduleRoomOverviewPage(),
                        settings: RouteSettings(
                            arguments: context
                                .read<HeatingProfileProvider>()
                                .getScheduleManager)));
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
        body: const ShowHeatingProfileContent(),
      ),
    );
  }
}
