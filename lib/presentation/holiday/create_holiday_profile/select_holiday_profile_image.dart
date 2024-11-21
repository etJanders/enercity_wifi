import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wifi_smart_living/bloc/create_holiday_profile/create_holiday_profile_bloc.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/theme.dart';

import '../../../api_handler/api_treiber/create_new_schedule/create_new_schedule_helper.dart';
import '../../../api_handler/api_treiber/sync/sync_database_entries.dart';
import '../../../const/const_location.dart';
import '../../../core/image_mapping/time_schedule_image_mapping.dart';
import '../../../models/ui/select_structure_image/model_select_image.dart';
import '../../add_new_thermostat/create_new_room/widgets/select_room_image_grid_tile..dart';
import '../../alert_dialogs/alert_dialog_information.dart';
import '../../general_widgets/back_button_widget/back_button_widget.dart';
import '../../general_widgets/click_buttons/click_button_colored.dart';
import '../../general_widgets/loading_spinner/loading_circle.dart';

class CreateHolidayProfileSelectImage extends StatefulWidget {
  final Function callbackNexn;
  const CreateHolidayProfileSelectImage(
      {super.key, required this.callbackNexn});

  @override
  State<CreateHolidayProfileSelectImage> createState() =>
      _CreateHolidayProfileSelectImageState();
}

class _CreateHolidayProfileSelectImageState
    extends State<CreateHolidayProfileSelectImage> {
  String selectedImage = "";
  late List<ModelSelectImage> selectedImageList;

  @override
  void initState() {
    selectedImageList = [
      ModelSelectImage(
          activeImage: 'holida_profile_autumn_enabled.png',
          inactiveImage: 'holida_profile_autumn_disabled.png',
          selected: false),
      ModelSelectImage(
          activeImage: 'holiday_profile_easter_enabled.png',
          inactiveImage: 'holiday_profile_easter_disabled.png',
          selected: false),
      ModelSelectImage(
          activeImage: 'holiday_profile_sailing_enabled.png',
          inactiveImage: 'holiday_profile_sailing_disabled.png',
          selected: false),
      ModelSelectImage(
          activeImage: 'holiday_profile_xmas_enabled.png',
          inactiveImage: 'holiday_profile_xmas_disabled.png',
          selected: false),
      ModelSelectImage(
          activeImage: 'holiday_profile_tent_enabled.png',
          inactiveImage: 'holiday_profile_tent_disabled.png',
          selected: false),
      ModelSelectImage(
          activeImage: 'holiday_profile_skiing_enabled.png',
          inactiveImage: 'holiday_profile_skiing_disabled.png',
          selected: false),
      ModelSelectImage(
          activeImage: 'holiday_profile_summer_enabled.png',
          inactiveImage: 'holiday_profile_summer_disabled.png',
          selected: false),
      ModelSelectImage(
          activeImage: 'holiday_profile_summer_two_enabled.png',
          inactiveImage: 'holiday_profile_summer_two_disabled.png',
          selected: false),
      ModelSelectImage(
          activeImage: 'holiday_profile_camping_enabled.png',
          inactiveImage: 'holiday_profile_camping_disabled.png',
          selected: false),
      ModelSelectImage(
          activeImage: 'holiday_profile_traveling_enabled.png',
          inactiveImage: 'holiday_profile_traveling_disabled.png',
          selected: false),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LoadingCicle loadingCicle = LoadingCicle(context: context);
    AppLocalizations local = AppLocalizations.of(context)!;
    return BlocConsumer<CreateHolidayProfileBloc, CreateHolidayProfileState>(
      listener: (context, state) {
        if (state is CreateHolidayProfileResponse) {
          CreateScheduleState scheduleState = state.state;
          if (scheduleState == CreateScheduleState.noInternetConnection) {
            InformationAlert().showAlertDialog(
                context: context,
                message: local.noInternetConnectionAvaialable,
                callback: () {});
          } else if (scheduleState == CreateScheduleState.generalError) {
            InformationAlert().showAlertDialog(
                context: context, message: local.oopsError, callback: () {});
          } else if (scheduleState == CreateScheduleState.succesfullCreated) {
            var sync = Provider.of<DatabaseSync>(context, listen: false);
            sync.syncDatabase(ConstLocationidentifier.locationidentifierIndoor);
            loadingCicle.animationDismiss();
            InformationAlert().showAlertDialog(
                context: context,
                message: local.holidayProfileSuccesfulCreated,
                callback: () {
                  widget.callbackNexn();
                });
          }
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
                  local.selectSymbol,
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
                  local.selectHolidaySymbolDescription,
                  style: AppTheme.textStyleColored,
                ),
                const SizedBox(
                  height: Dimens.sizedBoxBigDefault,
                ),
                Expanded(
                    child: GridView.builder(
                        itemCount: selectedImageList.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 3 / 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10),
                        itemBuilder: ((context, index) =>
                            SelectRoomImageGridTile(
                                selectImage: selectedImageList[index],
                                onTap: () {
                                  newImageSelected(index);
                                })))),
                const SizedBox(
                  height: Dimens.sizedBoxDefault,
                ),
                ClickButtonFilled(
                    buttonText: local.save,
                    buttonFunktion: () {
                      if (selectedImage.isEmpty) {
                        InformationAlert().showAlertDialog(
                            context: context,
                            message: local.noIconSelected,
                            callback: () {});
                      } else {
                        loadingCicle.showAnimation(local.setupHolidayProfile);
                        BlocProvider.of<CreateHolidayProfileBloc>(context).add(
                            HolidayProfileImageSelected(
                                imageName: TimeScheduleImageMaping()
                                    .getMappiedImageName(selectedImage)));
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

  void newImageSelected(int index) {
    if (index > -1 && index < selectedImageList.length) {
      for (int i = 0; i < selectedImageList.length; i++) {
        selectedImageList[i].selected = false;
      }
      setState(() {
        selectedImageList[index].selected = true;
      });
    }
    selectedImage = selectedImageList[index].activeImage;
  }
}
