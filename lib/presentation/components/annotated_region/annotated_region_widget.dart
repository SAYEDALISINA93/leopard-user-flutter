import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leoparduser/core/utils/my_color.dart';

class AnnotatedRegionWidget extends StatelessWidget {
  final Widget child;
  final Color? statusBarColor;
  final Color? systemNavigationBarColor;
  final Brightness? statusBarBrightness;
  final Brightness? statusBarIconBrightness;

  final Brightness systemNavigationBarIconBrightness;
  final Color? systemNavigationBarDividerColor;
  final bool useDarkTheme;
  final EdgeInsets? padding;

  const AnnotatedRegionWidget({
    super.key,
    required this.child,
    this.statusBarColor,
    this.statusBarBrightness,
    this.statusBarIconBrightness,
    this.systemNavigationBarIconBrightness = Brightness.dark,
    this.systemNavigationBarColor,
    this.systemNavigationBarDividerColor,
    this.useDarkTheme = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    // Choose between dark and light themes
    final systemUiOverlayStyle = useDarkTheme
        ? SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: statusBarColor ?? MyColor.colorWhite,
            statusBarBrightness: statusBarBrightness ?? Brightness.light,
            statusBarIconBrightness: statusBarIconBrightness ?? Brightness.dark,
            systemNavigationBarColor:
                systemNavigationBarColor ?? MyColor.colorWhite,
            systemNavigationBarIconBrightness:
                systemNavigationBarIconBrightness,
            systemNavigationBarDividerColor: systemNavigationBarDividerColor,
          )
        : SystemUiOverlayStyle.light.copyWith(
            statusBarColor: statusBarColor ?? MyColor.colorWhite,
            statusBarBrightness: statusBarBrightness ?? Brightness.light,
            statusBarIconBrightness: statusBarIconBrightness ?? Brightness.dark,
            systemNavigationBarColor:
                systemNavigationBarColor ?? MyColor.colorWhite,
            systemNavigationBarIconBrightness:
                systemNavigationBarIconBrightness,
            systemNavigationBarDividerColor: systemNavigationBarDividerColor,
          );

    return Container(
      color: systemNavigationBarColor ??
          MyColor.colorWhite, // background for SafeArea padding
      child: Padding(
        padding: padding ??
            EdgeInsets.zero, // Allows custom padding or defaults to zero
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: systemUiOverlayStyle,
          child: SafeArea(
            top: false,
            left: false,
            right: false,
            bottom: true,
            child: child,
          ),
        ),
      ),
    );
  }
}
