import '../../domain/models/sketch.dart';
import '../../core/utils/sketch_utils.dart';
import 'package:flutter/material.dart';

class SketchDTO {
  final List<Offset> points;
  final double strokeWidth;

  SketchDTO({required this.points, required this.strokeWidth});

  Map<String, dynamic> toJson() {
    return {
      'points': points.map((e) => {'x': e.dx, 'y': e.dy}).toList(),
      'strokeWidth': strokeWidth,
    };
  } // toJson

  factory SketchDTO.fromJson(Map<String, dynamic> json) {
    return SketchDTO(
      points: (json['points'] as List)
          .map((e) => Offset(e['x'], e['y']))
          .toList(),
      strokeWidth: json['strokeWidth'],
    );
  } // fromJson

  Sketch toDomain() {
    final path = SketchUtils().buildPathFromPoints(points);
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    return Sketch(path: path, paint: paint);
  } // toDomain
} // SketchDTO
