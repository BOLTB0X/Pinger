import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/drawing_viewmodel.dart';
import '../../core/utils/sketch_painter.dart';

class DrawingView extends StatefulWidget {
  const DrawingView({super.key});

  @override
  State<DrawingView> createState() => _DrawingViewState();
}

class _DrawingViewState extends State<DrawingView> {
  final GlobalKey _canvasKey = GlobalKey();
  final List<Offset?> _points = [];

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DrawingViewModel>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleStatus(viewModel);
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Pinger Sketch')),
      body: _buildCanvas(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _buildActionButtons(viewModel),
    );
  }

  Widget _buildCanvas() {
    return RepaintBoundary(
      key: _canvasKey,
      child: GestureDetector(
        onPanUpdate: (details) {
          RenderBox renderBox = context.findRenderObject() as RenderBox;
          Offset localPosition = renderBox.globalToLocal(
            details.globalPosition,
          );
          setState(() {
            _points.add(localPosition);
          });
        },
        onPanEnd: (_) => setState(() {
          _points.add(null);
        }),
        child: Container(
          color: Colors.white, //
          child: CustomPaint(
            painter: SketchPainter(_points),
            size: Size.infinite,
          ),
        ),
      ),
    );
  } // _buildCanvas

  Widget _buildActionButtons(DrawingViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, right: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'generate',
            tooltip: 'Generate',
            onPressed: () async {
              await viewModel.fetchGeneratedImage(_canvasKey, "/generate");
            },
            child: const Icon(Icons.auto_fix_normal),
          ),
          const SizedBox(width: 12),
          FloatingActionButton(
            heroTag: 'complete',
            tooltip: 'Complete',
            onPressed: () async {
              await viewModel.fetchGeneratedImage(_canvasKey, "/complete");
            },
            child: const Icon(Icons.check),
          ),
          const SizedBox(width: 12),
          FloatingActionButton(
            heroTag: 'clear',
            tooltip: 'Clear',
            onPressed: () {
              setState(() => _points.clear());
            },
            child: const Icon(Icons.clear),
          ),
        ],
      ),
    );
  } // _buildActionButtons

  void _handleStatus(DrawingViewModel viewModel) {
    switch (viewModel.status) {
      case DrawingStatus.loading:
        _showLoadingDialog();
        break;
      case DrawingStatus.error:
        Navigator.popUntil(context, (route) => route.isFirst);
        _showErrorDialog();
        break;
      case DrawingStatus.success:
        Navigator.popUntil(context, (route) => route.isFirst);
        if (viewModel.resultImage != null) {
          _showGeneratedImage(context, viewModel.resultImage!);
        }
        break;
      case DrawingStatus.idle:
      default:
        break;
    }
  } // _handleStatus

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

  void _showGeneratedImage(BuildContext context, Uint8List imageBytes) {
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
}
