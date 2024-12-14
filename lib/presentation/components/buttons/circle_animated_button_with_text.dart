import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/style.dart';

class CircleAnimatedButtonWithText extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final String buttonName;
  final double height, width;
  final Color backgroundColor;

  const CircleAnimatedButtonWithText({
    super.key,
    required this.buttonName,
    required this.child,
    required this.onTap,
    this.height = 40,
    this.width = 40,
    required this.backgroundColor,
  });

  @override
  State<CircleAnimatedButtonWithText> createState() =>
      _CircleAnimatedButtonWithTextState();
}

class _CircleAnimatedButtonWithTextState
    extends State<CircleAnimatedButtonWithText>
    with SingleTickerProviderStateMixin {
  late double _scale;
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 500,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    return Center(
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: _tapDown,
        onTapUp: _tapUp,
        child: Transform.scale(
          scale: _scale,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  height: widget.height,
                  width: widget.width,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: widget.backgroundColor, shape: BoxShape.circle),
                  child: widget.child),
              const SizedBox(height: 10),
              Text(widget.buttonName.tr,
                  textAlign: TextAlign.center,
                  style: regularExtraSmall.copyWith(
                      color: MyColor.primaryTextColor,
                      fontWeight: FontWeight.w500))
            ],
          ),
        ),
      ),
    );
  }

  void _tapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _tapUp(TapUpDetails details) {
    _controller.reverse();
  }
}
