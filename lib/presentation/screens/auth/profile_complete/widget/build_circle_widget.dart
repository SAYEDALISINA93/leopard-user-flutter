import 'package:flutter/material.dart';

class BuildCircleWidget extends StatelessWidget {
  final Widget child;
  final double padding;
  final Color color;

  const BuildCircleWidget({
    super.key,
    required this.child,
    required this.padding,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        padding: EdgeInsets.all(padding),
        color: color,
        child: child,
      ),
    );
  }
}
