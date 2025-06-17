import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/drawing_viewmodel.dart';
import '../viewmodel/drawing_canvas_viewmodel.dart';
import '../widgets/drawing_canvas.dart';

class DrawingView extends StatefulWidget {
  const DrawingView({super.key});

  @override
  State<DrawingView> createState() => _DrawingViewState();
}

class _DrawingViewState extends State<DrawingView> {
  final GlobalKey _canvasKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DrawingViewModel>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleStatus(viewModel);
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Pinger Sketch')),
      body: ChangeNotifierProvider(
        create: (_) => DrawingCanvasViewmodel(),
        child: DrawingCanvas(repaintKey: _canvasKey),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _buildActionButtons(viewModel),
    );
  }

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
            child: const Icon(Icons.check),
          ),
          const SizedBox(width: 12),
          FloatingActionButton(
            heroTag: 'save',
            tooltip: 'save',
            onPressed: () {},
            child: const Icon(Icons.save),
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
    final viewModel = context.read<DrawingViewModel>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("오류"),
        content: const Text("AI 이미지 생성에 실패했습니다."),
        actions: [
          TextButton(
            onPressed: () {
              viewModel.resetStatus();
              Navigator.pop(context);
            },
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
    final viewModel = context.read<DrawingViewModel>();

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
              onPressed: () {
                viewModel.resetStatus();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close),
              label: const Text("닫기"),
            ),
          ],
        ),
      ),
    );
  } // _showGeneratedImage
}
