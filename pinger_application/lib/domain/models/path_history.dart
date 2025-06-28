import 'sketch.dart';

/// Undo/Redo 처리를 위한 이력 클래스
class PathHistory {
  final List<Sketch> _sketches = [];
  final List<Sketch> _undone = [];

  List<Sketch> get sketches => List.unmodifiable(_sketches);

  /// 새로운 스케치 추가
  void add(Sketch sketch) {
    _sketches.add(sketch);
    _undone.clear();
  }

  /// 전체 삭제
  void clear() {
    _sketches.clear();
    _undone.clear();
  }

  /// 실행 취소 (undo)
  void undo() {
    if (_sketches.isNotEmpty) {
      _undone.add(_sketches.removeLast());
    }
  }

  /// 다시 실행 (redo)
  void redo() {
    if (_undone.isNotEmpty) {
      _sketches.add(_undone.removeLast());
    }
  }
} // PathHistory
