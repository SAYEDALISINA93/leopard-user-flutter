import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyLocalImageWidget extends StatelessWidget {
  final String imagePath;
  final double height;
  final double width;
  final double radius;
  final double radiusOfButton;
  final BoxFit boxFit;
  final Widget? errorWidget;
  final Color? imageOverlayColor;
  final VoidCallback? voidCallback;

  const MyLocalImageWidget({
    super.key,
    required this.imagePath,
    this.height = 80,
    this.width = 100,
    this.radius = 0,
    this.radiusOfButton = 0,
    this.boxFit = BoxFit.cover,
    this.imageOverlayColor,
    this.errorWidget,
    this.voidCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: BorderRadius.circular(radiusOfButton),
        onTap: voidCallback == null
            ? null
            : () {
                voidCallback!;
              },
        child: Builder(
          builder: (context) {
            if (imagePath.contains('svg')) {
              if (imageOverlayColor == null) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(radius),
                  child: SvgPicture.asset(
                    imagePath,
                    height: height,
                    width: width,
                    fit: boxFit,
                  ),
                );
              } else {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(radius),
                  child: SvgPicture.asset(
                    imagePath,
                    colorFilter: ColorFilter.mode(
                      imageOverlayColor ?? Colors.transparent,
                      BlendMode.srcIn,
                    ),
                    height: height,
                    width: width,
                    fit: boxFit,
                  ),
                );
              }
            } else {
              if (imageOverlayColor == null) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(radius),
                  child: Image.asset(
                    imagePath,
                    height: height,
                    width: width,
                    fit: boxFit,
                  ),
                );
              } else {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(radius),
                  child: Image.asset(
                    imagePath,
                    color: imageOverlayColor ?? Colors.transparent,
                    height: height,
                    width: width,
                    fit: boxFit,
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
