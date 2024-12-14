import 'package:flutter/material.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';

import 'custom_svg_picture.dart';

class CircleShapeImage extends StatefulWidget {
  final String image;
  final Color backgroundColor;
  final Color? imageColor;
  final double size;
  final bool isSvgImage;

  const CircleShapeImage(
      {super.key,
      this.backgroundColor = MyColor.screenBgColor,
      this.imageColor,
      this.size = 35,
      required this.image,
      this.isSvgImage = false});

  @override
  State<CircleShapeImage> createState() => _CircleShapeImageState();
}

class _CircleShapeImageState extends State<CircleShapeImage> {
  @override
  Widget build(BuildContext context) {
    return widget.isSvgImage
        ? Container(
            height: widget.size,
            width: widget.size,
            padding: const EdgeInsets.all(Dimensions.space10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: widget.backgroundColor, shape: BoxShape.circle),
            child: CustomSvgPicture(
                image: widget.image,
                color: widget.imageColor ?? MyColor.primaryColor,
                height: widget.size / 2,
                width: widget.size / 2),
          )
        : Container(
            height: widget.size,
            width: widget.size,
            padding: const EdgeInsets.all(Dimensions.space10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: widget.backgroundColor, shape: BoxShape.circle),
            child: Image.asset(widget.image,
                color: widget.imageColor,
                height: widget.size / 2,
                width: widget.size / 2),
          );
  }
}
