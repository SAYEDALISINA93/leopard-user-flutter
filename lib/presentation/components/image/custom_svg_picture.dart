import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:leoparduser/core/utils/my_color.dart';

class CustomSvgPicture extends StatelessWidget {
  final String image;
  final double height, width;
  final Color color;
  final BoxFit? fit;

  const CustomSvgPicture({
    super.key,
    this.fit,
    required this.image,
    this.height = 20,
    this.width = 20,
    this.color = MyColor.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return fit != null
        ? SvgPicture.asset(
            image,
            fit: fit!,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            height: height,
            width: width,
          )
        : SvgPicture.asset(
            image,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            height: height,
            width: width,
          );
  }
}
