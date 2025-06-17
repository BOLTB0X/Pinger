import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/drawing_canvas_viewmodel.dart';
import 'touch_painter.dart';

class DrawingCanvas extends StatelessWidget {
  final GlobalKey repaintKey;

  const DrawingCanvas({super.key, required this.repaintKey});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DrawingCanvasViewmodel>();

    return Stack(
      children: [
        RepaintBoundary(
          key: repaintKey,
          child: GestureDetector(
            onPanStart: (details) {
              RenderBox box = context.findRenderObject() as RenderBox;
              Offset point = box.globalToLocal(details.globalPosition);
              viewModel.startSketch(point);
            },
            onPanUpdate: (details) {
              RenderBox box = context.findRenderObject() as RenderBox;
              Offset point = box.globalToLocal(details.globalPosition);
              viewModel.addPoint(point);
            },
            onPanEnd: (_) => viewModel.endSketch(),
            child: Container(
              color: Colors.white,
              child: CustomPaint(
                painter: TouchPainter(
                  viewModel.sketches,
                  currentPoint: viewModel.currentDrawingPoint,
                ),
                size: Size.infinite,
              ),
            ),
          ),
        ),

        // 상단 우측 버튼
        Positioned(
          top: 16,
          right: 16,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                color: Colors.black,
                tooltip: '실행 취소',
                onPressed: () {
                  viewModel.undo(); // 뒤로가기
                },
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                color: Colors.black,
                tooltip: '다시 실행',
                onPressed: () {
                  viewModel.redo(); // 다시 실행
                },
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.delete),
                color: Colors.black,
                tooltip: '전체 삭제',
                onPressed: () {
                  viewModel.clear(); // 전체 삭제
                },
              ),
            ],
          ),
        ),
      ],
    );
  } // build
} // DrawingCanvas
