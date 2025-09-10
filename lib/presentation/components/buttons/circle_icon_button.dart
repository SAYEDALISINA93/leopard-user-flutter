import 'package:flutter/material.dart';

class CircleIconButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final double height, width;
  final Color backgroundColor;

  const CircleIconButton({
    super.key,
    required this.child,
    required this.onTap,
    this.height = 40,
    this.width = 40,
    required this.backgroundColor,
  });

  @override
  State<CircleIconButton> createState() => _CircleIconButtonState();
}

class _CircleIconButtonState extends State<CircleIconButton> with SingleTickerProviderStateMixin {
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
        child: Transform.scale(
          scale: _scale,
          child: Container(
            height: widget.height,
            width: widget.width,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              shape: BoxShape.circle,
            ),
            child: widget.child,
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
