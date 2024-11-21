import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wifi_smart_living/bloc/add_new_thermostat/add_new_thermostat_bloc.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/models/ui/select_structure_image/model_select_image.dart';
import 'package:wifi_smart_living/presentation/add_new_thermostat/create_new_room/widgets/select_room_image_grid_tile..dart';
import 'package:wifi_smart_living/presentation/general_widgets/click_buttons/click_button_colored.dart';
import 'package:wifi_smart_living/theme.dart';

class SelectRoomImage extends StatefulWidget {
  final Function nextCallback;
  final Function imageSelected;
  const SelectRoomImage(
      {super.key, required this.nextCallback, required this.imageSelected});

  @override
  State<SelectRoomImage> createState() => _SelectRoomImageState();
}

class _SelectRoomImageState extends State<SelectRoomImage> {
  late String selectedImageName = "";
  late List<ModelSelectImage> selectedImageList;

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    return BlocConsumer<AddNewThermostatBloc, AddNewThermostatState>(
      listener: (context, state) {
        if (state is ImageNameAdded) {
          widget.nextCallback();
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            const SizedBox(
              height: Dimens.sizedBoxDefault,
            ),
            Text(
              local.selectImageForRoom,
              style: AppTheme.textStyleColored,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: Dimens.sizedBoxDefault,
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
                    itemBuilder: ((context, index) => SelectRoomImageGridTile(
                        selectImage: selectedImageList[index],
                        onTap: () {
                          newImageSelected(index);
                        })))),
            const SizedBox(
              height: Dimens.sizedBoxDefault,
            ),
            if (selectedImageName.isNotEmpty)
              ClickButtonFilled(
                  buttonText: local.next,
                  buttonFunktion: () {
                    if (selectedImageName.isNotEmpty) {
                      widget.imageSelected(selectedImageName);
                      //Speicher die infos im Bloc
                      BlocProvider.of<AddNewThermostatBloc>(context)
                          .add(SetImageName(imageName: selectedImageName));
                    }
                  },
                  width: double.infinity),
          ],
        );
      },
    );
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
