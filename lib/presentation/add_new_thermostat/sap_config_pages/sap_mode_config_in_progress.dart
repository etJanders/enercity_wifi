import 'package:flutter/material.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/theme.dart';

class SapModeConfigInProgress extends StatefulWidget {
  final bool dataSent;

  const SapModeConfigInProgress({super.key, required this.dataSent});

  @override
  State<SapModeConfigInProgress> createState() =>
      _SapModeConfigInProgressState();
}

class _SapModeConfigInProgressState extends State<SapModeConfigInProgress>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late String controlerText;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500))
      ..addListener(() {
        setState(() {});
      });
    animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    animationController.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.dataSent
        ? controlerText = "Thermostat wird eingerichtet"
        : controlerText = "Thermostat wurde erfolgreich eingerichtet";
    return Center(
      child: Column(
        children: [
          const SizedBox(
            height: Dimens.sizedBoxBigDefault,
          ),
          Image.asset(
            'assets/images/pairing_mode_activated.png',
            width: 200,
            height: 250,
          ),
          const SizedBox(
            height: Dimens.sizedBoxDefault,
          ),
          widget.dataSent
              ? const LinearProgressIndicator(
                  backgroundColor: AppTheme.hintergrundHell,
                  color: AppTheme.violet,
                  value: 1.0,
                )
              : LinearProgressIndicator(
                  backgroundColor: AppTheme.hintergrundHell,
                  color: AppTheme.violet,
                  value: animationController.value,
                )
        ],
      ),
    );
  }
}
