import 'package:flutter/material.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/util.dart';

class LoadingIndicator extends StatelessWidget {
  final double strokeWidth;

  const LoadingIndicator({super.key, this.strokeWidth = 1});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: MyColor.colorWhite,
        boxShadow: MyUtils.getCardShadow(),
      ),
      child: const CircularProgressIndicator(
        color: MyColor.primaryColor,
        strokeWidth: 3,
      ),
    );
  }
}
