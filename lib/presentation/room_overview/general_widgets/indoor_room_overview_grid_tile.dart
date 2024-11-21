import 'package:flutter/material.dart';
import 'package:wifi_smart_living/presentation/general_widgets/popup_menu/popup_menu_widget.dart';

import '../../../core/image_mapping/image_name_mapping.dart';
import '../../../dimens.dart';
import '../../../theme.dart';

class RoomOverviewGridTile extends StatelessWidget {
  final String groupName;
  final String image;
  final Function onTapCallback;
  final Function menuOptionCalled;
  final String sollTemperatur;
  final bool batterie;
  final bool heatingProfile;
  final bool holidayProfile;
  final bool activeHeatingProfile;
  final bool errorProfile;
  final bool windowOpen;

  const RoomOverviewGridTile(
      {super.key,
      required this.groupName,
      required this.image,
      required this.onTapCallback,
      required this.menuOptionCalled,
      required this.sollTemperatur,
      required this.batterie,
      required this.heatingProfile,
      required this.holidayProfile,
      required this.activeHeatingProfile,
      required this.errorProfile,
      required this.windowOpen});

  @override
  Widget build(BuildContext context) {
    String shownImage = ImageMapping().getImageNameToShow(imageName: image);

    return InkWell(
      onTap: () => onTapCallback(),
      child: Container(
        color: AppTheme.hintergrund,
        child: GridTile(
          header: Container(
            margin: const EdgeInsets.only(left: 10),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      batterie
                          ? SizedBox(
                              width: 25,
                              height: 25,
                              child: Image.asset(
                                'assets/images/batterie_fast_leer_kachel.png',
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Text(''),
                      batterie
                          ? const SizedBox(width: 5)
                          : const SizedBox(width: 0),
                      const Align(
                        alignment: Alignment.center,
                      ),
                      heatingProfile && activeHeatingProfile
                          ? Image.asset(
                              'assets/images/heizprofil_menu_disabled.png',
                              width: 20,
                              height: 20,
                              color: AppTheme.schriftfarbe,
                            )
                          : const Text(''),
                      heatingProfile && activeHeatingProfile
                          ? const SizedBox(width: 5)
                          : const SizedBox(width: 0),
                      heatingProfile && !holidayProfile && !activeHeatingProfile
                          ? Image.asset('assets/images/heizprofil_menu.png',
                              width: 20,
                              height: 20,
                              color: AppTheme.schriftfarbe)
                          : const Text(''),
                      heatingProfile && !holidayProfile && !activeHeatingProfile
                          ? const SizedBox(width: 5)
                          : const SizedBox(width: 0),
                      heatingProfile && holidayProfile && !activeHeatingProfile
                          ? Image.asset(
                              'assets/images/heizprofil_menu_disabled.png',
                              width: 20,
                              height: 20,
                              color: AppTheme.schriftfarbe)
                          : const Text(''),
                      heatingProfile && holidayProfile && !activeHeatingProfile
                          ? const SizedBox(width: 5)
                          : const SizedBox(width: 0),
                      holidayProfile
                          ? Image.asset('assets/images/holiday_menu.png',
                              width: 20,
                              height: 20,
                              color: AppTheme.schriftfarbe)
                          : const Text(''),
                      holidayProfile
                          ? const SizedBox(width: 5)
                          : const SizedBox(width: 0),
                      errorProfile
                          ? Image.asset(
                              'assets/images/ic_warning.png',
                              width: 20,
                              height: 20,
                            )
                          : const Text(''),
                      errorProfile
                          ? const SizedBox(width: 5)
                          : const SizedBox(width: 0),
                      windowOpen
                          ? Image.asset(
                              'assets/images/window.png',
                              width: 20,
                              height: 20,
                            )
                          : const Text(''),
                      windowOpen
                          ? const SizedBox(width: 5)
                          : const SizedBox(width: 0),
                    ],
                  ),
                ),
                PopupMenuWidget(
                  callback: (value) {
                    menuOptionCalled(value);
                  },
                  icon: const Icon(
                    Icons.more_vert,
                    color: AppTheme.schriftfarbe,
                  ),
                ),
              ],
            ),
          ),
          footer: Container(
            margin: const EdgeInsets.only(
                left: Dimens.paddingDefault, bottom: Dimens.paddingDefault),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sollTemperatur,
                  style: AppTheme.textStyleWhite,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  groupName,
                  style: AppTheme.textStyleWhite,
                )
              ],
            ),
          ),
          child: Image.asset(
            "assets/images/$shownImage",
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}

abstract class MenuOptionHelper {
  static const int editId = 1;
  static const int removeId = 2;
}
