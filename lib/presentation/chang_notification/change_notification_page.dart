import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wifi_smart_living/bloc/change_notification/change_notification_bloc.dart';
import 'package:wifi_smart_living/presentation/chang_notification/change_notification_content.dart';
import 'package:wifi_smart_living/presentation/general_widgets/back_button_widget/back_button_widget.dart';
import 'package:wifi_smart_living/theme.dart';

class ChangeNotificationPage extends StatelessWidget {
  static const routName = "/change_notification_page";
  const ChangeNotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (context) => ChangeNotificationBloc(),
      child: Scaffold(
        appBar: AppBar(
          leading: const BackButtonWidget(),
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
        body: const ChangeNotificationContent(),
      ),
    );
  }
}
