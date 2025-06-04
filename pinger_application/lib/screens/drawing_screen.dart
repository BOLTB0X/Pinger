import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/rendering.dart'; // RenderRepaintBoundary
import 'dart:ui' as ui;

class DrawingScreen extends StatefulWidget {
  const DrawingScreen({Key? key}) : super(key: key);

  @override
  State<DrawingScreen> createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  List<Offset?> points = [];
  final GlobalKey _canvasKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pinger Sketch')),
      body: GestureDetector(
        onPanUpdate: (details) {
          RenderBox renderBox = context.findRenderObject() as RenderBox;
          Offset localPosition = renderBox.globalToLocal(
            details.globalPosition,
          );

          //print('touch : $localPosition, point: ${points.length}');

          setState(() {
            points.add(localPosition);
          });
        },
        onPanEnd: (_) {
          //print('pan 확인');
          setState(() {
            points.add(null); // null로 선 분리
          });
        },
        child: RepaintBoundary(
          key: _canvasKey,
          child: Container(
            color: Colors.white, //
            child: CustomPaint(
              painter: SketchPainter(points),
              size: Size.infinite,
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, right: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              heroTag: 'save',
              onPressed: saveAsImage,
              child: const Icon(Icons.save),
            ),
            const SizedBox(width: 16),
            FloatingActionButton(
              heroTag: 'clear',
              onPressed: () {
                setState(() {
                  points.clear();
                });
              },
              child: const Icon(Icons.clear),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Future<void> saveAsImage() async {
    try {
      RenderRepaintBoundary boundary =
          _canvasKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;

      var image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      final pngBytes = byteData!.buffer.asUint8List();

      // base64 변환
      final base64String = base64Encode(pngBytes);
      print('Base64 확인: ${base64String.substring(0, 100)}...');
      print('Base64 length: ${base64String.length}');
    } catch (e) {
      print('Error: $e');
    }
  } // saveAsImage
}

class SketchPainter extends CustomPainter {
  final List<Offset?> points;

  SketchPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    //print('포인트 확인 ${points.whereType<Offset>().length} points');

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant SketchPainter oldDelegate) => true;
}
