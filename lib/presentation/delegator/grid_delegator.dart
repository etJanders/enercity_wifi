import 'package:flutter/material.dart';

abstract class GridDelegate {
  static const double _crossAccisSpaceing = 10.0;
  static const double _mainAxisSpacing = 10.0;

  static const int _twoAxisCount = 2;
  static const int _singelAcisCount = 1;

  static SliverGridDelegateWithFixedCrossAxisCount createDoubleDelegate(
      {required double aspectRatio}) {
    return SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _twoAxisCount,
        childAspectRatio: aspectRatio,
        crossAxisSpacing: _crossAccisSpaceing,
        mainAxisSpacing: _mainAxisSpacing);
  }

  static SliverGridDelegateWithFixedCrossAxisCount createSingelDelegate(
      {required double aspectRatio}) {
    return SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _singelAcisCount,
        childAspectRatio: aspectRatio,
        crossAxisSpacing: _crossAccisSpaceing,
        mainAxisSpacing: _mainAxisSpacing);
  }
}
