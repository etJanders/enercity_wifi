import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wifi_smart_living/bloc/create_heating_profile/create_heating_profile_bloc.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/presentation/alert_dialogs/alert_dialog_information.dart';
import 'package:wifi_smart_living/presentation/general_widgets/back_button_widget/back_button_widget.dart';
import 'package:wifi_smart_living/presentation/general_widgets/click_buttons/click_button_colored.dart';
import 'package:wifi_smart_living/presentation/general_widgets/editTextWidgets/edit_name_text_widget.dart';
import 'package:wifi_smart_living/singelton/helper/api_name_helper.dart';
import 'package:wifi_smart_living/theme.dart';

class SetScheduleNamePage extends StatelessWidget {
  final Function nextCallback;
  final TextEditingController textEditingController = TextEditingController();
  SetScheduleNamePage({super.key, required this.nextCallback});

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    return BlocConsumer<CreateHeatingProfileBloc, CreateHeatingProfileState>(
      listener: (context, state) {
        if (state is ScheduleDataSet) {
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
                Text(local.createHeatingProfileTitle),
                Text(
                  local.heatingprofileName,
                  style: AppTheme.textStyleDefault.copyWith(fontSize: 16.0),
                ),
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
                  local.setHeatingprofileName,
                  style: AppTheme.textStyleColored,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: Dimens.sizedBoxBigDefault,
                ),
                EditNameTextInput(
                    emailController: textEditingController,
                    hintText: local.zeitplan),
                const Spacer(),
                ClickButtonFilled(
                    buttonText: local.next,
                    buttonFunktion: () {
                      if (textEditingController.text.isNotEmpty) {
                        if (ApiNameHelper().scheduleNameInUse(
                            newScheduleName: textEditingController.text)) {
                          InformationAlert().showAlertDialog(
                              context: context,
                              message: local.heatingProfileNameDouble,
                              callback: () {});
                        } else {
                          FocusScope.of(context).unfocus();
                          BlocProvider.of<CreateHeatingProfileBloc>(context)
                              .add(ScheduleNameSelected(
                                  scheduleName: textEditingController.text));
                        }
                      } else {
                        InformationAlert().showAlertDialog(
                            context: context,
                            message: local.heatingProfileNoName,
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
