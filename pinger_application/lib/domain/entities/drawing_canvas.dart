import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'drawing_manager.dart';
import 'drawing_painter.dart';

class DrawingCanvas extends StatelessWidget {
  final GlobalKey repaintKey;

  const DrawingCanvas({super.key, required this.repaintKey});

  @override
  Widget build(BuildContext context) {
    final manager = context.watch<DrawingManager>();

    return RepaintBoundary(
      key: repaintKey,
      child: GestureDetector(
        onPanStart: (details) {
          RenderBox box = context.findRenderObject() as RenderBox;
          Offset point = box.globalToLocal(details.globalPosition);
          manager.startSketch(point);
        },
        onPanUpdate: (details) {
          RenderBox box = context.findRenderObject() as RenderBox;
          Offset point = box.globalToLocal(details.globalPosition);
          manager.addPoint(point);
        },
        onPanEnd: (_) => manager.endSketch(),
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
