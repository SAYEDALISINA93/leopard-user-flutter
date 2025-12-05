import 'package:flutter/material.dart';
import 'package:leoparduser/core/utils/my_color.dart';

class BottomSheetBar extends StatelessWidget {
  const BottomSheetBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        height: 5,
        width: 50,
        decoration: BoxDecoration(
          color: MyColor.colorGrey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
