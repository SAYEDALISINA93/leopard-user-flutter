import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/style.dart';

class DefaultText extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final TextStyle textStyle;
  final int maxLines;
  final Color? textColor;
  final double fontSize;

  const DefaultText(
      {super.key,
      required this.text,
      this.textAlign,
      this.textStyle = regularDefault,
      this.maxLines = 3,
      this.textColor,
      this.fontSize = Dimensions.fontDefault});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.tr,
      textAlign: textAlign,
      overflow: TextOverflow.ellipsis,
      style: textStyle.copyWith(color: textColor, fontSize: fontSize),
      maxLines: maxLines,
    );
  }
}
