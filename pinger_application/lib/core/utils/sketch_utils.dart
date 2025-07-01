import 'dart:ui';
import '../../data/models/sketch_dto.dart';
import '../../domain/models/sketch.dart';

class SketchUtils {
  // Sketch 리스트를 SketchDto 리스트로 변환
  List<SketchDTO> convertSketchesToDTOs(List<Sketch> sketches) {
    return sketches.map((sketch) {
      final points = extractPointsFromPath(sketch.path);
      return SketchDTO(points: points, strokeWidth: sketch.paint.strokeWidth);
    }).toList();
  } // convertSketchesToDTOs

  // Path → List<Offset> 변환 (선형으로만 추출)
  List<Offset> extractPointsFromPath(Path path, {double step = 1.0}) {
    final List<Offset> points = [];
    for (final metric in path.computeMetrics()) {
      for (double i = 0.0; i < metric.length; i += step) {
        final tangent = metric.getTangentForOffset(i);
        if (tangent != null) {
          points.add(tangent.position);
        }
      }
    }
    return points;
  } // extractPointsFromPath

  // List<Offset> → Path 재생성
  Path buildPathFromPoints(List<Offset> points) {
    final path = Path();
    if (points.isNotEmpty) {
      path.moveTo(points.first.dx, points.first.dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
    }
    return path;
  } // buildPathFromPoints

  List<SketchDTO> toDtoList(List<Sketch> sketches) {
    List<SketchDTO> dtos = [];

    for (int i = 0; i < sketches.length; ++i) {
      dtos.add(sketches[i].toDTO());
    }

    return dtos;
  } // toListSketchDTO
} // SketchUtils
