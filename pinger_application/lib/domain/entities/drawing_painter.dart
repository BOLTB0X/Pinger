import 'package:flutter/material.dart';
import '../models/sketch.dart';

class DrawingPainter extends CustomPainter {
  final List<Sketch> sketches;
  final Offset? currentPoint;

  DrawingPainter(this.sketches, {this.currentPoint});

  // Methods
  // ...

  @override
  void paint(Canvas canvas, Size size) {
    canvas.saveLayer(Offset.zero & size, Paint());

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

    canvas.restore();
  } // paint

  @override
  bool shouldRepaint(covariant DrawingPainter oldDelegate) {
    return oldDelegate.sketches != sketches ||
        oldDelegate.currentPoint != currentPoint;
  } // shouldRepaint
} // DrawingPainter
