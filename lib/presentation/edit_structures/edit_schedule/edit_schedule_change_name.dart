import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_smart_living/api_handler/api_treiber/sync/sync_database_entries.dart';
import 'package:wifi_smart_living/bloc/edit_ui_structures/edit_ui_structures_bloc.dart';
import 'package:wifi_smart_living/const/const_location.dart';
import 'package:wifi_smart_living/core/image_mapping/time_schedule_image_mapping.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/presentation/alert_dialogs/alert_dialog_information.dart';
import 'package:wifi_smart_living/presentation/edit_structures/edit_schedule/schedule_image_widget.dart';
import 'package:wifi_smart_living/presentation/general_widgets/click_buttons/click_button_colored.dart';
import 'package:wifi_smart_living/presentation/general_widgets/click_buttons/click_button_empty.dart';
import 'package:wifi_smart_living/presentation/general_widgets/editTextWidgets/edit_name_change_callback_widget.dart';
import 'package:wifi_smart_living/presentation/general_widgets/loading_spinner/loading_circle.dart';

import '../../../api_handler/api_treiber/update_ui_components/update_ui_components_helper.dart';
import '../../../provider/edit_schedule_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditScheduleChangeNamePage extends StatelessWidget {
  final TextEditingController controller = TextEditingController();
  final Function changeUi;
  EditScheduleChangeNamePage({super.key, required this.changeUi});

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    LoadingCicle loadingCicle = LoadingCicle(context: context);
    controller.text =
        context.watch<EditScheduleProvider>().getScheduleManager.scheduleName;
    return BlocConsumer<EditUiStructuresBloc, EditUiStructuresState>(
      listener: (context, state) {
        loadingCicle.animationDismiss();
        if (state is UpdateUiComponentBlocState) {
          UpdateUIComponentState updateState = state.state;
          if (updateState == UpdateUIComponentState.entrySuccesfulChanged) {
            context
                .read<DatabaseSync>()
                .syncDatabase(ConstLocationidentifier.locationidentifierIndoor);
            InformationAlert().showAlertDialog(
                context: context,
                message: local.message,
                callback: () {
                  Navigator.of(context).pop();
                });
          } else if (updateState ==
              UpdateUIComponentState.noInternetConnection) {
            InformationAlert().showAlertDialog(
                context: context,
                message: local.noInternetConnectionAvaialable,
                callback: () {});
          } else {
            InformationAlert().showAlertDialog(
                context: context, message: local.oopsError, callback: () {});
          }
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            Center(
              child: EditImageWidget(
                imageName: TimeScheduleImageMaping().getScheduleToRoom(context
                    .read<EditScheduleProvider>()
                    .getScheduleManager
                    .scheudleImage),
                onClickCallback: () {
                  changeUi();
                },
              ),
            ),
            const SizedBox(height: Dimens.sizedBoxDefault),
            EditNameCallbackTextInput(
              emailController: controller,
              dataChanged: () {
                FocusScope.of(context).unfocus();
                context
                    .read<EditScheduleProvider>()
                    .changeScheduleName(controller.text);
              },
            ),
            const Spacer(),
            context.watch<EditScheduleProvider>().getDataChanged
                ? ClickButtonFilled(
                    buttonText: local.save,
                    buttonFunktion: () {
                      loadingCicle
                          .showAnimation(local.loadingMessage);
                      BlocProvider.of<EditUiStructuresBloc>(context).add(
                          UpdateUiComponents(
                              databaseModel: context
                                  .read<EditScheduleProvider>()
                                  .getScheduleManager));
                    },
                    width: double.infinity)
                : ClickButton(
                    buttonText: local.save,
                    buttonFunktion: () {},
                    width: double.infinity)
          ],
        );
      },
    );
  }
}
