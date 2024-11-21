import 'package:flutter/material.dart';

class TabletHelper {
  bool isTablet({required BuildContext context}) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    return shortestSide > 600;
  }
}
