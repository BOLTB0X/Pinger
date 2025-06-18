import 'package:flutter/material.dart';
import '../../data/models/sketch.dart';
import '../../data/models/path_history.dart';

class DrawingManager extends ChangeNotifier {
  final PathHistory _history = PathHistory();
  Sketch? _currentSketch;

  List<Sketch> get sketches {
    if (_currentSketch == null) return _history.sketches;
    return [..._history.sketches, _currentSketch!];
  } // sketches

  Offset? get currentDrawingPoint {
    final metrics = _currentSketch?.path.computeMetrics().toList();
    if (metrics == null || metrics.isEmpty) return null;

    final lastMetric = metrics.last;
    final lastTangent = lastMetric.getTangentForOffset(lastMetric.length);
    return lastTangent?.position;
  } // currentDrawingPoint

  // Methods
  // ....

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
  } // startSketch

  void addPoint(Offset point) {
    _currentSketch?.path.lineTo(point.dx, point.dy);
    notifyListeners();
  } // addPoint

  void endSketch() {
    if (_currentSketch != null) {
      _history.add(_currentSketch!);
      _currentSketch = null;
      notifyListeners();
    }
  } // endSketch

  void clear() {
    _history.clear();
    _currentSketch = null;
  } // clear

  void undo() {
    _history.undo();
  } // undo

  void redo() {
    _history.redo();
  } // undo
} // DrawingManager
