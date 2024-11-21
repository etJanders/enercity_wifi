import 'package:flutter/material.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/presentation/general_widgets/image_container/home_image.dart';

class SplashImage extends StatelessWidget {
  const SplashImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          HomeImage(),
          Image.asset(
            "assets/images/enercity_logo.png",
            width: Dimens.homeImagesize * 1.5,
          ),
        ],
      ),
    );
  }
}
