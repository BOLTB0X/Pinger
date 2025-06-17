import 'package:flutter/material.dart';
import '../../data/models/sketch.dart';
import '../../data/models/path_history.dart';

class DrawingCanvasViewmodel extends ChangeNotifier {
  final PathHistory _history = PathHistory();
  Sketch? _currentSketch;

  // 현재까지 그려진 선과, 그리고 있는 선까지 포함해서 반환
  List<Sketch> get sketches {
    if (_currentSketch == null) return _history.sketches;
    return [..._history.sketches, _currentSketch!];
  }

  Offset? get currentDrawingPoint {
    final metrics = _currentSketch?.path.computeMetrics().toList();
    if (metrics == null || metrics.isEmpty) return null;

    final lastMetric = metrics.last;
    final lastTangent = lastMetric.getTangentForOffset(lastMetric.length);
    return lastTangent?.position;
  }

  // 선 그리기 시작
  void startSketch(
    Offset point, {
    Color color = Colors.black,
    double strokeWidth = 4.0,
  }) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path()..moveTo(point.dx, point.dy);
    _currentSketch = Sketch(path: path, paint: paint);
  }

  // 그리기 중: 새로운 점 추가
  void addPoint(Offset point) {
    _currentSketch?.path.lineTo(point.dx, point.dy);
    notifyListeners(); // 화면 업데이트
  }

  // 그리기 완료
  void endSketch() {
    if (_currentSketch != null) {
      _history.add(_currentSketch!);
      _currentSketch = null;
      notifyListeners();
    }
  }

  // 전체 초기화
  void clear() {
    _history.clear();
    _currentSketch = null;
    notifyListeners();
  }

  // 실행 취소
  void undo() {
    _history.undo();
    notifyListeners();
  }

  // 다시 실행
  void redo() {
    _history.redo();
    notifyListeners();
  }
}
