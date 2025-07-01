import 'package:flutter/material.dart';
import '../../data/models/sketch_dto.dart';

class Sketch {
  final Path path;
  final Paint paint;

  Sketch({required this.path, required this.paint});

  SketchDTO toDTO() {
    final strokeWidth = paint.strokeWidth;

    final pathMetrics = path.computeMetrics();
    final List<Offset> points = [];

    for (final metric in pathMetrics) {
      for (double t = 0; t <= metric.length; t += 1) {
        final tangent = metric.getTangentForOffset(t);
        if (tangent != null) {
          points.add(tangent.position);
        }
      }
    } // for

    return SketchDTO(points: points, strokeWidth: strokeWidth);
  } // toDTO
} // Sketch
