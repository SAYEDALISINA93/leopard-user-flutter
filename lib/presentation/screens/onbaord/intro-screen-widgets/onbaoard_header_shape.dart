import 'package:flutter/material.dart';

class OnboardHeaderPathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.blue // Change color as desired
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(size.width * 0.63, size.height * 0.84);
    path.cubicTo(size.width * 0.17, size.height * 1.23, size.width * -0.07, size.height * 0.78, size.width * -0.18, size.height * 0.51);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class OnboardHeaderPathPainter2 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color.fromRGBO(68, 109, 255, 0.33) // Change color and opacity as needed
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(size.width * 0.85, size.height * 0.84);
    path.cubicTo(size.width * 0.29, size.height * 1.23, size.width * -0.02, size.height * 0.66, size.width * -0.13, size.height * 0.34);
    path.lineTo(size.width * 1.68, size.height * 0.92);
    path.cubicTo(size.width * 1.74, size.height * 1.11, size.width * 1.78, size.height * 1.47, size.width * 1.40, size.height * 1.17);
    path.cubicTo(size.width * 1.19, size.height * 1.01, size.width * 1.15, size.height * 1.08, size.width * 0.85, size.height * 0.84);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
