import 'package:flutter/material.dart';
import '../../data/models/sketch.dart';

class TouchPainter extends CustomPainter {
  final List<Sketch> sketches;
  final Offset? currentPoint;

  TouchPainter(this.sketches, {this.currentPoint});

  @override
  void paint(Canvas canvas, Size size) {
    for (final sketch in sketches) {
      canvas.drawPath(sketch.path, sketch.paint);
    }

    if (currentPoint != null) {
      final glowPaint = Paint()
        ..color = Colors.black.withValues(alpha: 0.2)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

      canvas.drawCircle(currentPoint!, 16, glowPaint);
    }
  } // paint

  @override
  bool shouldRepaint(covariant TouchPainter oldDelegate) {
    return oldDelegate.sketches != sketches ||
        oldDelegate.currentPoint != currentPoint;
  } // shouldRepaint
}
