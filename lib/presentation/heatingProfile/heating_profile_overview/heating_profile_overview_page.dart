import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wifi_smart_living/bloc/delete_user_account/delete_user_account_bloc.dart';
import 'package:wifi_smart_living/presentation/general_widgets/add_button_app_bar/app_bar_add_widget.dart';
import 'package:wifi_smart_living/presentation/heatingProfile/createNewProfile/create_heating_profile.dart';

import 'heating_profile_overview_content.dart';

///Description
///Page manages the heating profiles
///
///Author: J. Anders
///created: 09-01-2023
///changed: 09-01-2023
///
///History:
///
///Notes
class HeatingprofileOverviewPage extends StatelessWidget {
  const HeatingprofileOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) => DeleteDatabaseEntriesBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(local.heatinProfile),
          actions: [
            AddWidget(
                onPressCallback: () => Navigator.of(context)
                    .pushNamed(CreateHeatingProfilePage.routName))
          ],
        ),
        body: HeatingProfileOverviewContent(),
      ),
    );
  }
}
