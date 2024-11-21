import 'package:flutter/material.dart';
import 'package:wifi_smart_living/helper/temperatureMapping/target_temp_helper.dart';
import 'package:wifi_smart_living/theme.dart';

class TargetTemperatureWidget extends StatelessWidget {
  final String temperatur;
  const TargetTemperatureWidget({super.key, required this.temperatur});

  @override
  Widget build(BuildContext context) {
    TargetTempHelper helper = TargetTempHelper(temp: temperatur);
    return temperatur == 'on' || temperatur == 'off'
        ? Text(
            temperatur,
            style: const TextStyle(color: AppTheme.schriftfarbe, fontSize: 20),
          )
        : Row(
            children: [
              SizedBox(
                width: 32,
                height: 32,
                child: Center(
                  child: Text(
                    helper.getFirst(),
                    style: const TextStyle(
                        fontSize: 22,
                        color: AppTheme.schriftfarbe,
                        decoration: TextDecoration.underline),
                  ),
                ),
              ),
              Column(
                children: [
                  const SizedBox(
                    width: 12,
                    height: 11,
                    child: Text(
                      '°',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.schriftfarbe),
                    ),
                  ),
                  SizedBox(
                    width: 12,
                    height: 21,
                    child: Text(
                      helper.getSecond(),
                      style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.schriftfarbe,
                          decoration: TextDecoration.underline),
                    ),
                  )
                ],
              )
            ],
          );
  }
}
