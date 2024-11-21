import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_smart_living/core/image_mapping/image_name_mapping.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wifi_smart_living/presentation/general_widgets/click_buttons/click_button_colored.dart';
import 'package:wifi_smart_living/presentation/general_widgets/click_buttons/click_button_empty.dart';
import 'package:wifi_smart_living/presentation/general_widgets/editTextWidgets/edit_name_change_callback_widget.dart';
import 'package:wifi_smart_living/provider/edit_room_provider.dart';

import '../../../api_handler/api_treiber/sync/sync_database_entries.dart';
import '../../../api_handler/api_treiber/update_ui_components/update_ui_components_helper.dart';
import '../../../bloc/edit_ui_structures/edit_ui_structures_bloc.dart';
import '../../../const/const_location.dart';
import '../../alert_dialogs/alert_dialog_information.dart';
import '../../general_widgets/loading_spinner/loading_circle.dart';
import '../edit_schedule/schedule_image_widget.dart';

///Description
///Manages the UI to change room settings
///
///Author: J. Anders
///created: 24-01-2023
///changed: 24-01-2023
///
///History:
///
///Notes:
///
class EditRoomStructureContent extends StatelessWidget {
  final Function changeUI;
  final TextEditingController textEditingController = TextEditingController();
  EditRoomStructureContent({super.key, required this.changeUI});

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    LoadingCicle loadingCicle = LoadingCicle(context: context);
    textEditingController.text =
        context.read<EditRoomProvider>().getGroupManagement.groupName;
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
                message: local.roomSettingsSuccesfulChanged,
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
                imageName: ImageMapping().getImageNameToShow(
                  imageName: context
                      .read<EditRoomProvider>()
                      .getGroupManagement
                      .groupImage,
                ),
                onClickCallback: () {
                  changeUI();
                },
              ),
            ),
            const SizedBox(
              height: Dimens.sizedBoxDefault,
            ),
            EditNameCallbackTextInput(
                emailController: textEditingController,
                dataChanged: () {
                  FocusScope.of(context).unfocus();
                  context
                      .read<EditRoomProvider>()
                      .changeRoomName(textEditingController.text);
                }),
            const Spacer(),
            context.watch<EditRoomProvider>().getDataChanged
                ? ClickButtonFilled(
                    buttonText: local.save,
                    buttonFunktion: () {
                      print(
                          'EditRoomStructureContent new name: ${textEditingController.text} ');
                      if (context.read<EditRoomProvider>().getNameChanged) {
                        loadingCicle.showAnimation(local.updateEntryInProgress);
                        BlocProvider.of<EditUiStructuresBloc>(context).add(
                            UpdateUiComponents(
                                databaseModel: context
                                    .read<EditRoomProvider>()
                                    .getGroupManagement));
                      } else {
                        loadingCicle.showAnimation(local.updateEntryInProgress);
                        BlocProvider.of<EditUiStructuresBloc>(context).add(
                            UpdateUiComponents(
                                databaseModel: context
                                    .read<EditRoomProvider>()
                                    .getGroupManagement));
                      }
                    },
                    width: double.infinity)
                : ClickButton(
                    buttonText: local.save,
                    buttonFunktion: () {},
                    width: double.infinity),
          ],
        );
      },
    );
  }
}
