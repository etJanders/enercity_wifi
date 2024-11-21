import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wifi_smart_living/bloc/create_holiday_profile/create_holiday_profile_bloc.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/theme.dart';

import '../../../singelton/helper/api_name_helper.dart';
import '../../alert_dialogs/alert_dialog_information.dart';
import '../../general_widgets/back_button_widget/back_button_widget.dart';
import '../../general_widgets/click_buttons/click_button_colored.dart';
import '../../general_widgets/editTextWidgets/edit_name_text_widget.dart';

class CreateHolidayProfileSelectNamePage extends StatelessWidget {
  final Function nextCallback;
  final TextEditingController textEditingController = TextEditingController();

  CreateHolidayProfileSelectNamePage({super.key, required this.nextCallback});

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    return BlocConsumer<CreateHolidayProfileBloc, CreateHolidayProfileState>(
      listener: (context, state) {
        if (state is ProfileDataSet) {
          nextCallback();
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: const BackButtonWidget(),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(local.createHolidayProfile),
                Text(
                  local.holidayProfileName,
                  style: AppTheme.textStyleDefault.copyWith(fontSize: 16.0),
                )
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(Dimens.paddingDefault),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: Dimens.sizedBoxDefault,
                ),
                Text(
                  local.setHolidayprofileName,
                  style: AppTheme.textStyleColored,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: Dimens.sizedBoxBigDefault,
                ),
                EditNameTextInput(
                    emailController: textEditingController,
                    hintText: local.holidayProfile),
                const Spacer(),
                ClickButtonFilled(
                    buttonText: local.next,
                    buttonFunktion: () {
                      if (textEditingController.text.isNotEmpty) {
                        if (ApiNameHelper().holidayNameInUse(
                            newProfileName: textEditingController.text)) {
                          InformationAlert().showAlertDialog(
                              context: context,
                              message: local.holidayNameDouble,
                              callback: () {});
                        } else {
                          FocusScope.of(context).unfocus();
                          BlocProvider.of<CreateHolidayProfileBloc>(context)
                              .add(HolidayProfileNameSelected(
                                  profileName: textEditingController.text));
                        }
                      } else {
                        InformationAlert().showAlertDialog(
                            context: context,
                            message: local.holidayProfileNoName,
                            callback: () {});
                      }
                    },
                    width: double.infinity)
              ],
            ),
          ),
        );
      },
    );
  }
}
