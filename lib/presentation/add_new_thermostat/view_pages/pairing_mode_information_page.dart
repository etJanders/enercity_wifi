import 'package:flutter/material.dart';
import 'package:wifi_smart_living/presentation/add_new_thermostat/view_pages/pairing_mode_active_page.dart';
import 'package:wifi_smart_living/presentation/add_new_thermostat/view_pages/pairing_mode_not_active_page.dart';

class PairingModeInformationPage extends StatefulWidget {
  final Function nextPageFunction;
  final Function pairingModeActivation;
  const PairingModeInformationPage(
      {super.key,
      required this.nextPageFunction,
      required this.pairingModeActivation});

  @override
  State<PairingModeInformationPage> createState() =>
      _PairingModeInformationPageState();
}

class _PairingModeInformationPageState
    extends State<PairingModeInformationPage> {
  bool reset = false;
  @override
  Widget build(BuildContext context) {
    return reset
        ? PairingModeNotActivePage(deviceResetCallback: changeReset)
        : PairingModeActivePage(
            nextCallback: widget.nextPageFunction,
            resetDeviceCallback: changeReset);
  }

  void changeReset() {
    setState(() {
      reset = !reset;
      widget.pairingModeActivation(reset);
    });
  }
}
