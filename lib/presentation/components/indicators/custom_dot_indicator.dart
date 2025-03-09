import 'package:flutter/material.dart';

class CustomDotIndicator extends StatelessWidget {
  final bool isActive;
  final PageController pageController;
  final Color activeColor, inactiveColor;
  final Duration duration;
  final Function? onChanged;

  const CustomDotIndicator(
      {super.key,
      required this.pageController,
      required this.isActive,
      required this.activeColor,
      required this.inactiveColor,
      required this.duration,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration,
      width: isActive ? 18.0 : 18.0,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: 12.0,
      decoration: BoxDecoration(
          color: isActive ? activeColor : inactiveColor,
          borderRadius: BorderRadius.circular(5)),
    );
  }
}
