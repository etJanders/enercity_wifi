import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wifi_smart_living/presentation/general_widgets/textWidgets/clickebal_text_widget.dart';
import 'package:wifi_smart_living/theme.dart';

import '../../../dimens.dart';

class WiFiInformationBox extends StatelessWidget {
  final String buttonText;
  final String subTitle;
  final String devicePassword;
  const WiFiInformationBox(
      {super.key,
      required this.buttonText,
      required this.subTitle,
      required this.devicePassword});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(Dimens.borderRadius),
          decoration: BoxDecoration(
            color: AppTheme.schriftfarbe,
            border:
                Border.all(color: AppTheme.violet, width: Dimens.borderWidth),
            borderRadius: BorderRadius.circular(Dimens.borderRadius),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.wifi,
                color: AppTheme.violet,
              ),
              const SizedBox(
                width: Dimens.sizedBoxBigDefault,
              ),
              Text(
                buttonText,
                textAlign: TextAlign.center,
                style: AppTheme.textStyleColored,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: Dimens.sizedBoxHalf,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              subTitle,
              style: AppTheme.textStyleColored,
            ),
            ClickedText(
                text: devicePassword,
                textColor: AppTheme.violet,
                onClick: () async {
                  await Clipboard.setData(ClipboardData(text: devicePassword))
                      .then(
                    (value) {
                      if (Platform.isIOS) {
                        return ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Copied to clipboard.',
                                textAlign: TextAlign.center),
                            behavior: SnackBarBehavior.floating,
                            elevation: 0,
                            width: 200,
                            shape: StadiumBorder(),
                          ),
                        );
                      }
                    },
                  );
                  //Todo wurde in zwischenablage kopiert
                  /*
                  Fluttertoast.showToast(
                      msg: local.copiedPassword,
                      toastLength: Toast.LENGTH_SHORT,
                      timeInSecForIosWeb: 1,
                      backgroundColor: AppTheme.hintergrundHell,
                      textColor: AppTheme.schriftfarbe,
                      fontSize: 16.0);*/
                }),
          ],
        ),
      ],
    );
  }
}
