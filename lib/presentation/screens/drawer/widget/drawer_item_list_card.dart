import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../core/utils/dimensions.dart';
import '../../../../core/utils/my_color.dart';
import '../../../../core/utils/style.dart';

class DrawerItem extends StatelessWidget {
  String svgIcon, name;
  Color? iconColor;
  TextStyle? titleStyle;
  VoidCallback onTap;
  final double? size;
  DrawerItem(
      {super.key,
      required this.svgIcon,
      required this.name,
      required this.onTap,
      this.iconColor,
      this.titleStyle,
      this.size = 20});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: Row(
        children: [
          SvgPicture.asset(
            svgIcon,
            fit: BoxFit.contain,
            colorFilter: ColorFilter.mode(
                iconColor ?? MyColor.bodyText, BlendMode.srcIn),
            height: size,
            width: size,
          ),
          const SizedBox(width: Dimensions.space20),
          Expanded(
            child: Text(
              name.tr,
              style: titleStyle ??
                  regularDefault.copyWith(fontSize: Dimensions.fontMedium),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
