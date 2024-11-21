import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wifi_smart_living/core/image_mapping/image_name_mapping.dart';
import 'package:wifi_smart_living/provider/edit_room_provider.dart';

import '../../../dimens.dart';
import '../../../models/ui/select_structure_image/model_select_image.dart';
import '../../../theme.dart';
import '../../add_new_thermostat/create_new_room/widgets/select_room_image_grid_tile..dart';
import '../../general_widgets/click_buttons/click_button_colored.dart';

///Description
///Change a room image
///
///Author: J. Anders
///created: 01-02-2023
///changed: 01-02-2023
///
///History:
///
///Notes:
///
class EditRoomImagePage extends StatefulWidget {
  final Function changeUiCallback;
  const EditRoomImagePage({super.key, required this.changeUiCallback});

  @override
  State<EditRoomImagePage> createState() => _EditRoomImagePageState();
}

class _EditRoomImagePageState extends State<EditRoomImagePage> {
  late List<ModelSelectImage> selectedImageList;
  late String selectedImageName;

  @override
  void initState() {
    selectedImageList = [
      ModelSelectImage(
          activeImage: 'room_icon_stairs_enabled_flutter.png',
          inactiveImage: 'room_icon_stairs_disabled_flutter.png',
          selected: false),
      ModelSelectImage(
          activeImage: 'room_icon_bedroom_enabled_flutter.png',
          inactiveImage: 'room_icon_bedroom_disabled_flutter.png',
          selected: false),
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
          activeImage: 'room_icon_wohnzimmer_enabled_flutter.png',
          inactiveImage: 'room_icon_wohnzimmer_disabled_flutter.png',
          selected: false),
      ModelSelectImage(
          activeImage: 'room_icons_living_room_enabled_flutter.png',
          inactiveImage: 'room_icons_living_room_disabled_flutter.png',
          selected: false),
      ModelSelectImage(
          activeImage: 'room_icon_kitchen_two_enabled_flutter.png',
          inactiveImage: 'room_icon_kitchen_two_disabled_flutter.png',
          selected: false),
    ];
    initSelectedImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    return Column(
      children: [
        Text(
          local.choosRoomIcon,
          style: AppTheme.textStyleColored,
          textAlign: TextAlign.center,
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
            buttonText: local.symbolSelected,
            buttonFunktion: () {
              if (selectedImageName.isNotEmpty) {
                context.read<EditRoomProvider>().changeImage(selectedImageName);
              }
              widget.changeUiCallback();
            },
            width: double.infinity)
      ],
    );
  }

  void initSelectedImage() {
    selectedImageName = ImageMapping().getImageNameToShow(
        imageName:
            context.read<EditRoomProvider>().getGroupManagement.groupImage);
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
