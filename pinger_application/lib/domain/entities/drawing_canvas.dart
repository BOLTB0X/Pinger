import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'drawing_manager.dart';
import 'drawing_painter.dart';

class DrawingCanvas extends StatelessWidget {
  final GlobalKey repaintKey;
  final bool isDrawingEnabled;

  const DrawingCanvas({
    super.key,
    required this.repaintKey,
    this.isDrawingEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final manager = context.watch<DrawingManager>();

    return RepaintBoundary(
      key: repaintKey,
      child: GestureDetector(
        onPanStart: (details) {
          RenderBox box = context.findRenderObject() as RenderBox;
          Offset point = box.globalToLocal(details.globalPosition);
          isDrawingEnabled ? manager.startSketch(point) : null;
        },
        onPanUpdate: (details) {
          RenderBox box = context.findRenderObject() as RenderBox;
          Offset point = box.globalToLocal(details.globalPosition);
          isDrawingEnabled ? manager.addPoint(point) : null;
        },
        onPanEnd: (_) => isDrawingEnabled ? manager.endSketch() : null,
        child: Container(
          color: Colors.white,
          child: CustomPaint(
            painter: DrawingPainter(
              manager.sketches,
              currentPoint: manager.currentDrawingPoint,
            ),
            size: Size.infinite,
          ),
        ),
      ),
    );
  } // build
} // DrawingCanvas
