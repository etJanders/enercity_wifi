import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wifi_smart_living/bloc/change_notification/change_notification_bloc.dart';
import 'package:wifi_smart_living/theme.dart';

import 'display_notification_content.dart';

class DisplayNotificationPage extends StatelessWidget {
  static const routName = "/display_notification_page";
  const DisplayNotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (context) => ChangeNotificationBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(local.myUserAccount),
              Text(
                local.notifications,
                style: AppTheme.textStyleDefault,
              )
            ],
          ),
        ),
        body: const DisplayNotificationContent(),
      ),
    );
  }
}
