///Description
///Image View which can be selected for room or heating profile
///
///Author: J. Anders
///created: 20-12-2022
///changed: 20-12-2022
///
///History:
///
///Notes:
///
class ModelSelectImage {
  final String activeImage;
  final String inactiveImage;
  bool selected;

  ModelSelectImage(
      {required this.activeImage,
      required this.inactiveImage,
      required this.selected});
}
