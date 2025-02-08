import 'package:flutter/material.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/style.dart';

class CustomElevatedBtn extends StatelessWidget {
  final String text;
  final void Function() press;
  final double radius;
  final double elevation;
  final Color bgColor;
  final Color textColor;
  final Color shadowColor;
  final double width;
  final double height;
  final Widget? icon;
  final bool isLoading;

  const CustomElevatedBtn({
    super.key,
    required this.text,
    required this.press,
    this.radius = Dimensions.mediumRadius,
    this.elevation = 0,
    this.bgColor = MyColor.primaryColor,
    this.textColor = MyColor.colorWhite,
    this.shadowColor = MyColor.primaryColor,
    this.width = double.infinity,
    this.height = Dimensions.defaultButtonH,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return icon != null
        ? ElevatedButton.icon(
            icon: isLoading ? const SizedBox.shrink() : icon!,
            onPressed: () {
              if (isLoading == false) {
                press();
              }
            }, //
            style: ElevatedButton.styleFrom(
              backgroundColor: bgColor, //
              elevation: elevation, //
              // overlayColor: bgColor.withValues(alpha:0.5),
              shadowColor: shadowColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius)),
              maximumSize: Size.fromHeight(height),
              minimumSize: Size(width, height),
              splashFactory: InkRipple.splashFactory,
            ),
            label: isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: textColor),
                  )
                : Text(
                    text, //
                    style: boldDefault.copyWith(
                      color: textColor,
                    ),
                  ),
          )
        : ElevatedButton(
            onPressed: () {
              if (isLoading == false) {
                press();
              }
            }, //
            style: ElevatedButton.styleFrom(
              backgroundColor: bgColor, //
              elevation: elevation, //
              // overlayColor: bgColor.withValues(alpha:0.5),
              // shadowColor: shadowColor,
              splashFactory: InkRipple.splashFactory,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius)),
              maximumSize: Size.fromHeight(height),
              minimumSize: Size(width, height),
            ),
            child: isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: textColor),
                  )
                : Text(text, //
                    style: boldDefault.copyWith(color: textColor)),
          );
  }
}
