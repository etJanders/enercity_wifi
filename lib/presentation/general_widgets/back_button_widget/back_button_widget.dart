import 'package:flutter/material.dart';

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: SizedBox(
        width: 28,
        height: 50,
        // decoration: BoxDecoration(
        //     border: Border.all(
        //         color: AppTheme.hintergrundHell,
        //         width: Dimens.borderWidthSmall),
        //     color: AppTheme.hintergrund,
        //     borderRadius: BorderRadius.circular(8)),
        // child: const Icon(
        //   Icons.arrow_back,
        //   color: AppTheme.violet,
        // ),
        child: Image.asset(
          'assets/images/back_icon.png',
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }
}
