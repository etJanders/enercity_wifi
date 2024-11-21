// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:wifi_smart_living/models/ui/select_structure_image/model_select_image.dart';

class SelectRoomImageGridTile extends StatelessWidget {
  final ModelSelectImage selectImage;
  final Function onTap;
  const SelectRoomImageGridTile(
      {super.key, required this.selectImage, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: selectImage.selected
            ? Image.asset('assets/images/${selectImage.activeImage}')
            : Image.asset('assets/images/${selectImage.inactiveImage}'),
      ),
    );
  }
}
