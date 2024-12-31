import 'package:flutter_svg/flutter_svg.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:flutter/material.dart';

import 'package:leoparduser/core/utils/my_color.dart';
import 'package:get/get.dart';

class CustomIconButton extends StatelessWidget {
  final String name;
  final String icon;
  Color? textColor;
  Color? iconColor;
  Color? bgColor;
  TextStyle? style;
  double? iconSize;
  bool? isSvg = false;
  bool isOutline;
  final VoidCallback press;

  CustomIconButton({
    super.key,
    required this.name,
    required this.icon,
    required this.press,
    this.textColor,
    this.iconColor,
    this.bgColor,
    this.style,
    this.iconSize = 16,
    this.isSvg = false,
    this.isOutline = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
            color: isOutline
                ? Colors.transparent
                : bgColor ?? MyColor.primaryColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: !isOutline ? Colors.transparent : MyColor.primaryColor,
            )),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isSvg!
                ? SvgPicture.asset(icon,
                    fit: BoxFit.contain,
                    colorFilter: ColorFilter.mode(
                        iconColor ?? MyColor.colorWhite, BlendMode.srcIn),
                    height: iconSize,
                    width: iconSize)
                : Image.asset(
                    icon,
                    height: iconSize,
                    width: iconSize,
                    color: iconColor,
                  ),
            const SizedBox(
              width: Dimensions.space10,
            ),
            Flexible(
              child: Text(
                name.tr,
                overflow: TextOverflow.ellipsis,
                style: style ??
                    boldDefault.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: iconColor ?? MyColor.colorWhite),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
