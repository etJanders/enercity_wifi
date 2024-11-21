import 'package:flutter/material.dart';
import 'package:wifi_smart_living/dimens.dart';

class HomeImage extends StatelessWidget {
  const HomeImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/app_logo.png",
              width: Dimens.homeImagesize,
              height: Dimens.homeImagesize,
            ),
          ],
        ),
      ),
    );
  }
}
