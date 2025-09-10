import 'package:flutter/material.dart';

class CustomCircleAnimatedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final double height, width;
  final Color backgroundColor;

  const CustomCircleAnimatedButton({
    super.key,
    required this.child,
    required this.onTap,
    required this.height,
    required this.width,
    required this.backgroundColor,
  });

  @override
  State<CustomCircleAnimatedButton> createState() => _CustomCircleAnimatedButtonState();
}

class _CustomCircleAnimatedButtonState extends State<CustomCircleAnimatedButton> with SingleTickerProviderStateMixin {
  late double _scale;
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
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
        child: Transform.scale(scale: _scale, child: _animatedButton()),
      ),
    );
  }

  Widget _animatedButton() {
    return Container(
      height: widget.height,
      width: widget.width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        shape: BoxShape.circle,
      ),
      child: widget.child,
    );
  }

  void _tapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _tapUp(TapUpDetails details) {
    _controller.reverse();
  }
}
