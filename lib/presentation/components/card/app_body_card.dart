import 'package:flutter/material.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';

class AppBodyWidgetCard extends StatefulWidget {
  final VoidCallback? onPressed;
  EdgeInsetsGeometry? padding;
  EdgeInsetsGeometry? margin;
  final Widget? child;

  AppBodyWidgetCard({
    super.key,
    this.onPressed,
    this.margin,
    this.padding,
    required this.child,
  });

  @override
  State<AppBodyWidgetCard> createState() => _AppBodyWidgetCardState();
}

class _AppBodyWidgetCardState extends State<AppBodyWidgetCard> {
  @override
  Widget build(BuildContext context) {
    return widget.onPressed != null
        ? GestureDetector(
            onTap: widget.onPressed,
            child: Container(
              width: double.infinity,
              margin: widget.margin,
              padding: widget.padding ??
                  const EdgeInsets.symmetric(
                    horizontal: Dimensions.space15 + 1,
                    vertical: Dimensions.space25 - 1,
                  ),
              decoration: BoxDecoration(
                color: MyColor.colorWhite,
                borderRadius: BorderRadius.circular(Dimensions.mediumRadius),
              ),
              child: widget.child,
            ),
          )
        : Container(
            width: double.infinity,
            padding: widget.padding ??
                const EdgeInsets.symmetric(
                  horizontal: Dimensions.space15 + 1,
                  vertical: Dimensions.space25 - 1,
                ),
            margin: widget.margin,
            decoration: BoxDecoration(
              color: MyColor.colorWhite,
              borderRadius: BorderRadius.circular(Dimensions.mediumRadius),
            ),
            child: widget.child,
          );
  }
}
