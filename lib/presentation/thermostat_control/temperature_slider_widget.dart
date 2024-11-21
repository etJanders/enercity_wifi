import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:wifi_smart_living/presentation/thermostat_control/temperature_mapping/temperature_mapping.dart';

import '../../theme.dart';

class TemperatureSliderWidget extends StatefulWidget {
  final Function temperatureChanged;
  final String temperature;
  const TemperatureSliderWidget(
      {super.key, required this.temperatureChanged, required this.temperature});

  @override
  State<TemperatureSliderWidget> createState() =>
      _TemperatureSliderWidgetState();
}

class _TemperatureSliderWidgetState extends State<TemperatureSliderWidget> {
  final TemperatureMapping mapping = TemperatureMapping();
  bool animation = true;

  @override
  Widget build(BuildContext context) {
    return SleekCircularSlider(
      initialValue: mapping.getPoinerValue(value: widget.temperature),
      max: 42,
      onChange: (value) {},
      onChangeEnd: (value) {
        widget.temperatureChanged(value.round());
      },
      appearance: CircularSliderAppearance(
        animationEnabled: animation,
        size: 200,
        customColors: CustomSliderColors(
            trackColor: AppTheme.schriftfarbe,
            progressBarColor: AppTheme.violet,
            dotColor: AppTheme.violet,
            hideShadow: true),
        customWidths: CustomSliderWidths(
            trackWidth: 5, progressBarWidth: 6, handlerSize: 10),
        infoProperties: InfoProperties(
          mainLabelStyle: AppTheme.textStyleDefault,
          modifier: (percentage) => percentageModifier(percentage),
        ),
      ),
    );
  }

  String percentageModifier(double value) {
    animation = false;
    final roundedValue = value.round();
    return mapping.getTemperatureValue(progress: roundedValue);
  }
}
