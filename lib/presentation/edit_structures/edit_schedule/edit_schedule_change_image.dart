import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wifi_smart_living/presentation/general_widgets/click_buttons/click_button_colored.dart';
import 'package:wifi_smart_living/theme.dart';

import '../../../core/image_mapping/time_schedule_image_mapping.dart';
import '../../../dimens.dart';
import '../../../models/ui/select_structure_image/model_select_image.dart';
import '../../../provider/edit_schedule_provider.dart';
import '../../add_new_thermostat/create_new_room/widgets/select_room_image_grid_tile..dart';

class EditScheduleChangeImage extends StatefulWidget {
  final Function changeUi;
  const EditScheduleChangeImage({super.key, required this.changeUi});

  @override
  State<EditScheduleChangeImage> createState() =>
      _EditScheduleChangeImageState();
}

class _EditScheduleChangeImageState extends State<EditScheduleChangeImage> {
  late List<ModelSelectImage> selectedImageHeatingList;
  late List<ModelSelectImage> selectedImageHolidayList;
  late List<ModelSelectImage> selectedImageList;
  late String selectedImageName;

  @override
  void initState() {
    selectedImageHeatingList = [
      ModelSelectImage(
          activeImage: 'room_icon_heating_profile_one_enabled.png',
          inactiveImage: 'room_icon_heating_profile_one_disabled.png',
          selected: false),
      ModelSelectImage(
          activeImage: 'room_icon_heating_profile_two_enabled.png',
          inactiveImage: 'room_icon_heating_profile_two_disabled.png',
          selected: false),
      /*
      ModelSelectImage(
          activeImage: 'room_icon_bathroom_enabled_flutter.png',
          inactiveImage: 'room_icon_bathroom_disabled_flutter.png',
          selected: false),
      ModelSelectImage(
          activeImage: 'room_icon_child_room_enabled_flutter.png',
          inactiveImage: 'room_icon_child_room_disabled_flutter.png',
          selected: false),
      ModelSelectImage(
          activeImage: 'room_icon_office_enabled_flutter.png',
          inactiveImage: 'room_icon_office_disabled_flutter.png',
          selected: false),
      ModelSelectImage(
          activeImage: 'room_icon_dining_room_enabled_flutter.png',
          inactiveImage: 'room_icon_dining_room_disabled_flutter.png',
          selected: false),
      ModelSelectImage(
          activeImage: 'room_icon_kitchen_enabled_flutter.png',
          inactiveImage: 'room_icon_kitchen_disabled_flutter.png',
          selected: false),
      ModelSelectImage(
          activeImage: 'room_icons_living_room_enabled_flutter.png',
          inactiveImage: 'room_icons_living_room_disabled_flutter.png',
          selected: false),*/
    ];
    selectedImageHolidayList = [
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
          activeImage: 'holiday_profile_xmas_enabled.png',
          inactiveImage: 'holiday_profile_xmas_disabled.png',
          selected: false),
      ModelSelectImage(
          activeImage: 'holiday_profile_tent_enabled.png',
          inactiveImage: 'holiday_profile_tent_disabled.png',
          selected: false),
      ModelSelectImage(
          activeImage: 'holiday_profile_traveling_enabled.png',
          inactiveImage: 'holiday_profile_traveling_disabled.png',
          selected: false),
    ];
    if (context.read<EditScheduleProvider>().getScheduleManager.scheduleId ==
        "H") {
      selectedImageList = selectedImageHolidayList;
    } else {
      selectedImageList = selectedImageHeatingList;
    }
    initSelectedImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    return Column(
      children: [
        Text(
          local.chooseImage,
          style: AppTheme.textStyleColored,
        ),
        const SizedBox(
          height: Dimens.sizedBoxBigDefault,
        ),
        Expanded(
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: selectedImageList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10),
            itemBuilder: ((context, index) => SelectRoomImageGridTile(
                selectImage: selectedImageList[index],
                onTap: () {
                  newImageSelected(index);
                })),
          ),
        ),
        const SizedBox(
          height: Dimens.sizedBoxDefault,
        ),
        ClickButtonFilled(
            buttonText: local.selectIcon,
            buttonFunktion: () {
              if (selectedImageName.isNotEmpty) {
                context.read<EditScheduleProvider>().changeImage(
                    TimeScheduleImageMaping()
                        .getMappiedImageName(selectedImageName));
              }
              widget.changeUi();
            },
            width: double.infinity)
      ],
    );
  }

  void initSelectedImage() {
    selectedImageName = TimeScheduleImageMaping().getScheduleToRoom(
        context.read<EditScheduleProvider>().getScheduleManager.scheudleImage);
    print(
        "Image name is ${TimeScheduleImageMaping().getScheduleToRoom(context.read<EditScheduleProvider>().getScheduleManager.scheudleImage)}");
    for (int i = 0; i < selectedImageList.length; i++) {
      if (selectedImageList[i].activeImage == selectedImageName) {
        selectedImageList[i].selected = true;
        break;
      }
    }
  }

  void newImageSelected(int index) {
    if (index > -1 && index < selectedImageList.length) {
      setState(() {
        for (int i = 0; i < selectedImageList.length; i++) {
          if (i != index) {
            selectedImageList[i].selected = false;
          } else {
            selectedImageList[i].selected = true;
          }
        }
        selectedImageList[index].selected = true;
      });
      selectedImageName = selectedImageList[index].activeImage;
    }
  }
}
