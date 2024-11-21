import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wifi_smart_living/api_handler/api_treiber/user_management/get_self_helper.dart';
import 'package:wifi_smart_living/bloc/delete_user_account/delete_user_account_bloc.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/presentation/general_widgets/back_button_widget/back_button_widget.dart';
import 'package:wifi_smart_living/presentation/user_account_management/user_account_management_content.dart';
import 'package:wifi_smart_living/singelton/api_singelton.dart';

///Description
///Page Definition of User Account Management
///
///Author: J. Anders
///created: 30-11-2022
///changed: 23-02-2023
///
///History:
///23-02-2023 call get self if page is called to get information about notification state
///           maybe notification state is changed afduring app is in background.
///
///Notes:
///
class UserAccountManagementPage extends StatelessWidget {
  static const String routName = "/user_account_management";

  const UserAccountManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    GetSelfHelper()
        .callGetSelf(
            token: ApiSingelton().getModelAccessToken,
            password: ApiSingelton().getDatabaseUserModel.userPassowrd)
        .then((value) =>
            print('UserAccountManagementPage build() -> getself: $value'));
    return BlocProvider(
      create: (context) => DeleteDatabaseEntriesBloc(),
      child: Scaffold(
          appBar: AppBar(
            leading: const BackButtonWidget(),
            title: Text(local.myUserAccount),
          ),
          body: const Padding(
            padding: EdgeInsets.all(Dimens.paddingDefault),
            child: UserAccountManagementContent(),
          )),
    );
  }
}
