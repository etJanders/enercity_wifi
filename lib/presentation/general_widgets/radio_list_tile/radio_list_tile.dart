import 'package:flutter/material.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/models/database/model_group_management.dart';
import 'package:wifi_smart_living/theme.dart';

class RadioListTileItem extends StatefulWidget {
  final ModelGroupManagement groupManagement;
  final Function itemClicked;
  const RadioListTileItem(
      {super.key, required this.groupManagement, required this.itemClicked});

  @override
  State<RadioListTileItem> createState() => _RadioListTileItemState();
}

class _RadioListTileItemState extends State<RadioListTileItem> {
  bool selected = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selected = !selected;
        });
        widget.itemClicked();
      },
      child: Container(
        color: AppTheme.hintergrund,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(Dimens.paddingDefault),
          child: Row(
            children: [
              AnimatedContainer(
                width: 24,
                height: 24,
                duration: const Duration(milliseconds: 300),
                curve: Curves.fastLinearToSlowEaseIn,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected ? AppTheme.violet : AppTheme.schriftfarbe),
              ),
              const SizedBox(
                width: Dimens.sizedBoxBigDefault,
              ),
              Text(
                widget.groupManagement.groupName,
                style: AppTheme.textStyleDefault,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
