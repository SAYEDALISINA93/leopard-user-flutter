import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:leoparduser/presentation/components/image/custom_svg_picture.dart';

import '../../../../../core/utils/my_color.dart';
import 'circle_image_button.dart';

class CircleButtonWithIcon extends StatelessWidget {
  final IconData icon;
  final Callback press;
  final double padding;
  final String imagePath;
  final Color bg;
  final bool isIcon;
  final bool isAsset;
  final double circleSize;
  final double imageSize;
  final Color iconColor;
  final Color borderColor;
  final double iconSize;
  final bool isSvg;
  final bool isShowBorder;
  final bool isProfile;

  const CircleButtonWithIcon(
      {super.key,
      this.imagePath = '',
      this.isAsset = false,
      this.circleSize = 30,
      this.imageSize = 20,
      this.isSvg = false,
      this.isShowBorder = false,
      this.isIcon = true,
      this.bg = Colors.transparent,
      this.padding = 5,
      required this.press,
      this.iconColor = MyColor.colorWhite,
      this.iconSize = 20,
      this.isProfile = false,
      this.borderColor = MyColor.borderColor,
      this.icon = Icons.clear});

  @override
  Widget build(BuildContext context) {
    return isIcon
        ? GestureDetector(
            onTap: press,
            child: Container(
              padding: EdgeInsets.all(padding),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: bg,
                  border: Border.all(
                      color: borderColor, width: isShowBorder ? 1.5 : 0)),
              child: isSvg
                  ? CustomSvgPicture(
                      image: imagePath,
                      height: iconSize,
                      width: iconSize,
                      color: iconColor,
                    )
                  : Icon(
                      icon,
                      color: iconColor,
                      size: iconSize,
                    ),
            ),
          )
        : GestureDetector(
            onTap: press,
            child: Container(
              height: circleSize,
              width: circleSize,
              padding: EdgeInsets.all(padding),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: bg,
                  border: Border.all(width: .3, color: borderColor)),
              child: isAsset
                  ? CircleAvatar(
                      backgroundColor: MyColor.transparentColor,
                      child: CircleImageWidget(
                        isProfile: isProfile,
                        isAsset: true,
                        imagePath: imagePath,
                        width: imageSize,
                        height: imageSize,
                      ))
                  : CircleAvatar(
                      backgroundColor: MyColor.transparentColor,
                      child: CircleImageWidget(
                        isProfile: isProfile,
                        imagePath: imagePath,
                        height: imageSize,
                        width: imageSize,
                        isAsset: false,
                      ),
                    ),
            ),
          );
  }
}
