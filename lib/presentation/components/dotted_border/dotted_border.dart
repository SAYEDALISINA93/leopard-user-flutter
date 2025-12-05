import 'package:leoparduser/core/utils/my_color.dart';
import 'package:flutter/material.dart';

class DottedLine extends StatelessWidget {
  final double width;
  final double height;
  final Color lineColor;
  const DottedLine({
    super.key,
    this.width = double.infinity,
    this.height = 1,
    this.lineColor = MyColor.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(painter: DottedLinePainter(lineColor)),
    );
  }
}

class DottedLinePainter extends CustomPainter {
  final Color lineColor; // Add a color parameter

  DottedLinePainter(this.lineColor);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = lineColor // Use the specified color
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;

    double dashWidth = 5.0;
    double dashSpace = 3.0;

    double startX = 0.0;
    double endX = size.width;

    double currentX = startX;

    while (currentX < endX) {
      canvas.drawLine(
        Offset(currentX, 0),
        Offset(currentX + dashWidth, 0),
        paint,
      );
      currentX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
