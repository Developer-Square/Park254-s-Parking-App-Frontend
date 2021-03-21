import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/config/globals.dart' as globals;

/// Creates a dotted horizontal line
///
/// E.g.
/// ```dart
/// Center(
///   child: CustomPaint(painter: DotedHorizontalLine(),),
/// ),
/// ```
class DotedHorizontalLine extends CustomPainter {
  Paint _paint;
  DotedHorizontalLine() {
    _paint = Paint()
      ..color = globals.textColor
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
  }


  @override
  void paint(Canvas canvas, Size size) {
    for(double i = -300; i < 300; i = i + 15){
      if(i% 3 == 0)
        canvas.drawLine(Offset(i, 0.0), Offset(i+10, 0.0), _paint);
    }
  }


  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}