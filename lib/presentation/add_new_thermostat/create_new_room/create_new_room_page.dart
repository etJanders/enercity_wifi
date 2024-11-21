import 'package:flutter/material.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/presentation/add_new_thermostat/create_new_room/select_room_image_page.dart';
import 'package:wifi_smart_living/presentation/add_new_thermostat/create_new_room/set_room_name.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreateNewRoomPage extends StatefulWidget {
  const CreateNewRoomPage({super.key});

  @override
  State<CreateNewRoomPage> createState() => _CreateNewRoomPageState();
}

class _CreateNewRoomPageState extends State<CreateNewRoomPage> {
  bool showRoomWidget = true;
  late String clickButtonText;
  late String roomImageName = "";

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    showRoomWidget
        ? clickButtonText = local.next
        : clickButtonText = local.save;
    return Padding(
        padding: const EdgeInsets.all(Dimens.paddingDefault),
        child: showRoomWidget
            ? SelectRoomImage(
                nextCallback: changeRoomWidget,
                imageSelected: setRoomImageName,
              )
            : SetRoomNamePage(roomImageName: roomImageName));
  }

  void setRoomImageName(String imageName) {
    roomImageName = imageName;
  }

  void changeRoomWidget() {
    setState(() {
      showRoomWidget = false;
    });
  }
}
