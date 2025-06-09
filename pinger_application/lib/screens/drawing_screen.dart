import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/rendering.dart'; // RenderRepaintBoundary
import 'dart:ui' as ui;
import '../services/generate_image.dart';

class DrawingScreen extends StatefulWidget {
  const DrawingScreen({Key? key}) : super(key: key);

  @override
  State<DrawingScreen> createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  List<Offset?> points = [];
  final GlobalKey _canvasKey = GlobalKey();

  Uint8List? generatedImage;
  bool _isLoading = false;

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
    setState(() => _isLoading = true);
    _showLoadingDialog();

    try {
      RenderRepaintBoundary boundary =
          _canvasKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;

      var image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      final pngBytes = byteData!.buffer.asUint8List();

      final base64String = base64Encode(pngBytes);
      final resultImg = await generateImage(base64String);

      Navigator.of(context).pop();
      setState(() => _isLoading = false);

      if (resultImg != null) {
        _showGeneratedImage(resultImg);
      } else {
        _showErrorDialog();
      }
    } catch (e) {
      print('Error: $e');
      Navigator.of(context).pop(); // 로딩 다이얼로그 닫기
      setState(() => _isLoading = false);
      _showErrorDialog();
    }
  }

  // Future<void> saveAsImage() async {
  //   try {
  //     RenderRepaintBoundary boundary =
  //         _canvasKey.currentContext!.findRenderObject()
  //             as RenderRepaintBoundary;

  //     var image = await boundary.toImage(pixelRatio: 3.0);
  //     ByteData? byteData = await image.toByteData(
  //       format: ui.ImageByteFormat.png,
  //     );
  //     final pngBytes = byteData!.buffer.asUint8List();

  //     // base64 변환
  //     final base64String = base64Encode(pngBytes);
  //     // print('Base64 확인: ${base64String.substring(0, 100)}...');
  //     // print('Base64 length: ${base64String.length}');
  //     final resultImg = await generateImage(base64String);

  //     if (resultImg != null) {
  //       _showGeneratedImage(resultImg);
  //     } else {
  //       print("AI 이미지 생성 실패");
  //       _showErrorDialog(); // 선택사항
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // } // saveAsImage

  void _showGeneratedImage(Uint8List imageBytes) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "AI 생성 이미지",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.memory(imageBytes),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close),
              label: const Text("닫기"),
            ),
          ],
        ),
      ),
    );
  } // _showGeneratedImage

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("오류"),
        content: const Text("AI 이미지 생성에 실패했습니다."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("확인"),
          ),
        ],
      ),
    );
  } // _showErrorDialog

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text("이미지 생성 중..."),
          ],
        ),
      ),
    );
  } // _showLoadingDialog
} // _DrawingScreenState

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
