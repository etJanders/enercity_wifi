import 'package:flutter/material.dart';

import '../../dimens.dart';
import '../../theme.dart';
import '../general_widgets/popup_menu/popup_menu_widget.dart';

class ThermostatOverviewGridTile extends StatelessWidget {
  final String thermostatName;
  final Function onTapCallback;
  final Function menuOptionCalled;
  final bool batteryEmpty;
  final bool errorProfile;
  final bool windowOpen;
  const ThermostatOverviewGridTile(
      {super.key,
      required this.thermostatName,
      required this.batteryEmpty,
      required this.onTapCallback,
      required this.menuOptionCalled,
      required this.errorProfile,
      required this.windowOpen});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTapCallback(),
      child: Container(
        color: AppTheme.hintergrund,
        child: GridTile(
          header: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const SizedBox(width: 5),
                    batteryEmpty
                        ? Image.asset(
                            'assets/images/batterie_fast_leer_kachel.png',
                            width: 24,
                            height: 24,
                          )
                        : const Text(''),
                    batteryEmpty
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
          footer: Container(
            padding: const EdgeInsets.only(left: Dimens.paddingDefault),
            child: GridTileBar(
              title: Text(
                thermostatName,
                textAlign: TextAlign.start,
                style: AppTheme.textStyleWhite,
              ),
            ),
          ),
          child: Image.asset(
            "assets/images/thermostat.png",
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}

abstract class ThermostatMenuOptionHelper {
  static const int editId = 1;
  static const int removeId = 2;
}
